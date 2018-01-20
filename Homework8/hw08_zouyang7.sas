/* Homework 8/
/*Zixin Ouyang*/

libname hw08 "C:\440\hw08" access=readonly;

/*Exercise 1*/
/*a*/
proc sort data=hw08.orders
          out=ordersort;
  by Customer_ID Order_Type;
run;
data discount_ret (keep=Customer_ID Customer_Name TotSales)
     discount_cat (keep=Customer_ID Customer_Name TotSales Customer_Gender)
     discount_int (keep=Customer_ID Customer_Name TotSales Customer_BirthDate);
  set ordersort;
  by Customer_ID Order_Type;
  if First.Order_Type then TotSales=0;
  TotSales+Total_Retail_Price;
  if Last.Order_Type;
  if Order_Type=1 and TotSales>=400 then output discount_ret;
  else if Order_Type=2 and TotSales>=70 then output discount_cat;
  else if Order_Type=3 and TotSales>=400 then output discount_int;
run;
/*b*/
title 'Customers who spent $400 or more on retail purchases';
proc print data=discount_ret;
  format TotSales dollar10.2;
run;
title 'Customers who spent $70 or more on catalog purchases';
proc print data=discount_cat;
  format TotSales dollar10.2;
run;
title 'Customers who spent $400 or more on internet purchases';
proc print data=discount_int;
  format TotSales dollar10.2
         Customer_BirthDate mmddyy10. ;
run;
/*c*/
proc sort data=hw08.orders
          out=ordersort;
  by Customer_ID Order_Type;
run;
data discount_ret (keep=Customer_ID Customer_Name TotSales)
     discount_cat (keep=Customer_ID Customer_Name TotSales Customer_Gender)
     discount_int (keep=Customer_ID Customer_Name TotSales Customer_BirthDate);
  set ordersort;
  by Customer_ID Order_Type;
  if First.Order_Type then TotSales=0;
  TotSales+Total_Retail_Price;
  if Last.Order_Type;
  if Order_Type=1 and TotSales>=400 then output discount_ret;
  else if Order_Type=2 and TotSales>=70 then output discount_cat;
  else if Order_Type=3 and TotSales>=400 then output discount_int;
run;
proc sort data=hw08.orders
          out=ordersort2;
  by Customer_ID;
run;
data top_buyers_zouyang7(keep=Customer_ID Customer_Name SumSales);
  set ordersort2;
  by Customer_ID;
  if First.Customer_ID then SumSales=0;
  SumSales+Total_Retail_Price;
  if Last.Customer_ID;
  if SumSales >500 then output=top_buyers_zouyang7;
  else if other;
run;
/*d*/
title 'Customers with purchases totaling greater than $500 across all platforms';
proc print data=top_buyers_zouyang7;
  format SumSales dollar10.2;
run;
title 'Customers who spent $400 or more on internet purchases';
proc print data=discount_int;
  format TotSales dollar10.2
         Customer_BirthDate mmddyy10. ;
run;

/*Exercise 2*/
/*a*/
data trade_zouyang7;
  length Date 8 Export 8 Import 8;
  infile 'C:\440\hw08\importexport87-15.dat' dlm='09'x ;
  input Date:ddmmyy10. Export Import @@;
  Balance=Export-Import;
  format Date ddmmyy10.
         Export Import Balance comma10.1;
run;
/*b*/
title 'Exercise 2 b';
proc print data=trade_zouyang7(obs=24) noobs;
run;
/*c*/
data trade_year;
  set trade_zouyang7;
  Year=Year(Date);
run;
proc sort data=trade_year;
  by Year;
run; 
data yearlyimports_zouyang7;
  set trade_year;
  by Year;
  if First.Year then YearTotal=0;
  YearTotal+Import;
  if Last.Year;
  YearAvg=YearTotal/12;
  format YearTotal YearAvg comma10.1;
  keep Year YearTotal YearAvg;
run;
/*d*/
title 'Exercise 2 d';
proc contents data=yearlyimports_zouyang7;
run;
/*e*/
title 'Exercise 2 e';
proc print data=yearlyimports_zouyang7;
run;
/*f*/
proc format;
  value decade 1980-1989 ="80's"
               1990-1999="90's"
               2000-2009="00's"
               2010-2019="10's";
run;
title 'Exercise 2 f';
proc means data=yearlyimports_zouyang7 mean;
  class Year;
  var YearTotal;
  format Year decade.;
run;
title;























