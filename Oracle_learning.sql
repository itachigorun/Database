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

