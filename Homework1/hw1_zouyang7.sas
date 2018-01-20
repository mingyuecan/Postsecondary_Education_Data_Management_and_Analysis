/* <Zixin Ouyang> */
/* HW01 Submission */

libname hw01 "~/my_courses/dunger_sas/hw01" access=readonly;

/* Exercise 1 */
title 'Exercise 1';
proc contents data=sashelp.pricedata;
run;
libname hw01 "~/my_courses/dunger_sas/hw01";
data pricing_zouyang7;
   set sashelp.pricedata;
   where sale > 300 and price - cost < 40;
   keep date sale price discount cost productName;
   label sale="Units Sold";
   format date mmddyy10. price cost dollar5.2 discount percent5.0; 
run;
proc contents data=pricing_zouyang7;
run;
proc print data=pricing_zouyang7;
run;

/* Exercise 2 */
title 'Exercise 2';
proc contents data=sasuser.employee_roster;
run;
data top_earners_zouyang7;
   set sasuser.employee_roster;
   where Salary > 70000;
   label Job_Title="Position" Salary="Yearly Salary";
run;
proc print data=top_earners_zouyang7 label;
var Employee_Name Job_Title Salary;
run;
proc print data=sasuser.employee_roster;
   where Employee_Gender="M" and Department="Administration" and 25000<=Salary<=30000;
   var Employee_Name Employee_Gender Department Salary;
run;
proc print data=sasuser.employee_roster;
   where Employee_Name like "C%" or Employee_Name like "D%" or Employee_Name like "E%";
   var Employee_Name Employee_ID Org_Group;
run;
   




