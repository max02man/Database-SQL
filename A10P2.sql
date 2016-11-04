--PART2
--CREATE TABLES
CREATE TABLE CUSTOMERDIM
(CUSTOMER_ID INT IDENTITY PRIMARY KEY,
CUST_CODE INT,
	[CUST_FNAME] [nvarchar](20),
	[CUST_LNAME] [nvarchar](20) ,
	[CUST_STREET] [nvarchar](70) ,
	[CUST_CITY] [nvarchar](50) ,
	[CUST_STATE] [nvarchar](2) ,
	[CUST_ZIP] [nvarchar](5) ,
	[CUST_BALANCE] [decimal](8, 2))
CREATE TABLE DEPARTMENTDIM
(DEPARTMENT_ID INT IDENTITY PRIMARY KEY,
	DEPT_NUM INT,	
	[DEPT_NAME] [nvarchar](50) ,
	[DEPT_MAIL_BOX] [nvarchar](3) ,
	[DEPT_PHONE] [nvarchar](9) ,
	[EMP_NUM] INT )
CREATE TABLE PRODUCTDIM
(PRODUCT_ID INT IDENTITY PRIMARY KEY,
	PROD_SKU NVARCHAR(15),
	[PROD_DESCRIPT] [nvarchar](255) ,
	[PROD_TYPE] [nvarchar](255) ,
	[PROD_BASE] [nvarchar](255) ,
	[PROD_CATEGORY] [nvarchar](255) ,
	[PROD_PRICE] [decimal](10, 2) ,
	[PROD_QOH] [decimal](10, 0) ,
	[PROD_MIN] [decimal](10, 0) ,
	[BRAND_ID] [int] )
CREATE TABLE EMPLOYEEDIM
(EMPLOYEE_ID INT IDENTITY PRIMARY KEY,
	EMP_NUM INT,
	[EMP_FNAME] [nvarchar](20) ,
	[EMP_LNAME] [nvarchar](25) ,
	[EMP_EMAIL] [nvarchar](25) ,
	[EMP_PHONE] [nvarchar](20) ,
	[EMP_HIREDATE] [datetime] ,
	[EMP_TITLE] [nvarchar](45) ,
	[EMP_COMM] [decimal](2, 2) ,
	[DEPT_NUM] [int] )

CREATE TABLE TIMEDIM 
	(TIME_ID INT IDENTITY PRIMARY KEY,
	ORDER_DATE DATETIME);
INSERT INTO TIMEDIM
SELECT INV_DATE
FROM LGINVOICE
GROUP BY INV_DATE

ALTER TABLE TIMEDIM
ADD [YEAR] INT,[MONTH] INT;

	UPDATE TIMEDIM
SET [YEAR]= YEAR(ORDER_DATE),
	[MONTH] =MONTH (ORDER_DATE);

Create TABLE FACT
	(CUSTOMER_ID int NOT NULL,
	DEPARTMENT_ID int NOT NULL ,
	PRODUCT_ID INT NOT NULL,
	EMPLOYEE_ID int NOT NULL,
	TIME_ID int NOT NULL,
	PRICE float,
	QUANTITY int);

--ADD KEYS
ALTER TABLE FACT
ADD CONSTRAINT PK_FACT PRIMARY  KEY (CUSTOMER_ID, DEPARTMENT_ID, PRODUCT_ID, 
									EMPLOYEE_ID,TIME_ID)
ALTER TABLE FACT
ADD CONSTRAINT FK_FACT_CUSTOMER FOREIGN KEY (CUSTOMER_ID)REFERENCES CUSTOMERDIM,
	CONSTRAINT FK_FACT_DEPARTMENT FOREIGN KEY (DEPARTMENT_ID)REFERENCES DEPARTMENTDIM,
	CONSTRAINT FK_FACT_PRODUCT FOREIGN KEY (PRODUCT_ID)REFERENCES PRODUCTDIM,
	CONSTRAINT FK_FACT_EMPLOYEE FOREIGN KEY (EMPLOYEE_ID)REFERENCES EMPLOYEEDIM,
	CONSTRAINT FK_FACT_TIME FOREIGN KEY (TIME_ID)REFERENCES TIMEDIM;

select *
from DEPARTMENTDIM
select CUST_CODE
from CUSTOMERDIM

--INSERT DATA

insert into CUSTOMERDIM 
select *
from LGCUSTOMER;

insert into DEPARTMENTDIM
select *
from LGDEPARTMENT;

insert into PRODUCTDIM 
select *
from LGPRODUCT;

insert into EMPLOYEEDIM 
select *
from LGEMPLOYEE;

drop table CUSTOMERDIM
drop table DEPARTMENTDIM
drop table PRODUCTDIM
drop table FACT
--TESTINHG THE DATA
SELECT DISTINCT C.CUST_CODE,D.DEPT_NUM, P.PROD_SKU, E.EMP_NUM,S.INV_DATE
FROM LGINVOICE S INNER JOIN LGCUSTOMER C ON S.CUST_CODE = C.CUST_CODE
INNER JOIN LGEMPLOYEE E ON S.EMPLOYEE_ID= E.EMP_NUM 
INNER JOIN LGDEPARTMENT D ON E.EMP_NUM = D.EMP_NUM
INNER JOIN LGLINE L ON S.INV_NUM = L.INV_NUM
INNER JOIN LGPRODUCT P ON P.PROD_SKU = L.PROD_SKU