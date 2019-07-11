# itachigorun 


查询数据库状态
SQL> select database_status from v$instance;

DATABASE_STATUS
-------------------
ACTIVE

查询实例活动状态
SQL> select active_state from v$instance;
ACTIVE_ST
---------------
NORMAL

SQL> select status from v$instance;
STATUS
---------
OPEN

SELECT * FROM ALL_OBJECTS WHERE OBJECT_NAME ='your_table_name'  查询表所有的储存信息

1.查询表空间
#sqlplus / as sysdba
SQL> select tablespace_name from dba_tablespaces;

TABLESPACE_NAME
------------------------------
SYSTEM
SYSAUX
UNDOTBS1
TEMP
USERS
TBS_FCS_SUM

已选择6行。

SQL> select * from v$tablespace;

       TS# NAME                           INC BIG FLA ENC
---------- ------------------------------ --- --- --- ---
         0 SYSTEM                         YES NO  YES
         1 SYSAUX                         YES NO  YES
         2 UNDOTBS1                       YES NO  YES
         4 USERS                          YES NO  YES
         3 TEMP                           NO  NO  YES
         6 TBS_FCS_TEMP                   NO  NO  YES
         7 TBS_FCS_DEFAULT                YES NO  YES
         8 TBS_FCS_SUM                    YES NO  YES
         9 TBS_FCS_DTL                    YES NO  YES
        10 TBS_FCS_FLUX                   YES NO  YES
        11 TBS_FCS_REG                    YES NO  YES

       TS# NAME                           INC BIG FLA ENC
---------- ------------------------------ --- --- --- ---
        12 TBS_FCS_TICK                   YES NO  YES
        13 TBS_FRS_TEMP                   NO  NO  YES
        14 TBS_FRS_DATA                   YES NO  YES
        15 TBS_FEP_TEMP                   NO  NO  YES
        16 TBS_FEP_DEFAULT                YES NO  YES
        17 TBS_FEP_DATA                   YES NO  YES

已选择17行。

2. 查看表空间详细信息
SQL> desc dba_data_files;
 名称                                      是否为空? 类型
 ----------------------------------------- -------- ----------------------------
 FILE_NAME                                          VARCHAR2(513)
 FILE_ID                                            NUMBER
 TABLESPACE_NAME                                    VARCHAR2(30)
 BYTES                                              NUMBER
 BLOCKS                                             NUMBER
 STATUS                                             VARCHAR2(9)
 RELATIVE_FNO                                       NUMBER
 AUTOEXTENSIBLE                                     VARCHAR2(3)
 MAXBYTES                                           NUMBER
 MAXBLOCKS                                          NUMBER
 INCREMENT_BY                                       NUMBER
 USER_BYTES                                         NUMBER
 USER_BLOCKS                                        NUMBER
 ONLINE_STATUS                                      VARCHAR2(7)


SQL> select * from dba_data_files;

FILE_NAME
--------------------------------------------------------------------------------
   FILE_ID TABLESPACE_NAME                     BYTES     BLOCKS STATUS
---------- ------------------------------ ---------- ---------- ---------
RELATIVE_FNO AUT   MAXBYTES  MAXBLOCKS INCREMENT_BY USER_BYTES USER_BLOCKS
------------ --- ---------- ---------- ------------ ---------- -----------
ONLINE_
-------
/opt/oracle/oradata/accdb/users01.dbf
         4 USERS                             5242880        640 AVAILABLE
           4 YES 3.4360E+10    4194302          160    4194304         512
ONLINE

3. alter table 表名 add constraint 约束名 约束内容
Oracle创建表和约束
create table INFOS(
     STUID      varchar2(7) not null,         --学号 学号=‘S’+班号+2位序号
     STUNAME    varchar2(10) not null,        --姓名
     GENDER     varchar2(2) not null,         --性别 
     AGE        number(2) not null,           --年龄
     SEAT       number(2) not null,           --座号
     ENROLLDATE    date,                      --入学时间
     STUADDRESS       varchar2(50) default '地址不详',     --住址
     CLASSNO          varchar2(4) not null,               --班号 班号=学期序号+班级序号 
);

alter table INFOS add constraint pk_INFOS primary key(STUID)  

alter table INFOS add constraint ck_INFOS_gender check(GENDER = '男' or GENDER = '女')  

alter table INFOS add constraint ck_INFOS_SEAT check(SEAT >=0 and SEAT <=50) 

alter table INFOS add constraint ck_INFOS_AGE check(AGE >=0 and AGE<=100) 

alter table INFOS add constraint ck_INFOS_CLASSNO check((CLASSNO >='1001' and CLASSNO<='1999') or
(CLASSNO >='2001' and CLASSNO<='2999'))  

alter table INFOS add constraint un_STUNAME unique(STUNAME)

4.禁用主键
语法：
ALTER TABLE table_name DISABLE CONSTRAINT constraint_name;  
示例：
alter table tb_employees disable constraint tb_employees_pk;  

5.启用主键
语法：
ALTER TABLE table_name ENABLE CONSTRAINT constraint_name;  
示例：
ALTER table tb_employees enable constraint tb_employees_pk;  

6.删除主键
语法：
ALTER TABLE table_name DROP CONSTRAINT constraint_name;  
示例：
alter table tb_employees drop constraint tb_employees_pk;  
alter table tb_departments drop constraint tb_departments_pk;  
alter table TB_PK_EXAMPLE drop constraint TB_PK_EXAMPLE_PK;  
alter table TB_SUPPLIER_EX drop constraint TB_SUPPLIER_EX_PK;  

7.Oracle表字段的增加、删除、修改和重命名
增加字段语法：
alter table tablename add (column datatype [default value][null/not null],….);
说明：
alter table 表名 add (字段名 字段类型 默认值 是否为空);
例：
alter table sf_users add (HeadPIC blob);
例：
alter table sf_users add (userName varchar2(30) default '空' not null);

修改字段的语法：
alter table tablename modify (column datatype [default value][null/not null],….); 
说明：
alter table 表名 modify (字段名 字段类型 默认值 是否为空);
例：
alter table sf_InvoiceApply modify (BILLCODE number(4));

删除字段的语法：
alter table tablename drop (column);
说明：
alter table 表名 drop column 字段名;
例：
alter table sf_users drop column HeadPIC;

字段的重命名：
说明：
alter table 表名 rename  column  列名 to 新列名   （其中：column是关键字）
例：
alter table sf_InvoiceApply rename column PIC to NEWPIC;

表的重命名：
说明：
alter table 表名 rename to  新表名
例：
alter table sf_InvoiceApply rename to  sf_New_InvoiceApply;

8.SQL增删改查语句
1、INSERT INTO 语句
(1)插入新的一行数据
INSERT INTO Persons VALUES ('Gates', 'Bill', 'Xuanwumen 10', 'Beijing');  
(2)在指定的列中插入数据
INSERT INTO Persons (LastName, Address) VALUES ('Wilson', 'Champs-Elysees');  
(3)在添加时复制所有数据：
insert into userinfo_new select * from userinfo;  
(4)在添加时复制部分数据：
insert into userinfo_new(id,username) select id,username from userinfo;  

2、create 语句可用于创建表的备份复件
(1)在建表时复制所有数据：
create table userinfo_new as select * from userinfo;  
(2)在建表时复制部分数据：
create table userinfo_new1 as select id,username from userinfo;  

3、Update 语句
(1)无条件更新:
update userinfo set userpwd='111',email='111@126.com';  
(2)有条件更新:
update userinfo set userpwd='123456' where username='xxx';  

4、DELETE 语句
(1)无条件删除：
delete from userinfo;  
(2)有条件删除：
delete from userinfo where username='yyy';  

5、SELECT 语句
(1)查询所有字段:
select * from users;  
(2)查询指定字段:
select username,salary from users;  
(3)SELECT DISTINCT 语句
如需从"Company"列中仅选取唯一不同的值，我们需要使用 SELECT DISTINCT 语句：
SELECT DISTINCT Company FROM Orders;   

3、SQL where
选取居住在城市 "Beijing" 中的人，我们需要向 SELECT 语句添加 WHERE 子句：
SELECT * FROM Persons WHERE City='Beijing';  
注意：SQL 使用单引号来环绕文本值（大部分数据库系统也接受双引号）。如果是数值，请不要使用引号。
4、SQL AND & OR
(1)使用 AND 来显示所有姓为 "Carter" 并且名为 "Thomas" 的人：
SELECT * FROM Persons WHERE FirstName='Thomas' AND LastName='Carter';  
(2)使用 OR 来显示所有姓为 "Carter" 或者名为 "Thomas" 的人：
SELECT * FROM Persons WHERE firstname='Thomas' OR lastname='Carter';  

5、ORDER BY 语句用于对结果集进行排序。
(1)以字母顺序显示公司名称：
SELECT Company, OrderNumber FROM Orders ORDER BY Company;  
(2)以字母顺序显示公司名称（Company），并以数字顺序显示顺序号（OrderNumber）：
SELECT Company, OrderNumber FROM Orders ORDER BY Company, OrderNumber;  
(3)以逆字母顺序显示公司名称：
SELECT Company, OrderNumber FROM Orders ORDER BY Company DESC;  
(4)以逆字母顺序显示公司名称，并以数字顺序显示顺序号：
SELECT Company, OrderNumber FROM Orders ORDER BY Company DESC, OrderNumber ASC;  

6、TOP 子句
SQL Server 的语法：
从"Persons" 表中选取头两条记录:
SELECT TOP 2 * FROM Persons;  
从"Persons" 表中选取 50% 的记录:
SELECT TOP 50 PERCENT * FROM Persons;  
MySQL 语法:
从"Persons" 表中选取头两条记录:
SELECT * FROM Persons LIMIT 2;  
Oracle 语法:
从"Persons" 表中选取头两条记录:
SELECT * FROM Persons WHERE ROWNUM <= 2;  

7、LIKE 操作符、SQL 通配符
(1)从"Persons" 表中选取居住在以 "N" 开始的城市里的人：
SELECT * FROM Persons WHERE City LIKE 'N%';  
(2)从"Persons" 表中选取居住在以 "g" 结尾的城市里的人：
SELECT * FROM Persons WHERE City LIKE '%g';  
(3)从 "Persons" 表中选取居住在包含 "lon" 的城市里的人：
SELECT * FROM Persons WHERE City LIKE '%lon%' ;  
(4)从 "Persons" 表中选取居住在不包含 "lon" 的城市里的人：
SELECT * FROM Persons WHERE City NOT LIKE '%lon%';  
(5)从"Persons" 表中选取名字的第一个字符之后是 "eorge" 的人：
SELECT * FROM Persons WHERE FirstName LIKE '_eorge';  
(6)从"Persons" 表中选取的这条记录的姓氏以 "C" 开头，然后是一个任意字符，然后是 "r"，然后是任意字符，然后是 "er"：
SELECT * FROM Persons WHERE LastName LIKE 'C_r_er';  
(7)从"Persons" 表中选取居住的城市以 "A" 或 "L" 或 "N" 开头的人：
SELECT * FROM Persons WHERE City LIKE '[ALN]%';  
(8)从"Persons" 表中选取居住的城市不以 "A" 或 "L" 或 "N" 开头的人：
SELECT * FROM Persons WHERE City LIKE '[!ALN]%';  

8、IN 操作符
从表中选取姓氏为 Adams 和 Carter 的人：
SELECT * FROM Persons WHERE LastName IN ('Adams','Carter');  

9、BETWEEN 操作符
以字母顺序显示介于 "Adams"（包括）和 "Carter"（不包括）之间的人：
SELECT * FROM Persons WHERE LastName BETWEEN 'Adams' AND 'Carter';  
注意：不同的数据库对 BETWEEN...AND 操作符的处理方式是有差异的。某些数据库会列出介于 "Adams" 和 "Carter" 之间的人，但不包括 "Adams" 和 "Carter" ；某些数据库会列出介于 "Adams" 和 "Carter" 之间并包括 "Adams" 和 "Carter" 的人；而另一些数据库会列出介于 "Adams" 和 "Carter" 之间的人，包括 "Adams" ，但不包括 "Carter" 。
所以，请检查你的数据库是如何处理 BETWEEN....AND 操作符的！

10、为列名称和表名称指定别名（Alias）
(1)表的 SQL Alias 语法
SELECT po.OrderID, p.LastName, p.FirstName FROM Persons AS p, Product_Orders AS po WHERE p.LastName='Adams' AND p.FirstName='John';  
(2)列的 SQL Alias 语法
SELECT LastName AS Family, FirstName AS Name FROM Persons;  

10、Join(Inner Join)、Left Join(Left Outer Join)、Right Join(Right Outer Join)、Full Join(Full Outer Join)
在使用left jion时，on和where条件的区别如下： 
1、on条件是在生成临时表时使用的条件，它不管on中的条件是否为真，都会返回左边表中的记录。 
2、where条件是在临时表生成好后，再对临时表进行过滤的条件。这时已经没有left join的含义（必须返回左边表的记录）了，条件不为真的就全部过滤掉。 
原因就是left join,right join,full join的特殊性，不管on上的条件是否为真都会返回left或right表中的记录，full则具有left和right的特性的并集。
而inner jion没这个特殊性，则条件放在on中和where中，返回的结果集是相同的。
"Persons" 表：
Id_P	LastName	FirstName      Address	        City
1	Adams	        John	       Oxford Street	London
2	Bush	        George	       Fifth Avenue	New York
3	Carter	        Thomas	       Changan Street	Beijing
"Orders" 表：
Id_O	OrderNo    Id_P
1	77895	   3
2	44678	   3
3	22456	   1
4	24562	   1
5	34764	   65 
(1)Join
用where 联表查询：
SELECT Persons.LastName, Persons.FirstName, Orders.OrderNo FROM Persons, Orders WHERE Persons.Id_P = Orders.Id_P ;  
用Join(Inner Join)查询：INNER JOIN 关键字在表中存在至少一个匹配时返回行。如果 "Persons" 中的行在 "Orders" 中没有匹配，就不会列出这些行。
ELECT Persons.LastName, Persons.FirstName, Orders.OrderNo FROM Persons INNER JOIN Orders ON Persons.Id_P = Orders.Id_P ORDER BY Persons.LastName;  
LastName	FirstName	OrderNo
Adams	        John	        22456
Adams	        John	        24562
Carter	        Thomas	        77895
Carter	        Thomas	        44678
(2)左外连接Left Join(Left Outer Join)：LEFT JOIN 关键字会从左表 (Persons) 那里返回所有的行，即使在右表 (Orders) 中没有匹配的行。
SELECT Persons.LastName, Persons.FirstName, Orders.OrderNo FROM Persons LEFT JOIN Orders ON Persons.Id_P=Orders.Id_P ORDER BY Persons.LastName;  
LastName	FirstName	OrderNo
Adams	        John	        22456
Adams	        John	        24562
Carter	        Thomas	        77895
Carter	        Thomas	        44678
Bush	        George	  
(3)右外连接Right Join(Right Outer Join)：RIGHT JOIN 关键字会从右表 (Orders) 那里返回所有的行，即使在左表 (Persons) 中没有匹配的行。
SELECT Persons.LastName, Persons.FirstName, Orders.OrderNo FROM Persons RIGHT JOIN Orders ON Persons.Id_P=Orders.Id_P ORDER BY Persons.LastName;  
LastName	FirstName	OrderNo
Adams	        John	        22456
Adams	        John	        24562
Carter	        Thomas	        77895
Carter	        Thomas	        44678
 	 	                34764 
(4)全连接Full Join(Full Outer Join)：FULL JOIN 关键字会从左表 (Persons) 和右表 (Orders) 那里返回所有的行。如果 "Persons" 中的行在表 "Orders" 中没有匹配，
或者如果 "Orders" 中的行在表 "Persons" 中没有匹配，这些行同样会列出。
SELECT Persons.LastName, Persons.FirstName, Orders.OrderNo FROM Persons FULL JOIN Orders ON Persons.Id_P=Orders.Id_P ORDER BY Persons.LastName;  
LastName	FirstName	OrderNo
Adams	        John	        22456
Adams	        John	        24562
Carter	        Thomas	        77895
Carter	        Thomas	        44678
Bush	        George	 
 	 	                34764
11、Union：UNION 操作符用于合并两个或多个 SELECT 语句的结果集。
注意：UNION 内部的 SELECT 语句必须拥有相同数量的列。列也必须拥有相似的数据类型。同时，每条 SELECT 语句中的列的顺序必须相同。UNION 结果集中的列名总是等于 UNION 中第一个 SELECT 语句中的列名。
Employees_China:
E_ID	E_Name
01	Zhang, Hua
02	Wang, Wei
03	Carter, Thomas
04	Yang, Ming
Employees_USA:
E_ID	E_Name
01	Adams, John
02	Bush, George
03	Carter, Thomas
04	Gates, Bill
(1)UNION命令列出所有在中国和美国的不同的雇员名：
SELECT E_Name FROM Employees_China UNION SELECT E_Name FROM Employees_USA;  
E_Name
Zhang, Hua
Wang, Wei
Carter, Thomas
Yang, Ming
Adams, John
Bush, George
Gates, Bill (2)UNION ALL 命令列出在中国和美国的所有的雇员：
SELECT E_Name FROM Employees_China UNION ALL SELECT E_Name FROM Employees_USA;  
E_Name
Zhang, Hua
Wang, Wei
Carter, Thomas
Yang, Ming
Adams, John
Bush, George
Carter, Thomas
Gates, Bill

12、SQL 的 NULL 值处理
(1)选取在 "Address" 列中带有 NULL 值的记录:
SELECT LastName,FirstName,Address FROM Persons WHERE Address IS NULL;  
(2)选取在 "Address" 列中不带有 NULL 值的记录:
SELECT LastName,FirstName,Address FROM Persons WHERE Address IS NOT NULL;  

13、SQL ISNULL()、NVL()、IFNULL() 和 COALESCE() 函数
P_Id	ProductName	UnitPrice	UnitsInStock	UnitsOnOrder
1	computer	699	        25	        15
2	printer 	365	        36	 
3	telephone	280	        159	        57 
在统计时，上表中UnitsOnOrder字段值如果为null不利于计算，所以要用函数将null值当做0计算。
SQL Server / MS Access:
SELECT ProductName,UnitPrice*(UnitsInStock+ISNULL(UnitsOnOrder,0)) FROM Products;  
Oracle:
SELECT ProductName,UnitPrice*(UnitsInStock+NVL(UnitsOnOrder,0)) FROM Products;  
MySQL:
SELECT ProductName,UnitPrice*(UnitsInStock+IFNULL(UnitsOnOrder,0)) FROM Products;  
或
SELECT ProductName,UnitPrice*(UnitsInStock+COALESCE(UnitsOnOrder,0)) FROM Products;  

14.Group by having
显示每个地区的总人口数和总面积.仅显示那些面积超过1000000的地区。
SELECT region, SUM(population), SUM(area) FROM bbc
GROUP BY region 
HAVING SUM(area)>1000000
在这里，我们不能用where来筛选超过1000000的地区，因为表中不存在这样一条记录。
相反，HAVING子句可以让我们筛选成组后的各组数据.


15.to_char来转换timestamp——>date：
SQL>select to_date(to_char(systimestamp,'yyyy-mm-dd hh24:mi:ss'),'yyyy-mm-dd hh24:mi:ss') from dual
SQL>select Systimestamp+0 FROM DUAL;
SQL>Select Cast(Systimestamp As Date) From dual;
date ——>timestamp：
SQL>select to_timestamp(to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'yyyy-mm-dd hh24:mi:ss') from dual
SQL>Select to_timestamp('2006-01-01 12:10:10.1','yyyy-mm-dd hh24:mi:ss.ff') From dual;

16.over函数