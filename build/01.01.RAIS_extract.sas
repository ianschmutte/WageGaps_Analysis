/*****************************************************************************
RAIS_extract
Ian M. Schmutte
2022-10-19

Extract data for estimating wage gaps

*****************************************************************************/
/*librefs, options, etc*/  
  %INCLUDE "./lib/header.sas";

/*Load macros to validate worker and plant ids*/
  %INCLUDE "./lib/br_id_validation_macros.sas";

/*Load formats for industries, occupations, etc.*/
  %INCLUDE "./lib/br_formats.sas";

/*****************************************************************************/

/*create view with all years of data stacked together.*/
%macro stackup;
data INTERWRK.irais_jobstack / view=INTERWRK.irais_jobstack;
  set 
  %DO yr=2003 %TO 2017;
    IRAIS.rais_match_uniq_&yr.
  %END;
  ;
run;

data INTERWRK.irais_plantstack / view=INTERWRK.irais_plantstack;
  set 
  %DO yr=2003 %TO 2017;
    IRAIS.rais_plant_uniq_&yr.
  %END;
  ;
run;
%mend;

%stackup;

/*SELECT WORKERS*/
%macro selectworkers;
data INTERWRK.selected_workers;
  set IRAIS.race_gender_age_best;
run;

proc sort data = INTERWRK.selected_workers;
  by PIS;
run;

proc contents data = INTERWRK.selected_workers;
run;

%mend;
%selectworkers;


%macro selectjobs;

%let inlist = PIS PLANT_ID YEAR CONTRACT_TYPE HIRE_DATE
                                     EARN_AVG_MONTH_NOM EARN_DEC_NOM NUM_HOURS_CONTRACTED
                                     TYPE_OF_HIRE CAUSE_OF_SEP MONTH_OF_SEP OCCUP_CBO2002 TENURE_MONTHS
                                     RACE GENDER;

data INTERWRK.select_jobs(keep= PIS year PLANT_ID
								CNAE20_CLASS MUNI ESTAB_SIZE_DEC31
                                age_31Dec race_mode male_mode
                                RACE GENDER male
                                race_white race_pardo race_preto race_other
                                EARN_AVG_MONTH_REAL EARN_DEC_REAL
                                NUM_HOURS_CONTRACTED
                                TYPE_OF_HIRE
                                HIRE_DATE CAUSE_OF_SEP MONTH_OF_SEP DAY_OF_SEP
                                OCCUP_CBO2002 TENURE_MONTHS
                                CONTRACT_TYPE
                      				 );
	array cpi{2003:2017} _temporary_;
	b=0;
	if _n_=1 then do;
		do until (b=1);
			set EXTERNAL.brazil_cpi_vector;
			array cpi_temp{2003:2017} cpi2003--cpi2017;
			do yr = 2003 to 2017;
				cpi{yr} = cpi_temp{yr};
			end;
			b=1;
		end;
		if 0 then set INTERWRK.selected_workers 
					  fastwrk2.irais_plantstack;
         	
         	declare hash pltchars(dataset: 'INTERWRK.irais_plantstack',
         							ordered: 'no');
         	pltchars.definekey ("plant_id", "year");
         	pltchars.definedata("CNAE20_CLASS","MUNI","ESTAB_SIZE_DEC31","ESTAB_TYPE");
         	pltchars.definedone();

         	declare hash wrkchars(dataset: 'INTERWRK.selected_workers',
         							ordered: 'ascending');
         	wrkchars.definekey ("PIS");
         	wrkchars.definedata("age_31Dec2003_mode","race_mode","male_mode");
         	wrkchars.definedone();   		
	end;
	set 
      %DO yr=2003 %TO 2010;
        IRAIS.rais_match_uniq_&yr.(keep=&inlist.  DAY_OF_SEP)
      %END;
      %DO yr=2012 %TO 2013;
        IRAIS.rais_match_uniq_&yr.(keep=&inlist.)
      %END;
      %DO yr=2014 %TO 2017;
        IRAIS.rais_match_uniq_&yr.(keep=&inlist.  DAY_OF_SEP)
      %END;
    ;
  rc1 = wrkchars.find();
  /* only keep processing if worker was found */
	if rc1 = 0 then do;
        rc2 = pltchars.find();
        /*only keep processing if plant was found*/
        region = substr(muni,1,1);
        state = substr(muni,1,2);
        /* if rc2 = 0 and (state = "43") then do; */
        if rc2 = 0 then do;
        
            age_31Dec = input(year,4.)-2003 + age_31Dec2003_mode;

            /*MAKE EARNINGS REAL (2015 REAIS)*/
            EARN_AVG_MONTH_REAL = EARN_AVG_MONTH_NOM/cpi{input(year,4.)};
            EARN_DEC_REAL = EARN_DEC_NOM/cpi{input(year,4.)};
            

            male = GENDER = "M";
            race_white = RACE = "02";
            race_pardo = RACE = "08";
            race_preto = RACE = "04";
            race_other = race_white + race_pardo + race_preto = 0;


            label EARN_AVG_MONTH_REAL = 'Inflation Adjusted Monthly Earnings - 2015 Reais'
                EARN_DEC_REAL = 'Inflation Adjusted December Earnings - 2015 Reais'
                age_31Dec = 'Age on Dec. 31 based on modal date of birth reported for this PIS'
                male = "Employer reported gender is male"
                race_white = "Employer reported race is white"
                race_pardo = "Employer reported race is pardo"
                race_preto = "Employer reported race is preto"
                race_other = "Employer reported some other race or race missing"
                ;

            /*Select observations with valid identifiers/key variables. Note we impose plant size >0 workers (stock)*/
            /*validate PIS and PLANT_ID*/
            %validate_pis(PIS);
            %validate_cnpj(PLANT_ID);
            if (PIS_valid = 1 
            and PLANT_ID_valid = 1
                and input(ESTAB_SIZE_DEC31,2.) > 0 
                and CONTRACT_TYPE  not in ("30","31","35","50")
                ) 
            then output; 
        end;
    end;    
run;

%MEND;
%selectjobs;

proc contents data = INTERWRK.select_jobs;
run;

proc print data = INTERWRK.select_jobs (obs=20);
run;

proc freq data = INTERWRK.select_jobs;
  tables PIS_valid PLANT_ID_valid ESTAB_SIZE_DEC31;
run;

proc means data = INTERWRK.select_jobs;
  var age_31Dec TENURE_MONTHS NUM_HOURS_CONTRACTED;
run;

proc univariate data= INTERWRK.select_jobs;
  var EARN_AVG_MONTH_REAL EARN_DEC_REAL;
run;

proc sort data = INTERWRK.select_jobs;
  by PIS year;
run; 

/*assign dominant jobs and attach education*/
data DBOUT.RAIS_data_extract;
  merge INTERWRK.select_jobs(in = left)
        IRAIS.educ_best(keep = pis year educ_best in = right);
  by PIS year;
  if left;
run;

proc contents data = DBOUT.RAIS_data_extract;
run;

proc UNIVARIATE data = DBOUT.RAIS_data_extract;
  var EARN_AVG_MONTH_REAL EARN_DEC_REAL;
run;

proc means data = DBOUT.RAIS_data_extract;
  var age_31Dec educ_best;
  class year;
run;
