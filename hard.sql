create database creditbank
use creditbank
select * from dbo.bank

---check for nulls
select *from bank 
where Marital_Status is null
--no null 

--deleting fields that are not useful
alter table bank
drop column Naive_Bayes_Classifier_Attrition_Flag_Card_Category_Contacts_Cou,Naive_Bayes_Classifier_Attrition_Flag_Card_Category_Contacts_Co1

--distinct value in each column 
select distinct attrition_flag,Gender,Education_level,Marital_Status,Income_category,Card_Category
from bank

---Attrition Percentage
 with attrition as (select attrition_flag, count(*) as totals from bank
group by Attrition_Flag)
select Attrition_Flag,cast((cast(totals as decimal(10,2))*100.00/cast((select count(*) from bank) as decimal(10,2)))as decimal(10,2)) percentage
from attrition
group by attrition_flag,totals

---Gender Percentage
with gend as (select Gender, count(*) as totals from bank
group by Gender)
select Gender,cast((cast(totals as decimal(10,2))*100.00)/cast((select count(*) from bank)as decimal(10,2)) as decimal(10,2)) percentage
from gend
group by Gender,totals

--Count of Education Level
select education_level, count(*)as totals from bank 
group by Education_Level
order by 2

--Count of Marital status
select marital_status,count(*) as totals 
from bank
group by Marital_Status
order by 2

--Card Category Percentage
with card as (select Card_Category, count(*) as totals from bank
group by Card_Category)
select Card_Category,cast((cast(totals as decimal(10,2))*100.00/cast((select count(*) from bank) as decimal(10,2))) as decimal(10,2)) percentage
from card
group by Card_Category,totals
order by 2

---Months on book based on card category
select card_category,sum(months_on_book) from bank 
group by Card_Category
order by 2

---inactivity based on income range
select Income_Category,sum(Months_inactive_12_mon) from bank 
group by Income_Category
order by 2 desc
---how's bank card issued?
---Grouping Credit limits
create view credit as 
select credit_limit,NTILE(5) over(order by credit_limit) as range 
 from bank

alter view cl as 
 select range, case 
 when range=5 then  '$' + cast((select max(credit_limit) from credit where range=5) as varchar(10))+ ' ' + '-' +' ' + '$' + cast((select min(credit_limit) from credit where range=5) as varchar(10))
when range=4 then '$' + cast((select max(credit_limit) from credit where range=4) as varchar(10))+ ' ' + '-'+ ' '+'$' + cast((select min(credit_limit) from credit where range=4) as varchar(10))
 when range=3 then '$' + cast((select max(credit_limit) from credit where range=3) as varchar(10)) +' ' + '-'+ ' '+'$'+  cast((select min(credit_limit) from credit where range=3) as varchar(10))
 when range=2 then '$' + cast((select max(credit_limit) from credit where range=2) as varchar(10)) +' ' + '-'+ ' '+'$' + cast((select min(credit_limit) from credit where range=2) as varchar(10))
 else '$' + cast((select max(credit_limit) from credit where range=1) as varchar(10)) +' ' + '-'+ ' '+'$'  + cast((select min(credit_limit) from credit where range=1) as varchar(10)) 
 end as Credit_Limit
from credit
 
select Credit_Limit,count(range) as Totals from cl group by  Credit_Limit




