1. 删除实例
1 #su - root
2 #cd "$DB2_HOME"/instance
3 #db2stop
4 删除实例 #./db2idrop -f db2instl
5 删除用户 #userdel db2instl
6 删除目录 #rm -rf db2instl

删除单个数据库
1 su - db2instl
2 db2start
3 db2 drop db fcsdb
3 db2stop

2. 查询表空间状态
db2 SELECT TBSP_NAME, TBSP_USABLE_PAGES, TBSP_USED_PAGES FROM SYSIBMADM.SNAPTBSP_PART

列出所有表空间的详细信息
#db2 list tablespaces show detail

列出表空间balance信息
#db2 list utilities show detail
扩大单个表空间(5000指的是页数)
db2 "ALTER TABLESPACE TBS_FCS_DEFAULT RESIZE (ALL 50000)"

3. #su - db2usrl
#db2start
开机自启#db2set DB2AUTOSTART=YES
开启tcpip协议访问#db2set DB2COMM=TCPIP   
开启oracle兼容#db2set DB2_COMPATIBILITY_VECTOR=ORA   
#以中文编码保存数据#db2set DB2CODEPAGE=1386
开启联合数据库功能#db2 UPDATE DBM CFG USING FEDERATED YES
指定db2instl的服务名#db2 UPDATE DBM CFG USING SVCENAME DB2_db2instl(图形和命令都必须执行)


4. 看锁表的情况
db2的命令中：
db2 => get snapshot for locks on databasename
可以看到什么表被锁住了。
其中有一项： Application handle表示进程的标识号。该进程锁住什么表在下面会详细的列出来。
或者
list application for database yourdatabasename show detail
看看应用程序执行的情况
断掉连接：通过
force application all //强行终止所有连接
terminate //清除所有db2的后台进程
将所有的进程全部清除
或者：
force application(进程号)，将特定的进程号kill

删除表数据：
DELETE  from DB2NC.TBL_STL_OD_FLUX_20170101 WHERE TBL_STL_OD_FLUX_20170101.STL_DATE='20170108'

更新表数据：
UPDATE TBL_STL_FILE_CTL SET PROC_STAT = 3

db2 number 有没有这个字段


5. DB2数据库回滚过程查询
db2pb -db DBNAME -reco --查看当前主节点回滚情况
db2pd -db DBNAME -reco -alldbp --查看当前主机所有分区的回滚情况

[db2nc@localhost ~]$ db2pd -db fcsdb -reco -alldbp

Database Partition 0 -- Database FCSDB -- Active -- Up 0 days 01:36:35 -- Date 03/01/2017 23:35:44

Recovery:
Recovery Status     0x00000C01
Current Log                     
Current LSN         0000000FE4D44757
Job Type            CRASH RECOVERY      
Job ID              1         
Job Start Time      (1488376754) Wed Mar  1 21:59:14 2017
Job Description     Crash Recovery  
Invoker Type        User     
Total Phases        2         
Current Phase       1         

Progress:
Address            PhaseNum   Description          StartTime           CompletedWork                TotalWork           
0x0000000200BDF1A8 1          Forward              Wed Mar  1 21:59:14 824446199 bytes              1342177280 bytes            
0x0000000200BDF330 2          Backward             NotStarted          0 bytes                      1342177280 bytes            

或者
[db2nc@localhost ~]$ db2 list utilities show detail

ID                               = 1
Type                             = CRASH RECOVERY
Database Name                    = FCSDB
Partition Number                 = 0
Description                      = Crash Recovery
Start Time                       = 03/01/2017 21:59:14.188000
State                            = Executing
Invocation Type                  = User
Progress Monitoring:
   Estimated Percentage Complete = 31
   Phase Number [Current]        = 1
      Description                = Forward
      Total Work                 = 1342177280 bytes
      Completed Work             = 843542302 bytes
      Start Time                 = 03/01/2017 21:59:14.188043

   Phase Number                  = 2
      Description                = Backward
      Total Work                 = 1342177280 bytes
      Completed Work             = 0 bytes
      Start Time                 = Not Started

6. 查看实例配置文件
# db2 get dbm cfg

7. 查看数据库配置参数信息
# db2 get db cfg for fcsdb

8. 查看数据库的名字	
# db2 list db directory

9. 导入/出数据库
$ db2look -d fcsdb -e -o fcsdb.sql

db2look [-h]

-d: 数据库名称：这必须指定

-e: 抽取复制数据库所需要的 DDL 文件

-xs: 导出 XSR 对象并生成包含 DDL 语句的脚本

-xdir: 路径名：将用来放置 XSR 对象的目录

-u: 创建程序标识：如果 -u 和 -a 都未指定，则将使用 $USER

-z: 模式名：如果同时指定了 -z 和 -a，则将忽略 -z

-t: 生成指定表的统计信息

-tw: 为名称与表名的模式条件（通配符）相匹配的表生成 DDL

-h: 更详细的帮助消息

-o: 将输出重定向到给定的文件名

-a: 为所有创建程序生成统计信息

-m: 在模拟方式下运行 db2look 实用程序

-c: 不要生成模拟的 COMMIT 语句

-r: 不要生成模拟的 RUNSTATS 语句

-l: 生成数据库布局：数据库分区组、缓冲池和表空间。

-x: 生成排除对象的原始定义程序的“授权”语句 DDL

-xd: 生成包括对象的原始定义程序的“授权”语句 DDL

-f: 抽取配置参数和环境变量

-td: 将 x 指定为语句定界符（缺省定界符为分号（;））

-i: 登录到数据库驻留的服务器时所使用的用户标识

-w: 登录到数据库驻留的服务器时所使用的密码

-noview: 不要生成 CREATE VIEW ddl 语句

-wrapper: 为适用于此包装器的联合对象生成 DDL

-server: 为适用于此服务器的联合对象生成 DDL

-nofed: 不要生成 Federated DDL

-fd: 为 opt_buffpage 和 opt_sortheap 以及其他配置和环境参数生成 db2fopt 语句。

-v: 只为视图生成 DDL，当指定了 -t 时将忽略此选项

-dp: 在 CREATE 语句之前生成 DROP 语句

-ct: 按对象创建时间生成 DDL 语句

$ db2move fcsdb import
$ db2move fcsdb export


创建NICKNAME
CREATE NICKNAME DB2I4NB.TBL_STL_FILE_CTL FOR FCSDBSVR.DB2I4NB.TBL_STL_FILE_CTL
grant insert on DB2I4NB.TBL_STL_FILE_CTL to user fepdb

CREATE NICKNAME DB2I4NB.TBL_STL_CARD_DTL_20180101 FOR FEPDBSVR.DB2I4NB.TBL_STL_CARD_DTL_20180101
grant select on DB2I4NB.TBL_STL_CARD_DTL_20180101 to user fcsdb

根据被读的频率来确定需要执行reorg或runstats命令的表，使用以下语句：
select substr(table_schema,1,10) as tbschema, substr(table_name,1,30) as tbname,rows_read,rows_written,overflow_accesses,page_reorgs 
from table (SNAPSHOT_TABLE(' ', -1)) as snapshot_table order by rows_read desc fetch first 10 rows only

根据被写的次数找出10张更新最频繁的表使用以下语句:
select substr(table_schema,1,10) as tbschema,substr(table_name,1,30) as tbname, rows_read, rows_written, overflow_accesses, page_reorgs
 from table (SNAPSHOT_TABLE(' ', -1)) as snapshot_table order by rows_written desc fetch first 10 rows only

db2set设置db2参数,设置后需要重启数据库然后建库才能生效
DB2_COMPATIBILITY_VECTOR=ORA
DB2_SKIPINSERTED=ON
DB2_EVALUNCOMMITTED=ON
DB2_SKIPDELETED=ON
DB2_HASH_JOIN=YES
DB2COMM=TCPIP
DB2CODEPAGE=1386
DB2_PARALLEL_IO=*
DB2AUTOSTART=YE

查询表名信息，比如所属表空间
select * from user_tables




//////////////////////////////////////////////////
db2top 查看db2用到的资源
db2 list active databases
db2 get dbm cfg
db2 get db cfg fcsdb
db2 update db cfg for fcsdb using logfilesize 25600
db2 list tablespaces show detail
db2 list pachages for all

db2 reorg table 表名
db2 runstats on table 表名 with distribution and indexes all
（db2i4nb/bin/runsall(db2提供的优化脚本））

aix - topas命令


查看表所在的表空间
 select tabname from syscat.tables where tbspace='tbs_jndb_dtl'


查询数据库实例：----------------------------------------------------------------------------
[db2i4jn@jntestykt ~]$ db2 get instance
当前数据库管理器实例是：db2i4jn

db2 list db directory：列出当前实例下的所有数据库-----------------------------------------
[db2i4jn@jntestykt ~]$ db2 list db directory
系统数据库目录
目录中的条目数 = 2

数据库 1 条目：

数据库别名                      = APPDB
数据库名称                      = APPDB
本地数据库目录                  = /home/db2i4jn
数据库发行版级别                = f.00
注释                           =
目录条目类型                    = 间接
目录数据库分区号                = 0
备用服务器主机名                =
备用服务器端口号                =

数据库 2 条目：

数据库别名                      = JNDB
数据库名称                      = JNDB
本地数据库目录                  = /home/db2i4jn/jndb
数据库发行版级别                = f.00
注释                           =
目录条目类型                    = 间接
目录数据库分区号                = 0
备用服务器主机名                =
备用服务器端口号                =


列出当前连接的数据库：---------------------------------------------------
[db2i4jn@jntestykt ~]$ db2 list active databases

                           活动数据库

数据库名称                               = APPDB
当前连接的应用程序              = 692
数据库路径                      = /home/db2i4jn/db2i4jn/NODE0000/SQL00001/MEMBER0000/

数据库名称                               = JNDB
当前连接的应用程序              = 359
数据库路径                      = /home/db2i4jn/jndb/db2i4jn/NODE0000/SQL00001/MEMBER0000/

db2 list applications：列出所有对数据库的连接-----------------------------------------------------
权标识  应用程序名    应用程序    应用程序标识                  数据库   代理程序
                        句柄                                      名称     序号
-------- -------------- ---------- -------------------------------------------------------------- -------- -----
DB2I4JN  db2jcc_applica 8085       ::ffff:192.168.124.41.56949.180409053855                       APPDB    1    
DB2I4JN  FacePayConsole 8769       *LOCAL.db2i4jn.180409072459                                    APPDB    1    
DB2I4JN  db2jcc_applica 7996       ::ffff:192.168.124.80.58413.180409052656                       APPDB    1    
DB2I4JN  db2jcc_applica 8732       ::ffff:192.168.124.41.59248.180409070957                       APPDB    1    
DB2I4JN  db2jcc_applica 8086       ::ffff:192.168.124.41.56956.180409053915                       APPDB    1    
DB2I4JN  FacePayConsole 8770       *LOCAL.db2i4jn.180409072500                                    APPDB    1    
DB2I4JN  FacePayConsole 8745       *LOCAL.db2i4jn.180409072435                                    JNDB     1    
