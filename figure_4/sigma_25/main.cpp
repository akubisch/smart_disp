/*
 * Simulation model for the study:
 * "Density-dependent emigration: The adequate use of limited information in dispersal decisions"
 * by Poethke, H. J., Kubisch, A., Mitesser, O. & Hovestadt, T.
 *
 * main.cpp
 *
 * Dr. Alexander Kubisch
 * Department of Animal Ecology and Tropical Biology
 * Theoretical Evolutionary Ecology
 * University of Würzburg
 * Würzburg, Germany
 * alexander.kubisch@uni-wuerzburg.de
 * 2016
 * © MIT License
*/


#include <iostream>
#include <cstdlib>							//standard C library
#include <ctime>							//access system time library
#include <fstream>							//file streaming library
#include <cstring>							//string library included
#include <sstream>							//string streaming for reading numbers from
//infiles
#include <vector>
#include <cmath>							//standard math library

#include <gsl/gsl_rng.h>					//gsl random number generator
#include <gsl/gsl_randist.h>				//gsl random distributions
#include <gsl/gsl_statistics.h>				//gsl some statistical methods
#include <gsl/gsl_statistics_int.h>			//gsl some integer statistical methods
#include <gsl/gsl_sort_int.h>				//gsl sort integer arrays
#include <gsl/gsl_math.h>					//provides additional standard math functions

using namespace std;

#include "procedures.h"						//procedure simplifications
#include "classes.h"						//class definitions

//Variables

vector<tPatch> 		world;					//simulated landscape
tParameters	par;							//parameters
tAnalysis 	ana;

fstream 	parinfile("data/para.in", ios::in);		//parameter infile
fstream		outfile("data/output.txt", ios::out);	//result outfile

///////////////////////////////////////////////////////////////////////////////////////
//---------------------------------SET PARAMETERS------------------------------------//
///////////////////////////////////////////////////////////////////////////////////////

void set_parameters() {					//read in standard simulation parameters

	string buffer;
	istringstream is;

	getline(parinfile,buffer); getline(parinfile,buffer); is.clear(); is.str(buffer);
	is >> par.capacity;					//habitat capacity
	getline(parinfile,buffer); getline(parinfile,buffer); is.clear(); is.str(buffer);
	is >> par.lambda_0;					//per capita growth rate
	getline(parinfile,buffer); getline(parinfile,buffer); is.clear(); is.str(buffer);
	is >> par.sigma;					//environmental stochasticity
	getline(parinfile,buffer); getline(parinfile,buffer); is.clear(); is.str(buffer);
	is >> par.disp_mort;				//dispersal mortality
	getline(parinfile,buffer); getline(parinfile,buffer); is.clear(); is.str(buffer);
	is >> par.ext_prob;					//extinction probability
	getline(parinfile,buffer); getline(parinfile,buffer); is.clear(); is.str(buffer);
	is >> par.mut_prob;					//mutation probability
	getline(parinfile,buffer); getline(parinfile,buffer); is.clear(); is.str(buffer);
	is >> par.tmax;						//simulated time
	getline(parinfile,buffer); getline(parinfile,buffer); is.clear(); is.str(buffer);
	is >> par.info;  					//information parameter
	getline(parinfile,buffer); getline(parinfile,buffer); is.clear(); is.str(buffer);
	is >> par.replications;				//no of replications

	outfile << "t  meta_n  emi mean_cth  mean_gamma" << endl;

}

///////////////////////////////////////////////////////////////////////////////////////
//-----------------------------INITIALIZATION FUNCTIONS------------------------------//
///////////////////////////////////////////////////////////////////////////////////////

// initialize an individual (for the foreruns)
void init_individual(tInd *newind) {
    newind->cth = 0.5+0.8*ran();
	  newind->gamma = 0.8+0.2*ran();
}


// initialize the landscape
void init_world() {

	tInd newind;

	world.resize(NPATCH);

	for (int p = 0; p < NPATCH; p++) {

		for (int h = 0; h < HIRN; ++h) {
			ana.popsize[h][p] = par.capacity;
		}

		world[p].indiv.clear();
		world[p].immis.clear();
		world[p].kids.clear();

		for (int i = 0; i < par.capacity; i++){
			init_individual(&newind);
			world[p].indiv.push_back(newind);
		}

	}
}


///////////////////////////////////////////////////////////////////////////////////////
//-------------------------------ANALYZING FUNCTIONS---------------------------------//
///////////////////////////////////////////////////////////////////////////////////////
void analyze(int t) {

	unsigned int meta_n = 0;
	double mean_cth = 0;
	double mean_gamma = 0;

	for (int p = 0; p < NPATCH; ++p) {
		for (size_t i = 0; i < world[p].indiv.size(); ++i) {
			meta_n++;
			mean_cth 	+= world[p].indiv[i].cth;
			mean_gamma 	+= world[p].indiv[i].gamma;

		}
	}

	ana.metapopsize.push_back(meta_n);
	ana.times.push_back(t);
	ana.mean_cth.push_back(mean_cth/double(meta_n));
	ana.mean_gamma.push_back(mean_gamma/double(meta_n));

}


//_____________________________________________________________________________________
//-Write results-----------------------------------------------------------------------

void write_results() {
	outfile << ana.times.back() << "  " << ana.metapopsize.back() << "  " << double(ana.totaldisp)/double(ana.disp_cnt) <<
	"  " << ana.mean_cth.back() << "  " << ana.mean_gamma.back() << endl;
}
///////////////////////////////////////////////////////////////////////////////////////
//-------------------------------SIMULATION FUNCTIONS--------------------------------//
///////////////////////////////////////////////////////////////////////////////////////

//_____________________________________________________________________________________
//-Reproduction------------------------------------------------------------------------

void reproduction(int t, bool competition) {

	for (int p=0; p < NPATCH; ++p) {

		// (immigrant) individuals reproduce next
		for (size_t i=0; i < world[p].immis.size(); ++i) {
			int nkids = poisson(par.lambda_0);

			for (int k = 0; k < nkids; ++k) {
				tInd kid;
				kid.cth = world[p].immis[i].cth;
				kid.gamma = world[p].immis[i].gamma;
				world[p].kids.push_back(kid);
			}
		}

		// calculation of survival probability includes spatiotemporal variation in K
		double surv = double(1)/(double(1)+(par.lambda_0-double(1))*double(world[p].kids.size())/(lognorm(par.capacity,par.sigma)*par.lambda_0));

		// the adult generation is lost from the simulations
		world[p].indiv.clear();
		world[p].immis.clear();

		// mutation rate decreases temporally
		double r_mut = par.mut_prob * exp(-double(10)*double(t)/double(par.tmax));

		// density-dependent offspring survival
		for (size_t k = 0; k < world[p].kids.size(); ++k) {
			if (ran()<surv) {

				if (ran()<r_mut) {
					world[p].kids[k].cth += gauss(VARIANCE);
				}
				if (ran()<r_mut) {
					world[p].kids[k].gamma += gauss(VARIANCE);
					if (world[p].kids[k].gamma<0) {world[p].kids[k].gamma = 0;}
					if (world[p].kids[k].gamma>1) {world[p].kids[k].gamma = 1;}
				}

			} else {
				world[p].kids[k] = world[p].kids.back();
				world[p].kids.pop_back();
				k--;
			}
		}

		// offspring become the new adults
		world[p].indiv = world[p].kids;
		world[p].kids.clear();
	}

}

//_____________________________________________________________________________________
//-Dispersal---------------------------------------------------------------------------

// computation of emigration probability in dependence of the strategy
double dde(tInd ind, double n_guess) {

	double emi = 0.0;
	double dens = n_guess/double(par.capacity);

		if (dens < ind.cth) {
			emi = 0.0;
		} else {
			emi = 1.0 - ind.cth * (1.0-ind.gamma)/(dens-ind.cth*ind.gamma);
		}

	if (emi>1) {emi = 1;}
	if (emi<0) {emi = 0;}

	return emi;
}

// actual dispersal process
void dispersal(int t) {
	double n_guess = 0;
	ana.totaldisp = 0;
	ana.disp_cnt = 0;

	for (int p=0; p < NPATCH; ++p) {
		for (size_t i=0; i < world[p].indiv.size(); ++i) {
			// at first we draw the guessed density for the individual
			if (par.info>0.99) {
				n_guess = world[p].indiv.size();
			} else {
				int rp = floor(ran()*NPATCH);
				int rh = floor(ran()*HIRN);
				int rsize = ana.popsize[rh][rp];
				n_guess = par.info*double(world[p].indiv.size()) + (1-par.info)*double(rsize);
			}

			// calculating emigration probability
			double emi_prob = dde(world[p].indiv[i],n_guess);
			ana.disp_cnt++;

			// stochastic emigration
			if (ran()<emi_prob) {
				ana.totaldisp++;

				if (ran()>par.disp_mort) { // it survives transition, so is stored as immigrant in another patch
					int target = floor(ran()*NPATCH);
					world[target].immis.push_back(world[p].indiv[i]);
				}
			} else { // if it didn't decide to emigrate, it is stored in the home patch
				world[p].immis.push_back(world[p].indiv[i]);
			}

		}
	}
}

void update_popsizes() {
	for (int h = 0; h < HIRN-1; ++h) {
		for (int p = 0; p < NPATCH; ++p) {
			ana.popsize[h][p] = ana.popsize[h+1][p];
		}
	}

	for (int p = 0; p < NPATCH; ++p) {
		ana.popsize[HIRN-1][p] = world[p].indiv.size();
	}
}

///////////////////////////////////////////////////////////////////////////////////////
//----------------------------------MAIN FUNCTIONS-----------------------------------//
///////////////////////////////////////////////////////////////////////////////////////

//_____________________________________________________________________________________
//-Simulate foreruns-------------------------------------------------------------------

void simulate() {

	for (int t = 0; t < par.tmax; t++) {

		cout << "t = " << t << endl;

		dispersal(t);
		reproduction(t,false);
		update_popsizes();

		if (t%TIME_OUT_INT==0) {
			analyze(t);
			write_results();
		}

	}
}


//______________________________________________________________________________________
//-General loops------------------------------------------------------------------------

void simrun() {

	world.clear();
	init_world();
	simulate();

}

int main() {

	cout.setf(ios_base::scientific);		//exponential data output

	specify_rng(time(NULL));			//random randomization?

	//-reading in parameters
	set_parameters();
	//-finally running the simulation
	simrun();

	return 0;
}
