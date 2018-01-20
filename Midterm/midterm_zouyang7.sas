/* <Zixin Ouyang> */
/* Midterm Submission */

libname midterm 'C:\440\midterm' access=readonly;
data illinifb16;
  length Obs 3 Season 4 Conf $ 7 W 3 L 3 T 3 Pct 5 SRS 6 SOS 6 AP_pre 3 AP_high 3 
         AP_post 3 ConfTitle $ 1 Coach $ 40 Record $ 8 Bowl $ 20 BowlResult $ 1; 
  infile 'C:\440\midterm\illinifb16.dat' dlm=',' dsd missover;
  input Obs Season Conf $ W L T Pct SRS SOS Ap_pre Ap_high Ap_post ConfTitle $
        Coach $ Record $ Bowl $ BowlResult $;
  format Pct 5.3 SRS 6.2 SOS 6.2;
  label Obs='Observation' Conf='Conference' W='Wins' L='Losses' Ties='Ties' 
        Pct='Win Percentage' SRS='Simple Rating' SOS='Schedule Strength'
        AP_pre='Pre-season Rank' AP_high='Highest Rank' AP_post='Final Rank'
        ConfTitle='Conference Title' BowlResult='Bowl Result';
run;
proc contents data=illinifb16;
run;
proc freq data=illinifb16 nlevels;
   tables _all_/noprint;
run;
proc freq data=illinifb16;
   tables Coach;
   tables ConfTitle;
run;
proc means data=illinifb16;
 var SRS SOS AP_pre AP_high AP_post;
run;
proc print data=illinifb16 label;
  var Obs Season W L T Pct Coach Record;
  where Pct=. or  Coach=' ' or Record=' ' ;
run;
proc print data=illinifb16 label;
  var W L T Pct;
  where round(W/(W+L+T), .001)^=Pct;
run;
proc format;
  value Missrank .='Unranked';
  value $Missbowl ' '='Missing';
  value $ConfTitle 'Y'='Win' 'N'='Lose' other='Missing';
  value $BowlResult 'W'='Win' 'L'='Lose' other='Missing';
run;
data illinifb16_zouyang7;
  set illinifb16;
  if Obs=90 then L=0;
  if Coach='Ron Zook (6-6) Vic Koenning (1-0)' then do; Coach='Ron Zook'; Record='(6-6)'; end;
  if Coach='John Mackovic (6-5) Lou Tepper (0-1)' then do; Coach='John Mackovic'; Record='(6-5)'; end;
  if Pct=. then Pct=0.182;
  if Obs=113 then do; Coach='Arthur Hall'; Record='(9-2-1)'; end;
  if ConfTitle='y' then ConfTitle='Y';
  Record=cat(W,'-',L,'-',T);
  Pct=round(W/(W+L+T), .001);
  format AP_pre AP_high AP_post Missrank.
         ConfTitle $ConfTitle.
         Bowl $Missbowl.
         BowlResult $BowlResult.;
run;
proc freq data=illinifb16_zouyang7 nlevels;
   tables _all_/noprint;
run;
proc print data=illinifb16_zouyang7 label;
  var Obs Season W L T Pct Coach Record;
  where Pct=. or  Coach=' ' or Record=' ' ;
run;
proc print data=illinifb16_zouyang7 label;
  var W L T Pct;
  where round(W/(W+L+T), .001)=^Pct;
run;
proc tabulate data=illinifb16_zouyang7;
  class Coach;
  var W;
  tables Coach, W*(sum);
run;
proc sort data=illinifb16_zouyang7 out=highestrank;
  by AP_high;
  where AP_high^=.;
run;
proc print data=highestrank label;
  var Season AP_high;
run;
proc freq data=illinifb16_zouyang7;
  tables ConfTitle;
run;
data decadewins;
  set illinifb16_zouyang7;
  if 1892<=Season<=1899 then Decade='1890s';
  if 1900<=Season<=1909 then Decade='1900s';
  if 1910<=Season<=1919 then Decade='1910s';
  if 1920<=Season<=1929 then Decade='1920s';
  if 1930<=Season<=1939 then Decade='1930s';
  if 1940<=Season<=1949 then Decade='1940s';
  if 1950<=Season<=1959 then Decade='1950s';
  if 1960<=Season<=1969 then Decade='1960s';
  if 1970<=Season<=1979 then Decade='1970s';
  if 1980<=Season<=1989 then Decade='1980s';
  if 1990<=Season<=1999 then Decade='1990s';
  if 2000<=Season<=2009 then Decade='2000s';
  if 2010<=Season<=2016 then Decade='2010s';
  keep Decade W;
run;
proc tabulate data=decadewins;
  class Decade;
  var W;
  tables Decade, W*(sum);
run;
