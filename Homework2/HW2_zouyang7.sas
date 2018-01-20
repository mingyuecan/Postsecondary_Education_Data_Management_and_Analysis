/* Zixin Ouyang */
/* HW02 Submission */

libname hw02 'C:\440\hw02' access=readonly;

/* Exercise a */
title 'Exercise a';
proc contents data=hw02.fmli142;
run;
proc contents data=hw02.memi142;
run;
/* Exercise b */
proc format;
   value $urbn '1'='Urban' '2'='Rural';
   value $marital '1'='Married'
                  '2'='Widowed'
                  '3'='Divorced'
                  '4'='Separated'
                  '5'='Never married';
   value $race '1'='White'
               '2'='Black'
               '3'='Native American'
               '4'='Asian'
               '5'='Pacific Islander'
               '6'='Multi-race'
               other='Unknown';
   value $sex '1'='Male' '2'='Female';
   value $relationship '1'='Reference person'
                       '2'='Spouse'
                       '3'='Child/Adopted child'
                       '4'='Grandchild'
                       '5'='In-law'
                       '6'='Brother/Sister'
                       '7'='Mother/Father'
                       '8'='Other'
                       '9'='Unrelated person'
                       '0'='Unmarried Partner';
   value $state '01'='AL' '02'='AK' '04'='AZ' '05'='AR' '06'='CA' '08'='CO'
                '09'='CT' '10'='DE' '11'='DC' '12'='FL' '13'='GA' '15'='HI'
                '16'='ID' '17'='IL' '18'='IN' '20'='KS' '21'='KY' '22'='LA'
                '23'='ME' '24'='MD' '25'='MA' '29'='MI' '30'='MT' '31'='NE'
                '32'='NV' '33'='NH' '34'='NJ' '36'='NY' '37'='NC' '39'='OH'
                '40'='OK' '41'='OR' '42'='PA' '44'='RI' '45'='SC' '46'='SD'
                '47'='TN' '48'='TX' '49'='UT' '51'='VA' '53'='WA' other='Unknown';
   value $education '00', '1'='Never attended school'
                    '10', '2'='First through eighth grade'
                    '11', '3'='Ninth through twelfth grade'
                    '12', '4'='High school graduate'
                    '13', '5'='Some college but no degree'
                    '14', '6'="Associate's degree"
                    '15', '7'="Bachelor's degree"
                    '16', '8'="Master's/professional/doctorate degree"
                    other='Missing';
    value $region '1'='Northeast' '2'='Midwest' '3'='South' '4'='West';
    value salary .='Missing';
run;
/* Exercise c */
data fmli142_zouyang7;
   set hw02.fmli142;
   format BLS_URBN $urbn.
          EDUC_REF EDUCA2 $education.
          MARITAL1 $marital.
          RACE REF_RACE $race.
          SEX_REF SEX2 $sex.
          STATE $state.
          REGION $region.;
   label BLS_URBN="Urban Rural"
         FINCBTAX="CU Income Before Tax"
         FINCATAX="CU Income After Tax"
         PRINEARN="Principal Earner"
         QINTRVMO="Interview Month"
         QINTRVYR="Interview Year"
         HH_CU_Q="CUs in Household"
         HHID="Household Identifier"
         INCLASS="Income Class"
         CUID="CU Identifier"
         INTERI="Interview Number";
run;
data memi142_zouyang7;
   set hw02.memi142;
   format CU_CODE $relationship.
          EDUCA $education.
          MARITAL $marital.
          SEX $sex.
          MEMBRACE $race.
          SALARYX salary.;
   label CU_CODE='Relationship'
         MEMBNO='Person line number';
run;
/* Exercise d */
title 'Exercise d';
proc contents data=fmli142_zouyang7;
run;
proc contents data=memi142_zouyang7;
run;
/* Exercise e */
title 'Exercise e';
proc print data=fmli142_zouyang7(firstobs=1 obs=10) label;
   var NEWID CUID AGE_REF BLS_URBN MARITAL1 FINCATAX;
run;
proc print data=memi142_zouyang7(firstobs=1 obs=10) label;
   var NEWID CU_CODE MARITAL SALARYX;
run;
/* Exercise f */
proc format;
   value salary 30000-70000='Middle Class'
                70000<-<120000= 'Upper Middle Class'
                low-<12000= 'Impoverished'
                120000-high= 'Upper Class'
                other= 'Lower Class'
                . ='Missing';
run;
/* Exercise g */
title 'Exercise g';
proc datasets;
   modify memi142_zouyang7;
   format SALARYX salary.;
quit;
/* Exercise h */
title 'Exercise h';
proc print data=memi142_zouyang7(firstobs=1 obs=10) label;
   var NEWID EDUCA SALARYX;
run;
title;