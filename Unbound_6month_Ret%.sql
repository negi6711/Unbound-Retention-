with by_month
AS(
SELECT Customer_Name,
Month(Order_Date) as "Transaction_Month", 
Year(Order_Date) as "Transaction_Year" FROM retail
group by 1,2,3),
with_first_month 
AS(
Select Customer_Name, 
Transaction_Month,
Transaction_Year ,
first_value(Transaction_Month) over (Partition by Customer_Name order by Transaction_Month) as "first_month",
first_value(Transaction_Year) over (Partition by Customer_Name order by Transaction_Year) as "first_year"
from by_month),
with_month_no 
AS(
Select Customer_Name, 
Transaction_Month,
Transaction_Year, 
first_month,
first_year, 
Transaction_Month-first_month as "month_no",
Transaction_Year-first_year as "year_no"
from with_first_month),
with_m_no 
AS(
Select *, 
(month_no + year_no*12) as "m_no" from with_month_no),
ret 
AS(
Select 
first_month as "First_user_month",
first_year as "First_user_Year", 
SUM(CASE WHEN m_no>=0 and m_no<=6 then 1 ELSE 0 END) AS users_visited_in_6_months,
SUM(CASE WHEN m_no>=7 and m_no<=12 THEN 1 ELSE 0 END) AS users_visited_in_12_months,
SUM(CASE WHEN m_no>=13 and m_no<=18 THEN 1 ELSE 0 END) AS users_visited_in_18_months,
SUM(CASE WHEN m_no>=19 and m_no<=24 THEN 1 ELSE 0 END) AS users_visited_in_24_months,
SUM(CASE WHEN m_no>=25 and m_no<=30 THEN 1 ELSE 0 END) AS users_visited_in_30_months,
SUM(CASE WHEN m_no>=30 and m_no<=36 THEN 1 ELSE 0 END) AS users_visited_in_36_months,
SUM(CASE WHEN m_no>=37 and m_no<=42 THEN 1 ELSE 0 END) AS users_visited_in_42_months,
SUM(CASE WHEN m_no>=43 and m_no<=48 THEN 1 ELSE 0 END) AS users_visited_in_48_months
from with_m_no
group by 1,2
order by 2,1)
select First_user_month, First_user_Year, 
round(users_visited_in_6_months/users_visited_in_6_months*100,2) as "6month_retention%",
round(users_visited_in_12_months/users_visited_in_6_months*100,2) as "12month_retention%",
round(users_visited_in_18_months/users_visited_in_6_months*100,2) as "18month_retention%",
round(users_visited_in_24_months/users_visited_in_6_months*100,2) as "24month_retention%",
round(users_visited_in_30_months/users_visited_in_6_months*100,2) as "30month_retention%",
round(users_visited_in_36_months/users_visited_in_6_months*100,2) as "36month_retention%",
round(users_visited_in_42_months/users_visited_in_6_months*100,2) as "42month_retention%",
round(users_visited_in_48_months/users_visited_in_6_months*100,2) as "48month_retention%"
from ret;