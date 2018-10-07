一、安装
1.
groupadd oinstall                                   --创建用户组oinstall
groupadd dba                                        --创建用户组dba
chatter -i /etc/passwd  /etc/shadow                 --设定安全策略，允许修改此文件
useradd -g oinstall -G dba oracle                   --创建oracle用户，并加入oinstall和dba组
passwd oracle                                       --修改oracle用户密码
mkdir –p /oracle                                    --建立oracle安装目录
chown -R oracle:oinstall /oracle                    --指定oracle安装目录用户组
chmod -R 775 /oracle                                --修改oracle安装目录权限
chatter +i /etc/passwd  /etc/shadow                 --设定配置文件权限，避免信息被篡改

2.
修改 /etc/sysctl.conf
fs.aio-max-nr = 1048576         //异步I/O请求数目
fs.file-max = 6815744           //一个进程可以打开的文件句柄的最大数量
kernel.shmmax = 34359738368     //共享内存段的最大尺寸，需要小于SGA MAX SIZE，大小为shmall*页大小(4K)
kernel.shmmni = 4096            //共享内存的最大数量，ipcs -sa
kernel.shmall = 8388608         //控制共享内存页数
kernel.sem = 250 32000 100 128  //设置的信号量
net.ipv4.ip_local_port_range = 9000 65500    //专用服务器模式下与用户进程通信时分配给用户的端口区间
net.core.rmem_default = 262144  //默认接受缓冲区大小
net.core.remem_max = 4194304    //接收缓冲区最大值
net.core.wmem_default = 262144  //发送缓冲区最大值
wm.nr_hugepages = xxxx          //设置HugePage大小

sysctl -p 生效

3.
修改/etc/security/limits.conf,增加以下内容
#oracle 
oracle soft nproc 2047
oracle hard nproc 16384         -进程最大数目，对oracle用户生效
oracle soft nofile 1024
oracle hard nofile 65536        -打开文件的最大数目，对oracle用户生效

4.
编辑/etc/pam.d/login文件   （将配置文件加入到登录验证模块）
session    required    pam_limits.so
 
5.
修改.bash_profile文件
if [ $USER = "oracle" ]; then
        if [ $SHELL = "/bin/ksh" ]; then
              ulimit -p 16384
              ulimit -n 65536
        else
              ulimit -u 16384 -n 65536
        fi
fi

export ORACLE_SID=orcl
export ORACLE_BASE=/oracle
export ORACLE_HOME=$ORACLE_BASE/product/11.2.0.4/dbhome_1
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/usr/lib:/usr/local/lib
export PATH=$HOME/bin:$ORACLE_HOME/bin:${PATH}:
export NLS_LANG="Simplified Chinese_CHINA.ZHS16GBK"
export TNS_ADMIN=$ORACLE_HOME/network/admin
export DISPLAY=localhost:0.0
export NLS_LANG="SIMPLIFIED CHINESE_CHINA.ZHS16GBK"     //设置字符编码
source .bash_profile生效

6.
$ ./runInstaller                                    --安装oracle

7.
监听配置#netmgr 
选择监听程序LISTENER，选择数据库服务，点击添加数据库，全局数据库名字改
一下，保存。

8.
建表空间、建用户、赋权限

9.
建表、导入数据

10.
永久关闭防火墙
查看状态service  iptables status 
开启： chkconfig iptables on
关闭： chkconfig iptables off




1.
SQL> select name from v$datafile;                   --查看数据文件的情况

2.
导入的命令：
imp admin/sa@orcl file=./test.dmp full=y 

以上是导入全部的数据。如果不想导入全部的数据而是导入一个表或者是部分表的数据则用以下语句：
imp admin/sa@orcl file=./test.dmp tables=student,class

导出数据：(oracle11g新特性，如果表为空，则默认不分配内存，导出数据会报错，直到有数据或强制分配)

1). 将数据库t1完全导出,导出
exp t1/t1@orcl file=./test.dmp full=y

2). 将数据库中的testuser用户的表导出 
exp t1/t1@orcl file=./test.dmp owner=testuser

3). 将数据库中的表student,class导出 
exp t1/t1@orcl file=./test.dmp tables=student,class

4).将数据库中student表中filed字段中等于table的数据导出 
exp t1/t1@orcl file=./test.dmp tables=student query=\" where filed=\'table\' \"

5).用exp命令导出表结构，不导出表数据。只需在命令行里加一个参数rows=n即可。表示不导出表数据。
exp username/pwd@sid file=d:/data/bak.dmp owner=(user)rows=n  

3.
查看dump文件的一些基本信息,列出dump文件前十行ASCII信息
$ strings test.dmp | head -10

4.
列出dump文件中的表信息
$  strings fep.dmp | grep "CREATE TABLE "|awk '{print $3} '|sed 's/"//g'

5.
查询数据库日志操作模式
SQL> archive log list 


查询数据库名(db_name)
1.SQL> select name from v$database;
2.SQL> show parameter db;

查询数据库状态
SQL> select status from v$instance;

查询实例名(system identifier:SID)
1.SQL> select instance_name from v$instance;
2.SQL> show parameter instance;
3.SQL> select instance_name,host_name from v$instance;

查询数据库域名(db_domain)
1.SQL> select value from v$parameter where name = 'db_domain';
2.SQL> show parameter domain

查询数据库服务名(service_name) 缺省：db_name.db_domain 即等于全局数据库 该值可以不等于SID
1.SQL> select value from v$parameter where name = 'service_name';
2.SQL> show parameter service_name

全局数据库名(global_name)=数据库名+数据库域名 db_name.db_domain  表示唯一一个数据库
如果数据库有域名，则数据库服务名就是全局数据库名；否则，数据库服务名与数据库名相同。


查询用户的所有表
SQL> select table_name from tab;
SQL> select table_name from user_tables;
SQL> select tname from tab;

查询连接数：
SQL>select sid,serial#,username,program,machine,status,b.LOGON_TIME
 from v$session b order by status,b.LOGON_TIME;
SQL>select count(*), username, status from v$session group by username, status; 
查询最大连接数：
SQL>select value from v$parameter where name ='processes'

SQL>select count(*) from v$process ;    --当前的数据库连接数
SQL>select count(*) from v$session where status='ACTIVE';　--并发连接数

查看表空间碎片率，fsfi小于30则表空间碎片太多
1.
SQL>select a.tablespace_name,
trunc(sqrt(max(blocks)/sum(blocks))* (100/sqrt(sqrt(count(blocks)))),2) fsfi 
from dba_free_space  a,dba_tablespaces b
where a.tablespace_name=b.tablespace_name
and b.contents not in('TEMPORARY','UNDO','SYSAUX')
group by A.tablespace_name 
order by fsfi; 

2.
SQL>
select tablespace_name,
       round(sqrt(max(blocks) / sum(blocks)) *
             (100 / sqrt(sqrt(count(blocks)))),
             2) FSFI,
       (case
         when sqrt(max(blocks) / sum(blocks)) *
              (100 / sqrt(sqrt(count(blocks)))) > = 30 then
          '正常'
         when sqrt(max(blocks) / sum(blocks)) *
              (100 / sqrt(sqrt(count(blocks)))) < 30 then
          '表空间破碎化程度高，请整理'
       end) Prompt
  from dba_free_space
group by tablespace_name
order by 2;

count(1) 和 group by 的联合使用
select ticket_id,txn_date, count(1) from tbl_dtl group by ticket_id,txn_date having count(1)>1

3.查询数据库版本
SQL>
select* from v$version;

4.查看当前登录的用户的表
SQL>
select table_name from user_tables;

5.查看当前用户sequence
SQL>
select sequence_name from user_sequences;

TEST为用户名，用户名必须是大写。
select * from all_tables where owner='TEST';

--查看用户和默认表空间的关系
select username,default_tablespace from dba_users;
--查看当前用户能访问的表
select * from user_tables; 
--Oracle查询用户表
select * from user_all_tables;

--Oracle查询用户视图
select * from user_views;
--查询所有函数和储存过程：
select * from user_source;
--查询所有用户：
select * from all_users;
--select * from dba_users
--查看当前用户连接：
select * from v$Session;
--查看用户角色
SELECT * FROM USER_ROLE_PRIVS;
--查看当前用户权限：
select * from session_privs;
--查看所有用户所拥有的角色
SELECT * FROM DBA_ROLE_PRIVS;
--查看所有角色
select * from dba_roles;
--查看数据库名
SELECT NAME FROM V$DATABASE;
--查看所有表空间使用情况
select a.file_id "FileNo",
       a.tablespace_name "Tablespace_name",
       a.bytes "Bytes",
       a.bytes - sum(nvl(b.bytes, 0)) "Used",
       sum(nvl(b.bytes, 0)) "Free",
       sum(nvl(b.bytes, 0)) / a.bytes * 100 "%free"
  from dba_data_files a, dba_free_space b
 where a.file_id = b.file_id(+)
 group by a.tablespace_name, a.file_id, a.bytes
 order by a.tablespace_name;

 6.解锁表
 --查询被锁的表
select b.owner,b.object_name,a.session_id,a.locked_mode from v$locked_object a,dba_objects b where b.object_id = a.object_id;

--查看是哪个session引起的
select b.username,b.sid,b.serial#,logon_time from  v$locked_object a,v$session b where a.session_id = b.sid order by b.logon_time;

--杀掉对应进程即解锁
alter system kill session'866,20840'    --其中866是sid 20840是serial#

1、系统权限分类：
DBA: 拥有全部特权，是系统最高权限，只有DBA才可以创建数据库结构。
RESOURCE:拥有Resource权限的用户只可以创建实体，不可以创建数据库结构。
CONNECT:拥有Connect权限的用户只可以登录Oracle，不可以创建实体，不可以创建数据库结构。
