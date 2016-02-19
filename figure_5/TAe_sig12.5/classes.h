/*
 * Simulation model for the study:
 * "Density-dependent emigration: The adequate use of limited information in dispersal decisions"
 * by Poethke, H. J., Kubisch, A., Mitesser, O. & Hovestadt, T.
 *
 * classes.h
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

const int 	NPATCH	= 5000;				//number of habitat patches
const float VARIANCE	= 0.2;      //standard deviation for Gaussian distributed variation
const float MAX_EVOL = 1; //initial strength of mutations
const float EVOL_DECR = 1.5; //decrease rate of evolution strength
const int	HIRN = 5; //how many years of population densities should be stored?
const int	WRITE_OUT_NO = 1000; //this no of individuals will be saved from the forerun
const int TIME_OUT_INT = 100;

class tInd
{
public:
	double  trait[3];		//dispersal traits
	double	strategy;		//which strategy is this individual following?
							//1 - T 	-> simple threshold; not included in the study
							//2 - TL	-> linear threshold
							//3 - TA	-> asymptotic threshold
							//4 - TAe	-> extended asymptotic threshold
							//5 - S		-> sigmoid
	double info; //the amount of information that the individual invests into
};

class tPatch
{
public:
	tPatch();
	vector<tInd> indiv;			//population
	vector<tInd> immis;			//immigrants
	vector<tInd> kids;			//children
	double		 lambda;		//yearly fluctuating growth rate
};

tPatch::tPatch() {
	indiv.clear();
	immis.clear();
	kids.clear();
	lambda = 0;
}

class tParameters
{
public:
	int 	capacity;					//habitat capacity
	double	lambda_0;					//per capita growth rate
	double	disp_mort;					//dispersal mortality
	double	sigma;						//environmental fluctuations
	double	ext_prob;					//extinction rate
	double	mut_prob;					//mutation probability
	int		tmax;						//max. no. of generations to be simulated
	int 	replications;				//number of replicates per experiment
	double  info;					//degree of information
	int strategy;					//which strategy is simulated?
	double	trade;						//trade-off factor between lambda and info
};

class tAnalysis
{
public:
	tAnalysis();
	vector<int> 			times;			//stores all generation times
	vector<unsigned long>	metapopsize;
	unsigned int 			totaldisp;
	unsigned int			disp_cnt;
	unsigned int			popsize[HIRN][NPATCH];
	vector<double>			mean_info;
	vector<double>			tr1;
	vector<double>			tr2;
	vector<double>			tr3;
};

tAnalysis::tAnalysis() {
	mean_info.clear();
	times.clear();
	metapopsize.clear();
	totaldisp = 0;
	disp_cnt = 0;
	tr1.clear();
	tr2.clear();
	tr3.clear();
}
