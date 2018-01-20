libname hw11 "~/my_courses/dunger_sas/hw11" access=readonly;

/*Exercise 1*/
title 'Exercise 1';
*a;
proc sql;
   describe table hw11.employee_roster;
quit;
*b;
proc sql;
   create table top_earners_zouyang7 as
      select * 
      from hw11.employee_roster
      where Salary>70000;
quit;
proc sql;
  alter table top_earners_zouyang7
  modify Job_Title label='Position',
         Salary label='Yearly Salary';
quit;
*c;
title2 'c';
proc sql;
  select Employee_Name, Job_Title, Salary
  from top_earners_zouyang7;
quit;
*d;
title2 'd';
proc sql;
  select Employee_ID, Employee_Gender, Section, Salary
  from hw11.employee_roster
  where Employee_Gender='M' and
        25000<=Salary<=30000 and
        Section='Administration';
quit;
*e;
title2 'e';
proc sql;
  select Employee_Name, Employee_ID, Org_Group
  from hw11.employee_roster
  where Employee_Name like 'C%' or 
        Employee_Name like 'D%' or 
        Employee_Name like 'E%';
quit;
*f;
title2 'f';
proc sql;
   select Employee_Gender,
          avg(Salary) as Average_Salary,
          median(Salary) as Median_Salary
      from hw11.employee_roster
      group by Employee_Gender;
quit;

/*Exercise 1*/
title 'Exercise 2';
*a;
proc sql;
   create table purchase_price_zouyang7 as
   select CustNumber, purchase.Model, Quantity, Price,
          Quantity*Price as Total_Cost format dollar7.2
   from hw11.purchase as p
        inner join 
        hw11.inventory as i
        on p.Model=i.Model;
quit;
*b;
title2 'b';
proc sql;
   select *
   from purchase_price_zouyang7;
quit;
*c;
proc sql;
  create table not_purchased_zouyang7 as
  select inventory.Model,Price
  from hw11.inventory 
  where Model not in (select Model from hw11.purchase);
quit;
*d;
title2 'd';
proc sql;
   select *
   from not_purchased_zouyang7;
quit;
title;



        