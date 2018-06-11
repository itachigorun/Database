1.
sys             --系统管理员，拥有最高权限
system          --本地管理员，次高权限
scott           --普通用户，密码默认为tiger,默认未解锁

sqlplus / as sysdba             --登陆sys帐户
sqlplus sys as sysdba           --同上
sqlplus scott/tiger             --登陆普通用户scott

2.
SQLPlus 在连接时通常有
 
1). sqlplus / as sysdba   --以操作系统权限认证的oracle sys管理员登陆
    操作系统认证，不需要数据库服务器启动listener，也不需要数据库服务器处于可用状态。比如我们想要启动数据库就可以用这种方式进入
    sqlplus，然后通过startup命令来启动。

2). sqlplus username/password
    连接本机数据库，不需要数据库服务器的listener进程，但是由于需要用户名密码的认证，因此需要数据库服务器处于可用状态才行。

3). sqlplus usernaem/password@orcl
    通过网络连接，这是需要数据库服务器的listener处于监听状态。此时建立一个连接的大致步骤如下　
　　a. 查询sqlnet.ora，看看名称的解析方式，默认是TNSNAME　　
　　b. 查询tnsnames.ora文件，从里边找orcl的记录，并且找到数据库服务器的主机名或者IP，端口和service_name　　
　　c. 如果服务器listener进程没有问题的话，建立与listener进程的连接。　　
　　d. 根据不同的服务器模式如专用服务器模式或者共享服务器模式，listener采取接下去的动作。默认是专用服务器模式，没有问题的话客户端
      就连接上了数据库的server process。
　　e. 这时连接已经建立，可以操作数据库了。

4). sqlplus username/password@//host:port/sid
　　用sqlplus远程连接oracle命令(例：sqlplus risenet/1@//192.168.130.99:1521/risenet)

5). sqlplus /nolog             --不在cmd或者terminal当中暴露密码的登陆方式
   SQL> conn /as sysdba
   &
   SQL> conn sys/password as sysdba

6). sqlplus scott/tiger      --非管理员用户登陆

7). sqlplus scott/tiger@orcl    --非管理员用户使用tns别名登陆

8). sqlplus                       --不显露密码的登陆方式
   Enter user-name：sys
   Enter password：password as sysdba     --以sys用户登陆的话 必须要加上 as sysdba 子句


3.
创建用户
create user name identified by password default tablespace tbs_default temporary tablespace tbs_tempem

4.
添加/取消用户的权限       grant/revoke ** to/from **
Create session          --连接数据库,登录权限
Create sequence         --创建序列
Create synonym          --创建同名对象
Create table            --创建表
Create any table        --创建任何模式的表
Drop table              --删除表
Create procedure        --创建存储过程
Execute any procedure   --执行任何模式的存储过程
Create user             --创建用户
Create view             --创建视图
Drop user               --删除用户
Drop any table          --删除任何模式的表
dba                     --授予DBA权限
select any table        --授予查询任何表  
select any dictionary   --授予查询任何字典 
unlimited session to    --授予用户使用表空间
insert table to         --插入表的权限
update table to         --修改表的权限

grant connect, resource, dba to username;
GRANT CREATE USER, DROP USER, ALTER USER, CREATE ANY VIEW, DROP ANY VIEW,EXP_FULL_DATABASE,IMP_FULL_DATABASE, DBA,CONNECT,RESOURCE,CREATE SESSION TO  caiyl;  
GRANT CREATE PUBLIC DATABASE LINK TO fcs;
GRANT CONNECT TO fcs;
GRANT RESOURCE TO fcs;
GRANT CREATE ANY VIEW TO fcs;
GRANT CREATE ANY PROCEDURE TO fcs;
GRANT DEBUG ANY PROCEDURE TO fcs;
GRANT DEBUG CONNECT SESSION TO fcs;
GRANT EXECUTE ANY PROCEDURE TO fcs;

5.查询用户权限

5.1查询所有用户
select * from all_users;

5.2查询用户权限
select * from user_sys_privs;

5.3赋予username用户对tmpname表空间的操作权限
alter user username quota unlimited on tmpname;