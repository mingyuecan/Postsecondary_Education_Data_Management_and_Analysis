libname project "~/440/project";

*Reading the raw data 1;
data work.fp;
	infile '~/440/Project/postscndryunivsrvy2013dirinfo_cleaned.csv' firstobs=2 delimiter=',' missover dsd;
	length INSTNM $ 100 CITY $ 30 ZIP $ 30 CHFNM $ 100 CHFTITLE $ 100;
	input UNITID INSTNM $ ADDR $ CITY $ STABBR $ ZIP $ FIPS OBEREG CHFNM $ CHFTITLE $;
	keep UNITID INSTNM CITY STABBR ZIP CHFNM CHFTITLE;
	label INSTNM = 'Institution Name'
			CHFNM = 'Chief Name'
			CHFTITLE = 'Chief Title'
			STABBR = 'State or Region'
			UNITID = 'Institute ID'
			City = 'City'
			ZIP = 'Zip Code';
run;

*Reading the raw data 2;
data work.scores;
	infile '~/440/Project/Most-Recent-Cohorts-Scorecard-Elements.csv' firstobs=2 missover dsd;
	input UNITID OPEID OPEID6 INSTNM $ CITY $ STABBR $ INSTURL $ NPCURL $ HCM2 PREDDEG CONTROL LOCALE HBCU PBI ANNHI TRIBAL
		 AANAPII HSI NANTI MENONLY WOMENONLY RELAFFIL SATVR25 SATVR75 SATMT25 SATMT75 SATWR25 SATWR75 SATVRMID SATMTMID
		 SATWRMID ACTCM25 ACTCM75 ACTEN25 ACTEN75 ACTMT25 ACTMT75 ACTWR25 ACTWR75 ACTCMMID ACTENMID ACTMTMID ACTWRMID
		 SAT_AVG SAT_AVG_ALL;
	keep UNITID SATVRMID SATMTMID SATWRMID ACTCMMID ACTENMID ACTMTMID SAT_AVG_ALL;
	label UNITID = 'Institution ID'
			SATVRMID = 'SAT Reading Median'
			SATMTMID = 'SAT Math Median'
			SATWRMID = 'SAT Writing Median'
			ACTENMID = 'ACT English Median'
			ACTMTMID = 'ACT Math Median'
			ACTCMMID = 'ACT Science Median'
			SAT_AVG_ALL = 'SAT Average';
run;

data work.scores2;
	set work.scores;
	ACT_AVG_ALL = sum(ACTENMID,ACTMTMID,ACTCMMID) / 3;
	label ACT_AVG_ALL = 'ACT Average';
	format ACT_AVG_ALL 2.;
run;


*merging one-to-one;
proc sort data = work.fp
	out = work.fpsorted;
	by UNITID;
run;

proc sort data = scores2
	out = work.scoressorted;
	by UNITID;
run;

data work.merged;
	merge fp scores2;
	by UNITID;
	if INSTNM = ' ' then delete;
run;

*Keep only the first 5 digits in ZIP (cleaning);
data work.merged2;
	set work.merged;
	ZIP5 = substr(left(ZIP),1,5);
	label ZIP5 = 'Zip Code';
	drop ZIP;
run;

*Checking for errors;
title 'Missing Values';
proc print data = work.merged2;
	var UNITID INSTNM CITY STABBR CHFNM CHFTITLE ZIP5;
	where UNITID = . or
		INSTNM = ' ' or
		CITY = ' ' or
		STABBR = ' ' or
		CHFNM = ' ' or
		CHFTITLE = ' ' or
		ZIP5 = ' ';
run;

title 'Frequencies';
proc freq data = work.merged2 nlevels;
	tables CHFTITLE STABBR;
run;
title;

*Replace 'N/A' with missing values (cleaning);
data work.merged2;
	set work.merged2;
	if CHFNM = ' ' then CHFNM = 'N/A';
	if CHFTITLE = ' ' then CHFTITLE = 'N/A';
	if CHFTITLE = 'ANNMARIE DIORIO' then CHFTITLE = 'N/A';
	if CHFTITLE= 'Jan Haner' then CHFTITLE='N/A';
	if CHFTITLE='Gueverra' then do; CHFNM='Jonathan Gueverra'; CHFTITLE='N/A'; end;
	if CHFTITLE='Bettendorf' then do; CHFNM='Suzanne Bettendorf'; CHFTITLE='N/A'; end;
	if CHFTITLE='Allen' then do; CHFNM='Anthony Allen'; CHFTITLE='N/A'; end;
	if CHFTITLE='Dr.' then do; CHFNM='Dr. Paul R. Brown'; CHFTITLE='N/A'; end;
	if CHFTITLE='Emerald' then do; CHFNM='Jon Emerald'; CHFTITLE='N/A'; end;
	if CHFTITLE='Ledesma' then do; CHFNM='John Ledesma'; CHFTITLE='N/A'; end;
	if CHFTITLE='Terri Parker' then CHFTITLE='N/A';
	if CHFTITLE='font' then do; CHFNM='Marta Font'; CHFTITLE='N/A'; end;
	if CHFTITLE='Hickman' then do; CHFNM='Jared Hickman'; CHFTITLE='N/A'; end;
	if CHFTITLE='Miller' then do; CHFNM='Marla Miller'; CHFTITLE='N/A'; end;
	if CHFTITLE='Jo Anne R. Mutia, RN' then CHFTITLE='N/A';
	CHFNM = propcase(CHFNM);
run;

*Proc contents for description of merged data set;
proc contents data=work.merged2;
run;


***Do-loop;
*This shows average ACT score by state using an iterative do loop;
*Delete schools that don't release test scores;
data test_scores;
	set work.merged2;
	if ACT_AVG_ALL =. then delete;
	if SAT_AVG_ALL =. then delete;
run;
proc sort data=work.test_scores;
	by STABBR;
run;
*Use do loop to find average test scores by state;
data Tests_by_state;
	set work.test_scores;
	by STABBR;
	if First.STABBR then do;
		ACT_Total=0;
		SAT_Total=0;
		Count=0;
	end;
	ACT_Total+ACT_AVG_ALL;
	SAT_Total+SAT_AVG_ALL;
	Count+1;
	if Last.STABBR then do;
		State_AVG_ACT=ACT_Total/Count;
		State_AVG_SAT=SAT_Total/Count;
		output;
	end;
	keep STABBR State_AVG_ACT State_AVG_SAT;
	format State_AVG_ACT 2. State_AVG_SAT 4.;
	label State_AVG_ACT='Average ACT Per State/Region'
		  State_AVG_SAT='Average SAT Per State/Region';
run;

title 'ACT and SAT Scores by Region';
proc print data=Tests_by_state label;
Run;

*Use Proc SQL to find institutions with highest ACT scores per state/territory;
title 'Institution With Highest Average ACT Scores Per State/Territory';
proc sql;
     select STABBR, ACT_AVG_ALL, INSTNM
          from work.merged2
          group by STABBR
          having ACT_AVG_ALL=max(ACT_AVG_ALL) 
          and ACT_AVG_ALL ne .;
quit;

title;
