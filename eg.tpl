DATA_SECTION
	int nobs;
	!! nobs = 10;
	vector age(1,nobs);
	vector len(1,nobs);

PARAMETER_SECTION
	init_number linf;
	init_number vonk;
	init_number to;
	init_number sig;

	!! linf = 100;
	!! vonk = 0.2;
	!!   to = -0.5;
	!!  sig = 0.08;


	objective_function_value objfun;

	vector pre_len(1,nobs);
	vector epsilon(1,nobs);


PRELIMINARY_CALCS_SECTION
	runSimulator();

TOP_OF_MAIN_SECTION


PROCEDURE_SECTION
	
	growth();
	calcObjFun();

FUNCTION growth
	// calculate model variables
	// pre_len = linf*(1.-exp(-vonk*(age-to)));
	// epsilon = (len - pre_len);

	// Use the vonbert class
	vonbert cGrowthModel(linf,vonk,to);
	pre_len = cGrowthModel.calcLength(age);
	epsilon = cGrowthModel.calcResiduals(age,len);
	
	// An array of class objects
	vonbert test[3];  // index from 0-2
	COUT(test[0].getLinf());
	test[2].setLinf(33);
	COUT(test[2].getLinf());
	COUT(test[2].calcLength(age));

FUNCTION calcObjFun
	objfun = dnorm(epsilon,sig);

  

FUNCTION runSimulator
	random_number_generator rng(123);
	dvector epsilon(1,nobs);
	epsilon.fill_randn(rng);
	age.fill_randpoisson(8,rng);
	len = value(linf*(1.-exp(-vonk*(age-to))) + sig*(epsilon));
	
FINAL_SECTION
	COUT(rtime.get_elapsed_time_and_reset());

GLOBALS_SECTION
	#include <admodel.h>
	#undef COUT
	#define COUT(object) cout << #object "\n" << object <<endl
	adtimer rtime;
	
	// Now going to create a vonbert class object for growth models.
	class vonbert
	{
		private:
			dvariable m_linf;
			dvariable m_vonk;
			dvariable m_to;

		public:
		// default constructor
		vonbert()
		{
			m_linf = 999;
			m_vonk = 0.2;
			m_to   = -0.5;
		}

		vonbert(dvariable linf,dvariable vonk,dvariable to)
		{
			m_linf = (linf);
			m_vonk = (vonk);
			m_to   = (to);
		}

		// Method of the class
		dvar_vector calcLength(dvector age)
		{
			return(m_linf*(1.-exp(-m_vonk*(age-m_to))));
		}
		dvar_vector calcResiduals(dvector &age, dvector &len)
		{
			return(len - m_linf*(1.-exp(-m_vonk*(age-m_to))));
		}
		// default destructor
		~vonbert(){};

		// getters
		double getLinf() { return value(m_linf); }

		// setters
		void setLinf(dvariable linf) { m_linf = (linf); }
	};



