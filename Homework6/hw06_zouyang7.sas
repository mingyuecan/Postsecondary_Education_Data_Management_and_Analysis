/* <Zixin Ouyang> */
/* HW06 Submission */

libname hw06 "C:\440\hw06" access=readonly;
/* Exercise 1 */
title 'Exercise 1';
/*1a*/
proc sort data=hw06.inventory
          out=sorted_inventory;
  by Model;
run;
proc sort data=hw06.purchase
          out=sorted_purchase;
  by Model;
run;
data purchase_price_zouyang7;
  merge sorted_inventory(in=inv) 
        sorted_purchase(in=pur);
  by Model;
  if inv=1 and pur=1;
  TotalCost=Price*Quantity;
run;
/*1b*/
title2 'b';
proc print data=purchase_price_zouyang7 noobs;
run;
/*1c*/
data not_purchased_zouyang7;
  merge sorted_inventory(in=inv) 
        sorted_purchase(in=pur);
  by Model;
  if inv=1 and pur=0;
  drop CustNumber Quantity;
run;
/*1d*/
title2 'd';
proc print data=not_purchased_zouyang7 noobs;
run;
/*1e*/
data purchase_price_zouyang7 not_purchased_zouyang7(keep=Model Price);
  merge sorted_inventory(in=inv) 
        sorted_purchase(in=pur);
  by Model;
  TotalCost=Price*Quantity;
  if inv=1 and pur=1 then do;
       output purchase_price_zouyang7;
       end;
  else if inv=1 and pur=0 then do;
       output not_purchased_zouyang7;
       end;
run;
/* Exercise 2 */
title 'Exercise 2';
/* 2a */
title2 'a';
proc contents data=hw06.fmli071;
run;
proc contents data=hw06.fmli072;
run;
proc contents data=hw06.fmli073;
run;
proc contents data=hw06.fmli074;
run;
proc contents data=hw06.memi071;
run;
proc contents data=hw06.memi072;
run;
proc contents data=hw06.memi073;
run;
proc contents data=hw06.memi074;
run;
/* 2b */
data fmli2007_zouyang7;
  set hw06.fmli071(in=Q1) hw06.fmli072(in=Q2) 
      hw06.fmli073(in=Q3) hw06.fmli074(in=Q4);
  if Q1=1 then QTR=1;
  else if Q2=1 then QTR=2;
  else if Q3=1 then QTR=3;
  else if Q4=1 then QTR=4;
run;
/* 2c */
title2 'c';
proc contents data=fmli2007_zouyang7;
run;
/* 2d */
data memi2007_zouyang7;
  set hw06.memi071(in=Q1) hw06.memi072(in=Q2) 
      hw06.memi073(in=Q3) hw06.memi074(in=Q4);
  if Q1=1 then QTR=1;
  else if Q2=1 then QTR=2;
  else if Q3=1 then QTR=3;
  else if Q4=1 then QTR=4;
run;
/* 2e */
title2 'e';
proc contents data=memi2007_zouyang7;
run;
/* 2f */
proc sort data=fmli2007_zouyang7;
  by CU_ID QTR;
run;
proc sort data=memi2007_zouyang7;
  by CU_ID QTR;
run;
data ce2007_zouyang7;
  merge fmli2007_zouyang7 memi2007_zouyang7;
  by CU_ID QTR;
run;
/* 2g */
title2 'g';
proc contents data=ce2007_zouyang7;
run;
/* 2h */
title2 'h';
proc freq data=fmli2007_zouyang7;
  tables CU_ID/ out=atleast_three_zouyang7(where=(count>=3) drop=percent) noprint;
run;
proc freq data=fmli2007_zouyang7;
  tables CU_ID/ out=all_four_zouyang7(where=(count=4) drop=percent) noprint;
run;
/* 2i */
title2 'i';
proc contents data=work.atleast_three_zouyang7;
run;
proc contents data=work.all_four_zouyang7;
run;



