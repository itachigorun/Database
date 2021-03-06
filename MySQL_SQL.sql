# itachigorun 2017-02-18


1.MySQL服务操作指令：
service mysql start | stop | restart | status

2.登录
mysql -u root -p ***


数据定义语言(DDL): CREATE ALTER DROP 
数据操作语言(DML): INSERT UPDATE DELETE
数据控制语句(DCL): GRANT REVOKE

3.
显示数据库: show databases;
创建数据库: CREATE DATABASE test_db;
查看创建好的数据库***定义: SHOW CREATE DATABASE test_db\G
删除数据库: DROP DATABASE test_db；
查看系统所支持的引擎类型: SHOW ENGINES\G

4.表的操作
USE test_db;

CREATE TABLE tb_emp1
(
id      INT(11) PRIMARY KEY, 
name    VARCHAR(25) NOT NULL,
deptId  INT(11) UNIQUE  DEFAULT 1111,       /* 唯一性约束允许为空，但只能有一个空值 */
salary  FLOAT
);
-- 一个表中只能有一个字段声明为PRIMARY KEY, 但可以有多个字段声明为UNIQUE,
   可以声明多字段练个主键PRIMARY KEY(字段1，字段2，字段3)
CREATE TABLE tb_emp1
(
id      INT(11),
name    VARCHAR(25),
deptId  INT(11),
salary  FLOAT,
PRIMARY KEY(id,name)
);


查看可用数据库的列表
mysql> show databases;

查看当前数据库内可用表的列表
mysql> show tables;

显示表列（表名：customers）
mysql> show columns from customers;

显示服务器错误或警告消息
mysql> show errors;
mysql> show warnings;
