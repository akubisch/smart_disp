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

	outfile << "s1  s2  frac_s1  frac_draw  time_to_decision" << endl;

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

}

// initialize an individual (for the competition runs)
void init_individual(tInd *newind, double t0, double t1, double t2, int strategy) {
	newind->trait[0] = t0;
	newind->trait[1] = t1;
	newind->trait[2] = t2;
	newind->strategy = strategy;
}

// initialize the landscape  (for the foreruns)
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

// initialize the landscape (for the competition runs)
void init_world(int s1, int s2) {

	world.resize(NPATCH);

	// read in the forerun populations

	// 1. strategy 1

	double traits_s1[WRITE_OUT_NO][3];

	string buffer;
	istringstream is;
	stringstream outpath1;
	outpath1 << "populations/pop_" << s1  << ".in";
	string path1 = outpath1.str();
	fstream s1_file(path1.c_str(), ios::in);

	for (int l = 0; l < WRITE_OUT_NO; ++l) {
		getline(s1_file,buffer); is.clear(); is.str(buffer);
		is >> traits_s1[l][0] >> traits_s1[l][1] >> traits_s1[l][2];
	}

	// 2. strategy 2

	double traits_s2[WRITE_OUT_NO][3];

	stringstream outpath2;
	outpath2 << "populations/pop_" << s2  << ".in";
	string path2 = outpath2.str();
	fstream s2_file(path2.c_str(), ios::in);

	for (int l = 0; l < WRITE_OUT_NO; ++l) {
		getline(s2_file,buffer); is.clear(); is.str(buffer);
		is >> traits_s2[l][0] >> traits_s2[l][1] >> traits_s2[l][2];
	}

	for (int p = 0; p < NPATCH; p++) {

		for (int h = 0; h < HIRN; ++h) {
			ana.popsize[h][p] = par.capacity;
		}

		world[p].indiv.clear();
		world[p].immis.clear();
		world[p].kids.clear();

		tInd newind;

		for (int i = 0; i < par.capacity; ++i){
			int j = floor(ran()*WRITE_OUT_NO);
			if (ran()<0.5) {
				init_individual(&newind,
						traits_s1[j][0],
						traits_s1[j][1],
						traits_s1[j][2],
						s1);
			} else {
				init_individual(&newind,
						traits_s2[j][0],
						traits_s2[j][1],
						traits_s2[j][2],
						s2);
			}

			world[p].indiv.push_back(newind);
		}

	}
}

///////////////////////////////////////////////////////////////////////////////////////
//-------------------------------ANALYZING FUNCTIONS---------------------------------//
///////////////////////////////////////////////////////////////////////////////////////

double analyze_competition(int s1, int s2) {

	double frac_s1 = false;

	unsigned int meta_n = 0;
	unsigned int s1_n = 0;

	for (int p = 0; p < NPATCH; ++p) {
		for (size_t i = 0; i < world[p].indiv.size(); ++i) {
			meta_n++;
			if (world[p].indiv[i].strategy == s1) {
				s1_n++;
			}
		}
	}

	frac_s1 = double(s1_n)/double(meta_n);

	return frac_s1;
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
			// for each individual, the number of kids is drawn from a Poisson distribution with mean lambda_0
			int nkids = poisson(par.lambda_0);

			// inheritance
			for (int k = 0; k < nkids; ++k) {
				tInd kid;
				for (int j = 0; j < 3; ++j) {
					kid.trait[j] = world[p].immis[i].trait[j];
				}
				kid.strategy = world[p].immis[i].strategy;
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
		// in the competition runs, we do not allow for any further evolution
		if (competition) {
			r_mut = 0;
		}

		// density-dependent offspring survival
		for (size_t k = 0; k < world[p].kids.size(); ++k) {
			if (ran()<surv) {

				for (int j = 0; j < 3; ++j) {
					if (ran()<r_mut) {
						world[p].kids[k].trait[j] += gauss(VARIANCE);
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
		emi = (1.0+ind.trait[2])/(1.0+exp(-ind.trait[0]*(dens-ind.trait[1])))-ind.trait[2];
	}

	if (ind.strategy==6) {
		emi = ind.trait[0];
	}

	if (emi>1) {emi = 1;}
	if (emi<0) {emi = 0;}

	return emi;
}

// actual dispersal process
void dispersal(int t) {
	double n_guess = 0;

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

		if (t==par.tmax-1) {
			write_out_population(strategy);
		}

	}
}

//______________________________________________________________________________________
//-Competition--------------------------------------------------------------------------

void compete(int s1, int s2) {

	vector<int>	time_to_decision;
	time_to_decision.clear();
	int s1_won = 0;
	int draw = 0;

	for (int rep = 0; rep < par.replications; ++rep) {

		cout << "rep = " << rep << endl;

		world.clear();

		init_world(s1,s2);

		for (int t = 0; t < par.tmax; ++t) {

			dispersal(t);
			reproduction(t,true);
			update_popsizes();

			if (t<par.tmax-1) {
				double frac_s1 = analyze_competition(s1,s2);

				if (frac_s1 < 0.05) {
					time_to_decision.push_back(t);
					break;
				} else {
					if (frac_s1 > 0.95) {
						time_to_decision.push_back(t);
						s1_won++;
						break;
					}
				}
			} else {
				draw++;
				time_to_decision.push_back(par.tmax);
				break;
			}

		}

	}

	double frac_s1_won = double(s1_won)/double(par.replications);
	double frac_draw   = double(draw)/double(par.replications);

	outfile << s1 << "  " << s2 << "  " << frac_s1_won << "  " << frac_draw << "  " << median(time_to_decision) << endl;

}

//______________________________________________________________________________________
//-General loops------------------------------------------------------------------------

void foreruns() {

	cout << "starting forerun simulations..." << endl;

	for (int s = 0; s<5; ++s) {
		cout << "strategy = " << s+1 << endl;
		world.clear();
		init_world(s+1);
		simulate(s+1);
	}

}

void competition() {
	cout << "starting tournaments..." << endl;

	// competition runs for all possible combinations
	compete(2,3);
	compete(2,4);
	compete(2,5);
	compete(3,4);
	compete(3,5);
	compete(4,5);

}

int main() {

	cout.setf(ios_base::scientific);		//exponential data output

	specify_rng(time(NULL));			//random randomization?

	//-reading in parameters
	set_parameters();
	//-some initial foreruns to get the respective optimal strategies
	foreruns();
	//-and finally the competition between all possible pairings of strategies
	competition();

	return 0;
}
