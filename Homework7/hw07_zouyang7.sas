/* <Zixin Ouyang> */
/* HW07 Submission */

libname hw07 "C:\440\hw07" access=readonly;
/*Exercise 1*/
title 'Exercise 1';
/*a*/
data nonsales;
 length Employee_ID 6 First_Name $ 12 Last_Name $ 18 Gender $ 1 Salary 8 Job_Titile $ 25
        Country $ 2 Birth_Date 8 Hire_Date 8 ;
 infile 'C:\440\hw07\nonsales.csv' dlm=',' dsd missover;
 input Employee_ID First_Name $ Last_Name $ Gender $ Salary Job_Titile $
       Country $ Birth_Date: Date. Hire_Date: Date.;
 format Birth_Date Hire_Date mmddyy10.;
run;
proc freq data=nonsales;
  tables Employee_ID/noprint out=duplicates(where=(count~=1) drop=percent);
run;
proc print data=duplicates;
run;
/*b*/
proc sort data=nonsales;
  by Employee_ID;
run;
data dupicate_employees;
  merge nonsales(in=Emp)
        duplicates(in=Cons);
  by Employee_ID;
  if Emp=1 and Cons=1;
  keep Employee_ID First_Name Last_Name;
run;
proc print data=dupicate_employees;
run;
/*Exercise 2*/
title 'Exercise 2';
/*a*/
data rushing_zouyang7;
  infile 'C:\440\hw07\nflrush.dat' firstobs=2 ;
  input @1 Season Year.
        @13 Player $25.
        @43 Team $4.
        @56 Games 5.
        @64 Att 3.
        @70 Yds comma5.
        @78 Avg 5.
        @87 YPG 4.
        @97 Lg 2.
        @105 TD 2.
        @113 FD 2.;
  format Yds comma5.
         Avg 5.2
         YPG 5.1;
  label Att='rushing attempts'
        Yds='rushing yards'
        Avg='rushing yards/attempt'
        YPG='rushing yards/game'
        Lg='longest rushing attempt'
        TD='rushing touchdowns'
        FD='rushing firstdowns';
run;
/*b*/
proc contents data=rushing_zouyang7;
run;
/*c*/
proc sort data=rushing_zouyang7;
  by descending YDs;
run;
proc means data=rushing_zouyang7 max noprint;
  class Team;
  var YDs;
  output out=mostYDs(where=(_TYPE_=1)) max=YDs;
run;
proc sort data=mostYDs;
  by descending YDs Team;
run;
proc sort data=rushing_zouyang7;
  by descending YDs Team;
run;
data players;
  merge rushing_zouyang7 (in=rush)
        mostYDs (in=most);
  by descending YDs Team; 
  if rush=1 and most=1;
  keep Team Player YDs;
run;
proc print data=players;
run;
data corrected_players;
  set players;
  if Team='Jax' then delete;
run;
data corrected_rushing;
  set rushing_zouyang7;
  if Team='Jax' then Team='Jac';
run;
proc freq data=corrected_rushing;
  tables Player*Team/noprint out=with_team(where=(count~=0));
run;
proc sort data=corrected_players;
  by Player Team;
run;
proc sort data=with_team;
  by Player Team;
run;
data final_players;
  merge corrected_players(in=plys)
        with_team(in=wtem);
  by Player Team;
  if plys=1 and wtem=1;
  keep Team Player COUNT YDs;
  label COUNT='N seasons with team';
run;
proc print data=final_players label;
run;


