/* <Zixin Ouyang> */
/* HW03 Submission */

libname hw03 'C:\440\hw03' access=readonly;
/* Exercise 1 */
title 'Exercise 1';
proc format;
   value $statefmt 'NSW'='New South Wales'
                   'QLD'='Queensland'
                   'VIC'='Victoria'
                   other='other';
   value $sexfmt 'M'='Male'
                 'F'='Female'
                 other='Miscoded';
   value $statusfmt 'A'='Alive'
                    'D'='Dead'
                    other='Miscoded';
run;
data AUaids_zouyang7;
   length Observation_Number $ 4 Origin_State $ 15 Sex $ 6 Diagnosis_Date 8
         Ending_Date 8 Ending_Status $ 5 Transmission_Category $ 5 Diagnosis_Age $ 2;
   infile 'C:\440\hw03\AUaids.dat' dlm=' ';
   input Observation_Number Origin_State $ Sex $ Diagnosis_Date 
         Ending_Date Ending_Status $ Transmission_Category $ Diagnosis_Age;
   label Observation_Number='Ob_NO'
         Ending_Status='Status'
         Transmission_Category='Transmission'
         Diagnosis_Age='Age';
   format Origin_State $statefmt.
          Sex $sexfmt.
          Ending_Status $statusfmt.
          Diagnosis_Date mmddyy10.
          Ending_Date mmddyy10.;
run;
proc print data=AUaids_zouyang7(firstobs=1 obs=10) label noobs;
   where Origin_State='QLD';
run;
data under26_zouyang7;
   length Observation_Number $ 4 Origin_State $ 15 Sex $ 6 Diagnosis_Date 8
         Ending_Date 8 Ending_Status $ 5 Transmission_Category $ 5 Diagnosis_Age $ 2;
   infile 'C:\440\hw03\AUaids.dat' dlm=' ';
   input Observation_Number Origin_State $ Sex $ Diagnosis_Date 
         Ending_Date Ending_Status $ Transmission_Category $ Diagnosis_Age;
   if Diagnosis_Age<=25 and Sex='M';
   label Observation_Number='Ob_NO'
         Ending_Status='Status'
         Transmission_Category='Transmission'
         Diagnosis_Age='Age';
   format Origin_State $statefmt.
          Sex $sexfmt.
          Ending_Status $statusfmt.
          Diagnosis_Date mmddyy10.
          Ending_Date mmddyy10.;
run;
proc print data=under26_zouyang7 label noobs;
run;
/* Exercise 2 */
title 'Exercise 2';
data sleep_zouyang7;
   length Species $ 30 BodyWt 8 BrainWt 8 Slow 4 Para 4 Total 4
          LifeSpan 4 Gestation 4 Pred $ 1 Exposure $ 1 Danger $ 1;
   infile 'C:\440\hw03\sleep.dat' dlm=',' dsd truncover;
   input Species $ BodyWt BrainWt Slow Para Total 
         LifeSpan Gestation Pred $ Exposure $ Danger $;
   format BodyWt BrainWt comma8.2
          Slow Para Total 4.1 ;
   label Species='species_name'
         BodyWt='body_weight'
         BrainWt='brain_weight'
         Slow='slow_wave_sleep'
         Para='paradoxical_sleep'
         Total='total_sleep'
         Pred='predation'
         Exposure='sleep_exposure'
         Danger='overall_danger';
run;
proc contents data=sleep_zouyang7;
run;
data big_zouyang7;
   set sleep_zouyang7;
   where BodyWt>=150 and BrainWt>80;
   keep Species BodyWt BrainWt;
run;
proc print data=big_zouyang7 label noobs;
run;
data nottired_zouyang7;
   set sleep_zouyang7;
   if Slow='-999.0' then delete;
   if Para='-999.0' then delete;
   if Total='-999.0' then delete;
   where Slow<6 or Total<6;
   keep Species Slow Para Total;
run;
proc print data=nottired_zouyang7 label noobs;
run;
title;













