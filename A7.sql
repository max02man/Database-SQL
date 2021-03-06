--1
select*
from LGDEPARTMENT
--2
Select Prod_sku,Prod_descript, Prod_type, Prod_base, Prod_category, Prod_price
from lgproduct
where Prod_base = 'water' and Prod_category = 'sealer'
--3
select emp_fname, emp_lname, emp_email
from lgemployee
where emp_hiredate >= '2001-1-1' and emp_hiredate <='2010-12-31'
order by emp_lname,emp_fname
--4
select emp_fname, emp_lname, emp_phone,emp_title, dept_num
from lgemployee
where dept_num =300 or emp_title= 'clerk i'
order by emp_lname, emp_fname
--5
select b.emp_num, b.emp_lname,b.emp_fname, a.sal_from, a.sal_end, a.sal_amount
from LGSALARY_HISTORY a inner join lgemployee b
 on a.emp_num = b.emp_num
where b.emp_num =83731 or
	  b.emp_num =83745 or
	  b.emp_num =84093
order by b.emp_num , a.sal_from
--6
Select a.cust_fname, a.cust_lname, a.cust_street, a.cust_city,
 a.cust_state, a.cust_zip
from lgcustomer a inner join lginvoice b 
on a.cust_code = b.cust_code, lgbrand
where b.inv_date between '2013-7-15' and '2013-7-31'and brand_name ='foresters best'
group by a.cust_fname, a.cust_lname, a.cust_street, a.cust_city,
 a.cust_state, a.cust_zip
order by a.cust_state,a.cust_lname, a.cust_fname
--7
select a.EMP_NUM, a.emp_lname, a.emp_email, a.emp_title, b.dept_name
from lgemployee a inner join LGDEPARTMENT b on a.dept_num = b.dept_num
where a.emp_title like '%associate'
order by dept_name, emp_title
--8
select brand_name, count (b.prod_sku) as [NUMPRODUCTS]
from lgbrand a inner join lgproduct b on a.brand_id = b.brand_id
group by brand_name
order by brand_name
--9
select prod_category, count(prod_category) as [NUMPRODUCTS]
from lgproduct
where Prod_base = 'water'
group by prod_category
--10*
select  prod_base, prod_type, count(prod_base) as [NUMPRODUCTS]
from lgproduct
group by prod_base,prod_type
--11
select brand_id, count(brand_id) as TOTALINVENTORY
from lgproduct
group by brand_id
order by brand_id desc
--12
select a.brand_id, brand_name,
 cast(avg(a.prod_price)as decimal(10,2)) as AVGPRICE
from lgproduct a inner join lgbrand b on a.brand_id = b.brand_id
group by a.brand_id,brand_name
order by brand_name
--13
select a.dept_num, max(b.emp_hiredate)as MOSTRECENT
from lgdepartment a inner join lgemployee b on a.dept_num=b.dept_num
group by a.dept_num
--14
select a.dept_num, a.emp_num, a.emp_fname, a.emp_lname,
max( b.sal_amount) as LARGESTSALARY
from lgemployee a inner join lgsalary_history b on a.emp_num =b.emp_num
	join lgdepartment c on a.dept_num = c.dept_num
where c. dept_num = 200
group by a.dept_num, a.emp_num, a.emp_fname, a.emp_lname
order by LARGESTSALARY desc
--15
select a.cust_code, a.cust_fname, a.cust_lname, sum(b.inv_total) as TOTALINVOICES
from lgcustomer a inner join lginvoice b on a.cust_code = b.cust_code
group by a.cust_code,  a.cust_fname, a.cust_lname
having sum(b.inv_total) >1500
order by TOTALINVOICES desc
--16*
select a.dept_num, a.dept_name, a.dept_phone, a.emp_num, b.emp_lname
from lgdepartment a inner join lgemployee b on a.emp_num=b.emp_num 									
order by dept_name 
--17
select d.vend_id, d.vend_name, a.brand_name, count(c.prod_sku) [NUMPRODUCTS]
from (lgproduct b inner join lgbrand a on a.brand_id = b.brand_id) inner join
	lgsupplies c on (c.prod_sku = b.prod_sku) inner join
	lgvendor d on( c.vend_id = d.vend_id)
group by d.vend_id, d.vend_name, a.brand_name
order by vend_name, brand_name
--18
select a.emp_num, a.emp_lname, a.emp_fname, sum(b.inv_total) as [TOTALINVOICES]
from lgemployee a inner join lginvoice b on a.emp_num = b.employee_id
group by a.emp_num, a.emp_lname, a.emp_fname
order by a.emp_lname, a.emp_fname
--19
select top 1 avg(a.prod_price) as [LARGEST AVERAGE]
from lgproduct a inner join lgbrand b on a.brand_id = b.brand_id
group by  b.brand_id
order by [LARGEST AVERAGE] desc
--20
select top 1 b.brand_id, b.brand_name, b.brand_type, Cast (avg(a.prod_price)as decimal(10,2)) as AVGPRICE
from lgproduct a inner join lgbrand b on a.brand_id = b.brand_id
group by b.brand_id, b.brand_name, b.brand_type
order by AVGPRICE desc
--21*
select  b.emp_fname+ ' ' + b.emp_lname as 'MANAGER NAME',
		a.dept_num, a.dept_name, a.dept_phone, b.emp_fname +' ' +b.emp_lname as 'EMPLOYEE NAME',
		c.cust_fname + ' ' +c.cust_lname as [Customer name],
		d.inv_date, d.inv_total
from (lgdepartment a inner join lgemployee b on a.dept_num = b.dept_num )
inner join lginvoice d on (d.employee_id =b.emp_num)
inner join lgcustomer c on (d.cust_code = c.cust_code)
where c.cust_lname like 'hagan' and d.inv_date='2013-may-18'                                                                                                                                                                                                                                  