/* <Zixin Ouyang> */
/* HW04 Submission */

libname hw05 "C:\440\hw05" access=readonly;

/* Exercise 1 */
title 'Exercise 1';
data shoes_tracker_zouyang7;
  set hw05.shoes_tracker;
  Supplier_Country=upcase(Supplier_Country);
  Product_Name=propcase(Product_Name);
  if Product_ID=220200300002 then Supplier_ID='2963';
  if Product_ID=22020030007 then Product_ID=220200300079;
  if Product_ID=2202003001290 then Product_ID=220200300129;
  if Product_Category=' ' then Product_Category='Shoes';
  if Supplier_Country='UT' then Supplier_Country='US';
  if Supplier_Name='3op Sports' then Supplier_Name='3Top Sports';
  if Supplier_ID='14682' then Supplier_Name='Greenline Sports Ltd.';
run;
title2 'b';
proc freq data=shoes_tracker_zouyang7 nlevels;
   tables _all_/noprint;
   tables Product_ID Supplier_Country ;
   tables Supplier_Name*Supplier_ID /norow nocol nopercent;
run;

/* Exercise 2 */
title 'Exercise 2';
data rushing_zouyang7;
  length Season 4 Player $ 32 Team $ 10 Games 8 Att 8 Yds 8
        Avg 8 YPG 8 Lg 8 TD 8 FD 8;
  infile 'C:\440\hw05\badrush.txt' dlm='09'x dsd missover;
  input Season Player $ Team $ Games Att:comma5. Yds:comma5. Avg YPG Lg TD FD ;
  format Att comma5.
         Yds comma5.
         Avg 5.2
         YPG 5.1;
  label Att='attempts'
        Yds='total yards'
        Avg='yards/attempt'
        YPG='yards/game'
        Lg='longest rush'
        TD='touchdowns'
        FD='firstdowns';
run;
title2 'b';
proc contents data=rushing_zouyang7;
run;
title2 'd';
proc freq data=rushing_zouyang7 nlevels;
  tables _all_/noprint;
run;
proc freq data=rushing_zouyang7;
  tables Season;
run;
proc means data=rushing_zouyang7 n nmiss min max;
  var Games Att Yds Lg TD FD;
run;
proc univariate data=rushing_zouyang7;
 var Games Att Yds Lg;
 ods select ExtremeObs;
run;
proc print data=rushing_zouyang7 (firstobs=504 obs=504);
run;
proc print data=rushing_zouyang7;
  var Season Player Yds Att Avg;
  where round(Yds/Att, 0.01)^=Avg;
run;
proc print data=rushing_zouyang7;
  var Season Player Yds Games YPG;
  where round(Yds/Games,0.1)^=YPG;
run;
proc print data=rushing_zouyang7;
  where Yds=. or Avg=. or YPG=. or TD=. or FD=.;
run;
proc print data=rushing_zouyang7;
  where Lg <0 and Yds >0;
run;
data rush_zouyang7;
  set rushing_zouyang7;
  if Player=' ' then Player='LeSean McCoy';
  if Season=2012 and Player='Daryl Richardson' then TD=0;
  if Season=2011 and Player='Mike Kafka' then Yds=0;
  if Season=2010 and Player='Moran Norris' then Avg=0;
  if Season=2014 and Player='Matt Forte' then do; Team='Chi'; Games=16; Att=266; Yds=1038; Avg=3.9;YPG=64.9;Lg=32;TD=6;FD=63;end;
  if Season=2013 and Player='Matt Forte' then do; Team='Chi'; Games=16; Att=289; Yds=1339; Avg=4.63; YPG=83.7; Lg=55; TD=9; FD=74; end;
  if Season=2012 and Player='Matt Forte' then do; Team='Chi'; Games=15; Att=248; Yds=1094; Avg=4.41; YPG=72.9; Lg=46; TD=5; FD=45; end;
  if Season=2011 and Player='Matt Forte' then do; Team='Chi'; Games=12; Att=203; Yds=997; Avg=4.91; YPG=83.1; Lg=46; TD=3; FD=40; end;
  if Season=2010 and Player='Matt Forte' then do; Team='Chi'; Games=16; Att=237; Yds=1069; Avg=4.51; YPG=66.8; Lg=68; TD=6; FD=42; end;
  if Season=2013 and Player='Knowshon Moreno' then Avg=4.31;
  if Season=2012 and Player='Darren McFadden' then do; Avg=3.27;YPG=58.9; end;
  if Season=2012 and Player='Legarrette Blount' then Avg=3.68;
  if Season=2010 and Player='Ben Roethlisberger' then Avg=5.18;
  if Season=2010 and Player='Donovan McNabb' then YPG=11.6;
  if Season=2012 and Player='Raymond Ventrone' then Lg=35;
  if Season=1912 then Season=2012;
  if Season=20111 then Season=2011;
  if Season=20010 then Season=2010;
  if Games=0.16 then Games=16;
  if Lg=910 then Lg=91;
  if Lg=2800 then Lg=28;
  if Att=0 then Att=1;
  Avg=round(Yds/Att, 0.01);
  YPG=round(Yds/Games,0.1);
run;
title2 'f';
proc freq data=rush_zouyang7 nlevels;
  tables _all_/noprint;
  tables Season;
run;
proc means data=rush_zouyang7 n nmiss min max;
  var Games Att Yds Lg TD FD;
run;
proc print data=rush_zouyang7;
  var Season Player Yds Att Avg;
  where round(Yds/Att, 0.01)^=Avg;
run;
proc print data=rush_zouyang7;
  var Season Player Yds Games YPG;
  where round(Yds/Games,0.1)^=YPG;
run;
proc print data=rush_zouyang7;
  where Yds=. or Avg=. or YPG=. or TD=. or FD=.;
run;
proc print data=rush_zouyang7;
  where Lg <0 and Yds >0;
run;
title;
  
  
  
  
  
