
Create table Employee(
    E_ID varchar(8) PRIMARY KEY,
    E_NM varchar(50),
    Email_ID varchar(100));


Create table Job_Title(
    Job_ID Serial PRIMARY KEY,
    Job_Title varchar(100));


Create table Education(
    Edu_ID Serial PRIMARY KEY,
    Edu_Level varchar(50));
    
Create table Date(
    DT_ID Serial PRIMARY KEY,
    DT date);
    
Create table Department(
    Dept_ID Serial PRIMARY KEY,
    Department varchar(50));
    
Create table Salary(
    Sal_ID Serial PRIMARY KEY,
    Sal INT);
    
Create table Location(
    Loc_ID Serial PRIMARY KEY,
    Location varchar(50)); 
    
Create table City(
    City_ID Serial PRIMARY KEY,
    City varchar(50)); 
    
Create table State(
    State_ID Serial PRIMARY KEY,
    State varchar(2)); 
    
Create table Full_Address(
    Addr_ID Serial PRIMARY KEY,
    Addr varchar(100),
    Loc_ID int references Location(Loc_ID),
    City_ID int references City(City_ID),
    State_ID INT references State(State_ID)); 
    
Create Table HR_Data(
    ID Serial Primary Key,
    E_ID varchar(8) references Employee(E_ID),
    Hire_DT_ID INT references Date(DT_ID),
    Job_ID INT references Job_Title(Job_ID),
    Sal_ID INT references Salary(Sal_ID),
    Dept_ID int references Department(Dept_ID),
    Mang_ID varchar(8) references Employee(E_ID),
    ST_DT_ID int references Date(DT_ID),
    End_DT_ID INT references Date(DT_ID),
    Addr_ID int references Full_Address(Addr_ID),
    Edu_ID int references Education(Edu_ID));
    
Insert into Employee
    Select Distinct(EMP_ID), EMP_NM,Email FROM PROJ_STG;
select * from Employee;    

Insert into Job_Title(Job_Title)
    select distinct(Job_Title) from PROJ_STG;
Select * from Job_Title;

Insert into Education(Edu_Level)
    select distinct(education_lvl) from PROJ_STG;   
Select * from Education;

Insert into Date(DT)
    Select Distinct(Hire_DT) from  (select Hire_dt from Proj_stg Union select Start_dt from Proj_stg Union select End_dt from Proj_stg where End_dt is not null) AS TEMP ;
Select * from Date;


Insert into Department(Department)
    Select Distinct(department_nm) from Proj_stg;
Select * from Department;

Insert into Salary(Sal)
    Select Distinct(Salary) from Proj_stg;
Select * from Salary;


Insert into Location(Location)
    Select Distinct(Location) from Proj_stg;
Select * from Location;

Insert into City(City)
    Select Distinct(City) from Proj_stg;
Select * from City;

Insert into State(State)
    Select Distinct(State) from Proj_stg;
Select * from State;
    
Insert into Full_Address(Addr, Loc_ID, City_id,State_ID)
SELECT distinct(loc.address),loc.Loc_ID,loc.City_ID,s.State_id FROM (((Proj_stg as stg join city as c on stg.city=c.City) as cit join location as l on cit.location=l.location) as loc join State as s on loc.state=s.State);
Select * from Full_Address;

Insert into HR_Data(E_id,Hire_DT_ID,Job_ID,Sal_ID,Dept_ID,Mang_ID,ST_DT_ID,End_DT_ID,Addr_ID,Edu_ID)
Select EMP_ID,Hire_DT_ID,Job_ID,Sal_ID, Dept_ID, E_ID,ST_DT_ID,END_DT_ID,Addr_ID,Edu_ID from (((((((((proj_stg as stg  join (select DT_ID AS HIRE_DT_ID, DT  from Date) as d on stg.Hire_DT=d.DT) AS dt join Job_Title as j on dt.job_title=j.Job_Title) as Job join Salary as s on Job.Salary=s.Sal) as  Sal JOIN Department as de on sal.department_NM=de.Department) AS Dept join education as edu on Dept.education_lvl=edu.edu_level) as education join (select DT_ID AS ST_DT_ID,DT FROM Date) as d1 ON education.START_DT=d1.DT ) as ST_DT left JOIN (SELECT DT_ID AS END_DT_ID, DT FROM DATE) AS d2 ON ST_DT.END_DT=d2.DT)AS END_DT JOIN Full_Address as ad on end_dt.address=ad.addr) as addr left join Employee as mang on addr.manager=mang.e_nm);
Select * from HR_Data;


--question 1
select distinct(Dept.E_NM),Job.Job_Title,Dept.Department from (((HR_Data as hr join Employee as e on hr.e_id=e.e_id) as Emp join Department as d on Emp.Dept_ID=d.Dept_ID) AS Dept Join Job_Title as Job on Dept.Job_ID=Job.Job_ID);
--question2
 Insert into Job_Title(Job_Title)
  values('Web Programmer');
  select * from Job_Title;
  
  --question3
  Update Job_Title
  set Job_title='Web Developer'
  where Job_Title='Web Programmer';
  select * from Job_Title;
  
--question 4
  delete from Job_Title
  where Job_title='Web Developer';
  select * from Job_Title;
  
--question5
  Select Department,count(distinct(E_NM)) from ((HR_Data as hr join Employee as e on hr.e_id=e.e_id) as Emp join Department as d on Emp.Dept_ID=d.Dept_ID) group by department;
  
  
--question6
 select distinct(ST_DT.E_NM),ST_DT.Job_Title,ST_DT.Department, ST_DT.mang_nm,ST_DT.Start_DT,E_DT.End_DT from ((((((HR_Data as hr join Employee as e on hr.e_id=e.e_id) as Emp join Department as d on Emp.Dept_ID=d.Dept_ID) AS Dept Join Job_Title as J on Dept.Job_ID=J.Job_ID) as Job LEFT join (select e_id,e_nm as mang_nm from Employee) as em on Job.Mang_id=em.e_id) as Mang join (SELECT DT_ID,DT AS START_DT FROM Date) as DT ON Mang.ST_DT_ID=DT_ID) AS ST_DT JOIN (SELECT DT_ID,DT AS END_DT FROM Date) as E_DT ON ST_DT.End_DT_ID=E_DT.DT_ID) where ST_DT.E_NM='Toni Lembeck';
 
 
--challenge1
Create View Employee_info as select stt.Emp_ID as Emp_ID,stt.E_NM AS Emp_NM, stt.EMAIL_ID AS Email,stt.HIRE_DT as hire_dt,stt.Job_Title as job_title ,stt.Sal as salary,stt.Department as department_nm, stt.mang_nm as manager,stt.Start_DT as start_dt ,stt.End_DT as end_dt,stt.location as location,stt.addr as address,stt.city as city,stt.state as state  ,ed.edu_level  as education_lvl from (((((((((((((HR_Data as hr join (select E_ID AS EMP_ID,E_NM,EMAIL_ID FROM Employee) as e on hr.e_id=e.emp_id) as Emp join (SELECT DT_ID,DT AS HIRE_DT FROM Date)AS HDT ON EMP.HIRE_DT_ID= HDT.DT_ID) AS HDT1 JOIN Department as d on HDT1.Dept_ID=d.Dept_ID) AS Dept Join Job_Title as J on Dept.Job_ID=J.Job_ID) as Job join Salary as sa on Job.Sal_id=sa.sal_id) as sal LEFT join (select e_id,e_nm as mang_nm from Employee) as em on sal.Mang_id=em.e_id) as Mang join (SELECT DT_ID,DT AS START_DT FROM Date) as DT ON Mang.ST_DT_ID=DT.DT_ID) AS ST_DT JOIN (SELECT DT_ID,DT AS END_DT FROM Date) as E_DT ON ST_DT.End_DT_ID=E_DT.DT_ID) as End_DT JOIN FULL_Address as fa on End_DT.ADDR_ID=FA.ADDR_ID) AS faddr join location as l on faddr.loc_id=l.loc_id)as loc join city as c on loc.city_id=c.city_id) as city join state on city.state_id=state.state_id)as stt join education as ed on stt.edu_id=ed.edu_id);
select * from employee_info;

--challenge 2
CREATE or Replace function crud_Employee_detail(Emp_nm varchar(50)) 
RETURNS TABLE(e_nm varchar(8),Job_Title varchar(50),Department varchar(50),Manager varchar(50),Start_Date date,End_date date)
LANGUAGE sql
as $$
select DISTINCT(ST_DT.E_NM),ST_DT.Job_Title,ST_DT.Department, ST_DT.mang_nm,ST_DT.Start_DT,E_DT.End_DT from ((((((HR_Data as hr join Employee as e on hr.e_id=e.e_id) as Emp join Department as d on Emp.Dept_ID=d.Dept_ID) AS Dept Join Job_Title as J on Dept.Job_ID=J.Job_ID) as Job LEFT join (select e_id,e_nm as mang_nm from Employee) as em on Job.Mang_id=em.e_id) as Mang join (SELECT DT_ID,DT AS START_DT FROM Date) as DT ON Mang.ST_DT_ID=DT_ID) AS ST_DT JOIN (SELECT DT_ID,DT AS END_DT FROM Date) as E_DT ON ST_DT.End_DT_ID=E_DT.DT_ID) where ST_DT.E_NM=Emp_nm;
$$;
select * from crud_Employee_detail('Toni Lembeck');  
  
--challenge 3
create user admin;-- password is confidential
create user NoMgr;
--password is all_user
Revoke select on Salary from NoMgr;
revoke select on employee_info from NoMgr;
Grant select on Employee to NoMgr;
\password NoMgr
\q
psql -U NoMgr -d postgres -h 127.0.0.1 -W
--as user 'NoMgr';
select * from Employee_Info;

select * from Salary; --as user 'NoMgr';
select * from Employee;
