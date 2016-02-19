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
	getline(parinfile,buffer); getline(parinfile,buffer); is.clear(); is.str(buffer);
	is >> par.trade;
	getline(parinfile,buffer); getline(parinfile,buffer); is.clear(); is.str(buffer);
	is >> par.strategy;

	outfile << "t meta_n emi  mean_info  tr1  tr2  tr3  strategy" << endl;

}

///////////////////////////////////////////////////////////////////////////////////////
//-----------------------------INITIALIZATION FUNCTIONS------------------------------//
///////////////////////////////////////////////////////////////////////////////////////

// initialize an individual (for the foreruns)
void init_individual(tInd *newind, int strategy) {

    if (strategy==1) {
        //T -> simple threshold; not included in the study
        newind->trait[0] = 0.9;
    }
    if (strategy==2) {
        //TL -> linear threshold
        newind->trait[0] = -0.9;
        newind->trait[1] = 1.0;
    }
    if (strategy==3) {
	//TA -> asymptotic threshold
	newind->trait[0] = 0.9;
    }
    if (strategy==4) {
	//TAe	-> extended asymptotic threshold
	newind->trait[0] = 0.9;
	newind->trait[1] = 0.0;
    }
    if (strategy==5) {
	//S	-> sigmoid
	newind->trait[0] = 7.0;//alpha
	newind->trait[1] = 1.5;//beta
	newind->trait[2] = 1.0;//d0
    }

    newind->strategy = strategy;
		newind->info = ran();

}


// initialize the landscape
void init_world(int strategy) {

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
			init_individual(&newind,strategy);
			world[p].indiv.push_back(newind);
		}

	}
}


///////////////////////////////////////////////////////////////////////////////////////
//-------------------------------ANALYZING FUNCTIONS---------------------------------//
///////////////////////////////////////////////////////////////////////////////////////
void analyze(int t) {

	unsigned int meta_n = 0;
	double mean_info = 0;
	double mean_tr1 = 0;
	double mean_tr2 = 0;
	double mean_tr3 = 0;

	for (int p = 0; p < NPATCH; ++p) {
		for (size_t i = 0; i < world[p].indiv.size(); ++i) {
			meta_n++;
			mean_info 	+= world[p].indiv[i].info;
			mean_tr1 	+= world[p].indiv[i].trait[0];
			mean_tr2 	+= world[p].indiv[i].trait[1];
			mean_tr3 	+= world[p].indiv[i].trait[2];

		}
	}

	ana.mean_info.push_back(mean_info/double(meta_n));
	ana.metapopsize.push_back(meta_n);
	ana.times.push_back(t);
	ana.tr1.push_back(mean_tr1/double(meta_n));
	ana.tr2.push_back(mean_tr2/double(meta_n));
	ana.tr3.push_back(mean_tr3/double(meta_n));

}


//_____________________________________________________________________________________
//-Write results-----------------------------------------------------------------------

void write_results() {
	outfile << ana.times.back() << "  " << ana.metapopsize.back() << "  " << double(ana.totaldisp)/double(ana.disp_cnt) << "  " << ana.mean_info.back()
					<< "  " << ana.tr1.back() << "  " << ana.tr2.back() << "  " << ana.tr3.back() << "  " << par.strategy << endl;
}
///////////////////////////////////////////////////////////////////////////////////////
//-------------------------------SIMULATION FUNCTIONS--------------------------------//
///////////////////////////////////////////////////////////////////////////////////////

//_____________________________________________________________________________________
//-Reproduction------------------------------------------------------------------------

void reproduction(int t, bool competition) {

	for (int p=0; p < NPATCH; ++p) {

		// (immigrant) individuals reproduce
		for (size_t i=0; i < world[p].immis.size(); ++i) {
			int nkids = poisson(par.lambda_0 * (1.0 - par.trade * world[p].indiv[i].info));

			for (int k = 0; k < nkids; ++k) {
				tInd kid;
				for (int j = 0; j < 3; ++j) {
					kid.trait[j] = world[p].immis[i].trait[j];
				}
				kid.strategy = world[p].immis[i].strategy;
				kid.info 	= world[p].immis[i].info;
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

				for (int j = 0; j < 3; ++j) {
					if (ran()<r_mut) {
						world[p].kids[k].trait[j] += gauss(VARIANCE);
					}

					if (ran()<r_mut) {
						world[p].kids[k].info += gauss(VARIANCE);
						if (world[p].kids[k].info<0) {world[p].kids[k].info = 0;}
						if (world[p].kids[k].info>1) {world[p].kids[k].info = 1;}
					}
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

	if (ind.strategy==1) {
		if (dens > (ind.trait[0])) {
			emi = 1.0;
		}
	}
	if (ind.strategy==2) {
		emi = ind.trait[1] * dens + ind.trait[0];
	}
	if (ind.strategy==3) {
		if (dens < ind.trait[0]) {
			emi = 0;
		} else {
			emi = 1.0 - ind.trait[0] / dens;
		}
	}
	if (ind.strategy==4) {
		if (dens < ind.trait[0]) {
			emi = 0.0;
		} else {
			emi = 1.0 - ind.trait[0] * (1.0-ind.trait[1])/(dens-ind.trait[0]*ind.trait[1]);
		}
	}
	if (ind.strategy==5) {
		emi = ind.trait[2]/(1.0+exp(-ind.trait[0]*(dens-ind.trait[1])));
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
			double info = world[p].indiv[i].info;
			// at first we draw the guessed density for the individual
			if (info>0.99) {
				n_guess = world[p].indiv.size();
			} else {
				int rp = floor(ran()*NPATCH);
				int rh = floor(ran()*HIRN);
				int rsize = ana.popsize[rh][rp];
				n_guess = info*double(world[p].indiv.size()) + (1-info)*double(rsize);
			}

			// calculating emigration probability
			double emi_prob = dde(world[p].indiv[i],n_guess);

			// stochastic emigration
			if (ran()<emi_prob) {

				if (ran()>par.disp_mort) { // it survives transition, so is stored as immigrant
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

//_____________________________________________________________________________________
//-Write out populations after foreruns------------------------------------------------

void write_out_population(int strategy) {
	string buffer;
	istringstream is;

	stringstream outpath;

	outpath << "populations/pop_" << strategy  << ".in";
	string path = outpath.str();
	fstream popoutfile(path.c_str(), ios::out);

	for (int ind = 0; ind < WRITE_OUT_NO; ++ind) {
		int p = floor(ran()*NPATCH);
		int i = floor(ran()*world[p].indiv.size());
		popoutfile << world[p].indiv[i].trait[0] << "  " << world[p].indiv[i].trait[1] << "  " << world[p].indiv[i].trait[2] << endl;
	}

}

///////////////////////////////////////////////////////////////////////////////////////
//----------------------------------MAIN FUNCTIONS-----------------------------------//
///////////////////////////////////////////////////////////////////////////////////////

//_____________________________________________________________________________________
//-Simulate foreruns-------------------------------------------------------------------

void simulate(int strategy) {

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

	int s = par.strategy;

	world.clear();
	init_world(s);
	simulate(s);

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
