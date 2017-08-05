修改字段名
alter table 表名 rename column 旧字段名 to 新字段名;
修改字段类型和长度
alter table 表名 modify 字段名 数据类型;
增加一个字段
alter table 表名 add 字段名 数据类型;
删除一个字段
alter table 表名 drop column 字段名;

总结：
1、当字段没有数据或者要修改的新类型和原类型兼容时，可以直接modify修改。
2、当字段有数据并用要修改的新类型和原类型不兼容时，要间接新建字段来转移。


updata tablename set column=xxx  where column=xxx;

-查看实例名
select instance_number,instance_name,host_namefrom v$instance;
--查看RAC监听配置
select name,value,display_value from v$parameter where name in('remote_listener','local_listener');
--查看内存SGA,PGA分配情况
select * from v$sgastat;
select * from v$pgastat;
--查看查看是否归档，创建时间及平台类型
select dbid,name,db_unique_name,created,log_mode,platform_name from v$database;
--dblink查看
select * from dba_db_links;



oracle查询版本
方法一：sqlplus / as sysdba(sqlplus user/password@ssid)

方法二：SQL> select * from v$version; 

方法三：SQL> select * from product_component_version;

方法四：SQL>select vesion from v$instance;



查看oracle数据库的SID:
select instance_name from v$instance;

查看oracle所在服务器的ip:
select utl_inaddr.get_host_address from dual;

查询用户 CPU 的使用率 
这个语句是用来显示每个用户的 CPU 使用率，有助于用户理解数据库负载情况

SELECT ss.username, se.SID, VALUE / 100 cpu_usage_seconds
    FROM v$session ss, v$sesstat se, v$statname sn
   WHERE     se.STATISTIC# = sn.STATISTIC#
         AND NAME LIKE '%CPU used by this session%'
         AND se.SID = ss.SID
         AND ss.status = 'ACTIVE'
         AND ss.username IS NOT NULL
ORDER BY VALUE DESC;



查询数据库长查询进展情况

显示运行中的长查询的进展情况

SELECT a.sid,
         a.serial#,
         b.username,
         opname OPERATION,
         target OBJECT,
         TRUNC (elapsed_seconds, 5) "ET (s)",
         TO_CHAR (start_time, 'HH24:MI:SS') start_time,
         ROUND ( (sofar / totalwork) * 100, 2) "COMPLETE (%)"
    FROM v$session_longops a, v$session b
   WHERE     a.sid = b.sid
         AND b.username NOT IN ('SYS', 'SYSTEM')
         AND totalwork > 0
ORDER BY elapsed_seconds;



获取当前会话 ID，进程 ID，客户端 ID 等

这个专门提供给想使用进程 ID 和 会话 ID 做些 voodoo magic 的用户。

SELECT b.sid,
       b.serial#,
       a.spid processid,
       b.process clientpid
  FROM v$process a, v$session b
 WHERE a.addr = b.paddr AND b.audsid = USERENV ('sessionid');
V$SESSION.SID AND V$SESSION.SERIAL# 是数据库进程 ID

V$PROCESS.SPID 是数据库服务器后台进程 ID

V$SESSION.PROCESS 是客户端 PROCESS ID, ON windows it IS : separated THE FIRST # IS THE PROCESS ID ON THE client AND 2nd one IS THE THREAD id.