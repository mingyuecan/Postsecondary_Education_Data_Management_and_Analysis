libname hw09 "C:\440\hw09" access=readonly;

/*Exercise 1*/
title 'Exercise 1';
title2 'a';
*a;
data re_survey1;
  set hw09.survey1;
  rename Subj=ID;
run;
proc sort data=hw09.demographic
          out=sorted_demographic;
  by ID;
run;
proc sort data=re_survey1
          out=sorted_survey1;
  by ID;
run;
data demo1_zouyang7;
  merge sorted_demographic
        sorted_survey1;
  by ID;
run;
proc print data=demo1_zouyang7;
run;
*b;
title2 'b';
data conver_survey2;
  set hw09.survey2;
  CID=put(ID, Z3.);
  drop ID;
run;
data re_survey2;
  set conver_survey2;
  rename CID=ID;
run;
proc sort data=re_survey2
          out=sorted_survey2;
  by ID;
run;
data demo2_zouyang7;
  merge sorted_demographic
        sorted_survey2;
  by ID;
run;
proc print data=demo2_zouyang7;
run;
/*Exercise 2*/
title'Exercise 2';
data updated;
  set hw09.fivepeople;
  NID=input(ID, 5.);
  Lname=scan(Name,2);
  Fname=scan(Name,1);
  FullName=catx(",",Lname,Fname);
  Bphone=compress(Phone,' ');
  Nphone=compress(Bphone,'-');
  NumPhone=compress(Nphone,'(');
  Num_Phone=compress(NumPhone,')');
  PhoneNum=input(Num_Phone,10.);
  ftNum=substr(Height,1,1);
  inch=substr(Height,6);
  inches=compress(inch,"",'A');
  inchNum=compress(inches,'.');
  HtSymbol=ftNum!!'"'!!' '!!inchNum!!"'";
  HtInches=sum(12*ftNum,inchNum);
  WtIn=input(substr(Weight,1,3),3.);
  WtF1=substr(Weight,5,1);
  WtF2=substr(Weight,7,1);
  WtD=round(WtF1/WtF2,0.001);
  WtPounds=sum(WtIn,WtD);
  keep NID FullName PhoneNum HtSymbol HtInches WtPounds Weight;
run;
data updated_zouyang7;
  set updated;
  rename NID=ID
         FullName=Name
         PhoneNum=Phone;
run;
title2 'b';
proc print data=updated_zouyang7;
  var ID Name Phone HtSymbol HtInches Weight WtPounds;
run;
title2 'c';
proc contents data=updated_zouyang7;
run;
title;

