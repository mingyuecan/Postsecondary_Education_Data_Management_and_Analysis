/* <Zixin Ouyang> */
/* HW04 Submission */

libname hw04 "C:\440\hw04" access=readonly;
/* Exercise 1 */
title 'Exercise 1';
data rushing_zouyang7;
  infile 'C:\440\hw04\nflrush.dat' firstobs=2 ;
  input @1 Season Year.
        @13 Player $25.
        @43 Team $4.
        @70 Yds comma5.
        @78 Avg 5.
        @97 Lg 2.
        @105 TD 2.
        @113 FD 2.;
  format Yds comma5.;
  label Yds='rushing_yards'
        Avg='rushing_yards_per_attempt'
        Lg='longest_rushing_attempt'
        TD='rushing_touchdowns'
        FD='rushing_firstdowns';
run;
proc contents data=rushing_zouyang7;
run;
proc sort data=rushing_zouyang7 out=rtouchdowns_zouyang7;
  by descending TD;
  where Season >=2013;
run;
proc print data=rtouchdowns_zouyang7(obs=10) label;
  var player TD Season;
run;
data localnfl_zouyang7;
  infile 'C:\440\hw04\nflrush_quotes.dat' dlm=' ' dsd firstobs=2;
  input Season 4. Player $32. Team $10. Games 10. Att 9. Yds comma5.
        Avg 8. YPG 8. Lg 8. TD 8. FD 8.;
  drop Games Att YPG;
  if Team in ('Stl', 'Chi','Ind', 'GB');
  format Yds comma5.;
  label Yds='rushing_yards'
        Avg='rushing_yards_per_attempt'
        Lg='longest_rushing_attempt'
        TD='rushing_touchdowns'
        FD='rushing_firstdowns';
run;
proc contents data=localnfl_zouyang7;
run;
proc sort data=localnfl_zouyang7 out=ryard_zouyang7;
  by descending Yds;
run;
proc print data=ryard_zouyang7(obs=10) label;
  var player Team Yds Season;
run;

/* Exercise 2 */
title 'Exercise 2';
data low_earners4_zouyang7;
  length ID $ 6 Name $ 20 Country $ 2 Company $ 20 Department $ 25 Section $ 25 
         Organization_Group $ 25 Job_Title $25 Gender $ 1 
         Salary 8 Birth_Date 6 Hire_Date 6 Termination_Date 6 ;
  infile 'C:\440\hw04\employee_roster4.dat' dlmstr='**' dsd missover;
  input ID $ Name $ Country $ /
        Company $ Department $ Section $ Organization_Group $ Job_Title $ Gender $ /
        Salary: dollar10.2 Birth_Date Hire_Date Termination_Date ;
  if Salary < 25000;
  if Department='Sales';
  format Salary dollar10.2 Birth_Date Hire_Date Termination_Date mmddyy10.;
run;
proc contents data=low_earners4_zouyang7;
run;
proc print data=low_earners4_zouyang7;
  var Name Gender Department Job_Title Salary;
run;
title;