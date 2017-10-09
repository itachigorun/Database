一、表空间概述

    表空间是Oracle中最大的逻辑存储结构，与操作系统中的数据文件相对应；

    基本表空间：一般指用户使用的永久性表空间，用于存储用户的永久性数据
    临时表空间： 主要用于存储排序或汇总过程中产生的临时数据；
    大文件表空间：用于存储大型数据（例如LOB）
    非标准数据块表空间：用于在一个数据库实例中创建数据块大小不同的表空间；
    撤销表空间：用于存储事务的撤销数据，在数据恢复时使用。

二、创建表空间
语法：
    CREATE [ TEMPORARY | UNDO ] TABLESPACE tablespace_name
    [ DATAFILE | TEMPFILE  ‘file_name‘  SIZE  size  K|M  [ REUSE ] ]
    [ AUTOEXTEND  OFF|ON
    [ NEXT number K|M MAXSIZE NULIMITED|number K|M ]
    ][,…]
    [ MININUM EXTENT number K|M ]
    [ BLOCKSIZE number K ]
    [ ONLINE|OFFLINE ]
    [ LOGGING|NOLOGGING ]
    [ FORCE LOGGING ]
    [ DEFAULT STORAGE storage ]
    [ COMPRESS|NOCOMPRESS ]
    [ PERMANENT|TEMPORARY ]
    [ EXTENT MANAGEMENT DICTIONARY | LOCAL
    [ AUTOALLOCATE|UNIFORM SIZE number K|M ] ]
    [ SEGMENT SPACE MANAGEMENT AUTO|MANUAL ];

说明：
    TEMPORARY:指定表空间为临时表空间
    UNDO:指定表空间为撤销表空间
    如果不指定TEMPORARY或UNDO:表示指定的是基本表空间
    tablespace_name:表空间的名称
    DATAFILE:指定是基本表空间时，为表空间指定数据文件
    TEMPFILE:指定是临时表空间时，为表空间指定临时文件
    REUSE：标识文件已经存在

对文件的设置:
    AUTOEXTEND ：标识文件是否自动扩展
    NEXT:标识文件下次扩展的大小
    MAXSIZE:标识文件的最大容量，UNLIMITED：标识大小不受限制
    MINIMUM EXTENT:标识盘区可以分配的最小容量
    BLOCKSIZE:标准数据块大小（只能用于标准表空间）
    ONLINE:  标识创建的表空间立即可用   OFFLINE:不能立即使用
    LOGGING: 生成日志记录项             NOLOGGING:不生成日志记录项
    FORCE LOGGING:强制日志记录项
    DEFAULT STORAGE:数据库对象默认的存储对象
    COMPRESS: 压缩数据     NOCOMPRESS:不压缩
    PERMANENT: 持久保存数据对象      TEMPORARY:临时保存数据对象
    EXTENT MANAGEMENT DICTIONARY:数据字典的管理方式为数据字典管理方式
    LOCAL:数据字典的管理方式为本地化管理方式
    AUTOALLOCATE:LOCAL管理方式时，盘区大小自动分配
    UNIFORM SIZE :LOCAL管理方式时，盘区大小均匀分配，可以指定大小
    SEGMENT SPACE MANAGEMENT :标识表空间中段的管理方式
    AUTO:自动管理
    ANUAL:人工管理

创建用户之前要创建"临时表空间"，若不创建则默认的临时表空间为temp,创建用户之前先要创建数据表空间，若没有创建则默认永久性表空间是system。

创建临时表空间
CREATE TEMPORARY TABLESPACE TBS_FCS_TEMP  TEMPFILE '/oradata/testdb/TBS_FCS_TEMP_01.dbf' size 1G  AUTOEXTEND ON  NEXT 10M  MAXSIZE  20G  EXTENT MANAGEMENT LOCAL;    

创建基本表空间
CREATE TABLESPACE TBS_FCS_DTL  DATAFILE '/oradata/testdb/TBS_FCS_DTL_01.dbf' size 2G  AUTOEXTEND ON  NEXT 10M  MAXSIZE UNLIMITED  LOGGING   ONLINE   PERMANENT   BLOCKSIZE 8K    EXTENT MANAGEMENT LOCAL AUTOALLOCATE   DEFAULT NOCOMPRESS    SEGMENT SPACE MANAGEMENT AUTO;    

三、表空间状态设置
表空间的状态属性主要有:在线（ONLINE）、离线（OFFLINE）、只读（READ ONLY）和读写（READ WRITE）这4种。
通过设置表空间的状态属性，可以对表空间的使用进行管理。

1、在线
      当表空间的状态为ONLINE时，才允许访问该表空间中的数据
例如：
      修改表空间的状态为ONLINE
      ALTER TABLESPACE tablespace_name ONLINE;

2、离线
      OFFLINE状态，不允许访问该表空间中的数据。这时可以对表空间进行脱机备份，也可以对应用程序进行升级和维护等。
例如：
      将表空间状态修改为离线状态
      ALTER TABLESPACE tablespace_name OFFLINE parameter;
说明：
      parameter表示将表空间切换为OFFLINE状态可以使用的参数：
      NORMAL:  正常方式切换，默认方式
      TEMPORARY:临时方式，Oracle在检查时不会检查数据文件是否可用
      IMMEDIATE:立即方式，Oracle不会执行检查点
      FOR RECOVER:以恢复方式，常用于基于时间恢复数据库

3、只读
      只能读取数据，不能进行任何更新或删除操作，目的是为了保证表空间的数据安全
例如：
      将表空间设置为READ ONLY
      ALTER TABLESPACE tablespace_name READ ONLY;
说明：
      将表空间设置为READ ONLY之前的注意事项：
      — 表空间必须处于ONLINE状态
      — 表空间不能包含任何事务的回退段
      — 表空间不能正处于在线数据库备份期间

4、读写
      可以对表空间进行正常访问
例如：
      修改表空间为READ WRITE状态
      ALTER TABLESPACE tablespace_name READ WRITE；
注意：
      修改表空间的状态为READ WRITE，也需要保证表空间处于ONLINE状态。

      查看表空间的状态
      select tablespace_name, status from dba_tablespaces;

四、修改表空间

1.修改表空间文件大小
alter database datafile '/oracledata/testdb/TBS_FCS_DATA_01.dbf' resize 1024M;

2.表空间、临时表空间文件自动扩展修改
alter database tempfile '/oracledata/testdb/TBS_FCS_DATA_01.dbf' AUTOEXTEND off;
alter database datafile '/oracledata/testdb/TBS_FCS_DATA_01.dbf' AUTOEXTEND off;
alter database datafile '/oracledata/testdb/TBS_FCS_DATA_01.dbf' AUTOEXTEND ON NEXT 10M MAXSIZE 1024M;

3.增加表空间文件，oracle增加表空间文件不会rebalance，DB2增加表空间文件会rebalance
ALTER TABLESPACE TBS_FEP_DATA ADD DATAFILE '/oradata01/qdaccdb/TBS_FEP_DATA_06.dbf' SIZE 100M AUTOEXTEND ON NEXT 10M MAXSIZE 20480M;

4.重命名表空间
修改表空间的名称，不会影响到表空间中的数据，但不能修改系统表空间system与sysaux的名称。
语法：
   ALTER TABLESPACE tablespace_name RENAME TO new_tablespace_name;
注意：如果表空间的状态为OFFLINE,则无法重命名该表空间。

5.删除表空间
SQL> drop tablespace TBS_FCS_SUM including contents and datafiles;
SQL> DROP TABLESPACE TBS_FCS_SUM INCLUDING CONTENTS AND DATAFILES CASCADE CONSTRAINTS;(有外键等约束)
说明：
INCLUDING CONTENTS: 表示删除表空间的同时，删除表空间中的所有数据库对象。如果表空间中有数据库对象，则必须使用此选项。
AND DATAFILES：表示删除表空间的同时，删除表空间所对应的数据文件。如果不使用此选项，则删除表空间实际上仅是从数据字典和控制文件中将该表空间的有关信息删除，而不会删除操作系统中与该表空间对应的数据文件。

6.修改表空间中数据文件的状态
数据文件主要有3种状态：ONLINE、OFFLINE和OFFLINE DROP。
ONLINE:表示联机状态，此时数据文件可以使用
OFFLINE:表示脱机状态，此时数据文件不可使用，用于数据库运行在归档模式下的情况
OFFLINE DROP:会删除数据文件，与OFFLINE一样用于设置数据文件不可用，但他用于数据库运行在非归档模式下的情况。
注：
将数据文件设置为OFFLINE状态时，不会影响到表空间的状态；但是将表空间设置为OFFLINE状态时，属于该表空间的所有数据文件都被设置为OFFLINE状态。
语法：
ALTER DATABASE
DATAFILE file_name ONLINE|OFFLINE|OFFLINE DROP
例子：
ALTER DATABASE DATAFILE ‘E:/APP/MYSPACE/MYSPACE02.DBF‘ OFFLINE;

7.移动表空间中的数据文件
数据文件的大小受所在磁盘空间大小的限制，当数据文件所在的磁盘空间不够时，需要将数据文件移动到新的磁盘中保存。
方法：
   第一步：将相应的表空间设置为离线状态
   第二步：进入磁盘，移动数据文件到新的位置，也可以修改文件名
   第三步：重命名数据文件
例如：ALTER TABLESPACE myspace
      RENAME DATAFILE ‘E:/APP/MYSPACE/MYSPACE02.DBF‘
      TO ‘D:/ORACLEFILE/MYSPACE03.DBF‘
   第四步：将相应的表空间设置为在线状态

8、临时表空间
创建和修改临时表空间:
    临时表空间是一个磁盘空间，主要用于存储用户在执行ORDER BY等语句进行排序或汇总时产生的临时数据。默认情况下，所有用户都使用temp作为默认临时表空间。但是也允许使用其他临时表空间作为默认临时表空间，这需要在创建用户时指定
    创建临时表空间时需要使用TEMPORARY关键字，并且与临时表空间对应的是临时文件，由TEMPFILE关键字指定，也就是说临时表空间中不再使用数据文件，而使用临时文件。

例子：
    CREATE TEMPORARY TABLESPACE mytemp
    TEMPFILE ‘E:/app/myspace/mytemp.dbf‘
    SIZE 5M AUTOEXTEND ON NEXT 2M MAXSIZE 20M;

修改临时表空间:
    由于临时文件中不存储永久性数据，只存储排序等操作过程中产生的临时数据，并且在用户操作结束后，临时文件中存储的数据由系统删除，所以一般情况下不需要调整临时表空间，但是当并发用户特别多，并且操作比价复杂时，可能会发生临时表空间不足。这时，数据库管理员可以增加临时文件来增大临时表空间。
    如果需要增加临时文件，可以使用ADD TEMPFILE子句。
    如果需要修改临时文件的大小，可以使用RESIZE关键字。
    还可以修改临时文件的状态为OFFLINE或ONLINE。

临时表空间组:
    是指对多个临时表空间组成的集合，针对集合操作
    在Oracle 11g中，用户可以创建临时表空间组，一个临时表空间组中可以包含一个或多个临时表空间。
临时表空间组主要特征如下:
** 一个临时表空间组必须由至少一个临时表空间组成，并且无明确地最大数量限制。
** 如果删除一个临时表空间组的所有成员，该组也自动被删除。
** 临时表空间的名字不能与临时表空间组的名字相同。
** 在给用户分配一个临时表空间时可以使用临时表空间组的名字代替实际的临时表空间名；在给数据库分配默认临时表空间时，也可以使用临时表空间组的名字。

使用临时表空间组的优点：
** 由于SQL查询可以并发使用几个临时表空间进行排序操作，因此SQL查询很少会出现排序空间超出，避免临时表空间不足所引起的磁盘排序问题。
** 可以在数据库级指定多个默认临时表空间。
** 一个并行操作的并行服务器将有效地利用多个临时表空间
** 一个用户在不同会话中可以同时使用多个临时表空间。

操作临时表空间组
(1)、创建临时表空间组
只需要在创建临时表空间时，使用TABLESPACE GROUP语句为其制定一个组即可。
例子：
    CREATE TEMPORARY TABLESPACE tempgroup
TEMPFILE ‘E:/app/myspace/tempgroup01.dbf‘ SIZE 5M
TABLESPACE GROUP group01;

(2)、查看临时表空间组信息
数据字典dba_tablespace_groups
例子：
select * from dba_tablespace_groups;

(3)、移动临时表空间
使用ALTER TABLESPACE 语句
例子：
ALTER TABLESPACE tempgroup TABLESPACE GROUP group02;

(4)、删除临时表空间组

9.大文件表空间
大文件表空间:
大文件表空间是Oracle 10g引入的一个新表空间类型，主要用于解决存储文件大小不够的问题。与普通表空间不同的是，大文件表空间只能对应唯一一个数据文件或临时文件，而普通表空间则可以最多对应1022个数据文件或临时文件。
    虽然大文件表空间只能对应一个数据文件或临时文件，但其对应的文件可达4G个数据块大小。而普通表空间对应的文件最大可达4M个数据块大小。

创建大文件表空间:
使用BIGFILE关键字，而且只能为其制定一个数据文件或临时文件
   普通表空间一般使用SMALLFILE关键字表示，默认省略。
通过数据字典database_properties可以了解当前数据库默认的表空间类型。

例如：
CREATE BIGFILE TABLESPACE mybigspace
DATAFILE ‘E:/app/myspace/bigspace.dbf‘
SIZE 10M;

查看表空间是否是大文件表空间:
select tablespace_name, bigfile from dba_tablespaces;

查看当前数据库默认的表空间类型:
select property_name, property_value, description
from database_properties
where property_name = ‘DEFAULT_TBS_TYPE‘;

10、非标准数据块表空间
非标准数据块表空间:
非标准（数据块）表空间，是指其数据块大小不基于标准数据块大小的表空间。
    在创建表空间时，可以使用BLOCKSIZE子句，该子句用来另外设置表空间中的数据块大小，如果不指定该子句，则默认的数据块大小由系统初始化参数db_block_size决定。db_block_size参数指定的数据块大小即标准数据块大小，在数据库创建之后无法再修改该参数的值。

创建非标准数据块表空间：
    Oracle 11g中允许用户创建非标准数据块表空间，使用BLOCKSIZE子句指定表空间中数据块的大小，但是必须有数据缓冲区参数db_nk_cache_size的值与BLOCKSIZE参数的值相匹配，如下：
BLOCKSIZE        db_nk_cache_size
2KB              db_2k_cache_size
4KB              db_4k_cache_size
8KB              db_8k_cache_size
16KB             db_16k_cache_size
32KB             db_32k_cache_size

查看表空间的数据块大小：
select tablespace_name, block_size from dba_tablespaces;

创建撤销表空间
例子：
第一步，修改 db_nk_cache_size参数
ALTER SYSTEM SET DB_16K_CACHE_SIZE = 16M;

第二步，创建非标准表空间
CREATE TABLESPACE blockspace
DATAFILE ‘E:/app/myspace/blockspace.dbf‘ SIZE 10M
AUTOEXTEND ON NEXT 5M
BLOCKSIZE 16K;
注意：
    BLOCKSIZE的值与db_nk_cache_size的参数值要对应。

11、撤销表空间
撤销表空间：
为了实现对数据回退、恢复、事务回滚以及撤销等操作，Oracle数据库提供了一部分存储空间，专门保存撤销记录，将修改前的数据保存到该空间中，所以这部分空间被称为撤销表空间。多个撤销表空间可以存在于一个数据库中，但是在任何给定的时间内只有一个撤销表空间是可以获得的。

创建撤销表空间
例如：
   create undo tablespace undotbs
   datafile ‘e:/app/myspace/undo01.dbf‘ size 20m
   autoextend on;

修改撤销表空间的数据文件
添加新的数据文件
alter tablespace undotbs
add datafile ‘e:/app/muspace/undo02.dbf‘ size 10m

修改撤销表空间的数据文件大小:
alter database datafile ‘e:/app/myspace/undo02.dbf‘ resize 15m;

设置撤销表空间的数据文件的状态为ONLINE或OFFLINE:
alter tablespace undotbs offline;

操作撤销表空间:
一个数据库中可以有多个撤销表空间，但数据库一次只能使用一个撤销表空间。默认情况下，数据库使用的是系统自动创建的undotbs1撤销表空间。如果将数据库使用的撤销表空间切换成其他表空间，使用ALTER SYSTEM语句修改参数undo_tablespace 的值即可。切换撤销表空间后，数据库中新事务的撤销数据将保存在新的撤销表空间中。

切换表空间:
alter system set undo_tablespace = undoetbs02;

在自动撤销记录管理方式中，可以指定撤销信息在提交之后需要保留的时间，以防止在长时间的查询过程中出现snapshot too old错误。
   在自动撤销管理方式下，DBA使用UNDO_RESTENTION参数，指定撤销记录的表刘时间。由于UNDO_RETENTION参数是一个动态参数，在Oracle实例的运行中，可以通过ALTER SYSTEM SET UNDO_RETENTION语句，来修改撤销记录保留的时间。
   撤销记录保留时间的单位是秒，默认值为900,即15分钟。
   例如，将撤销记录的保留时间修改为10分钟，如下：
alter system set undo_retention = 600;
show parameter undo;

删除撤销表空间:
删除撤销表空间之前，需要保证该撤销表空间不是系统正在使用的表空间。

例如：
drop tablespace undotbs02 including contents and datafiles;

设置默认表空间:
    在Oracle中，用户的默认永久性表空间为system，默认临时表空间为temp。如果所有用户都使用默认的表空间，无疑会增加system与temp表空间的竞争性。
    Oracle允许使用自定义的表空间作为默认永久性表空间，使用自定义临时表空间作为默认临时表空间。

语法：
    ALTER DATABASE DEFAULT [TEMPORARY] TABLESPACE tablespace_name;

说明：
    使用TEMPORARY关键字，则表示设置默认临时表空间；如果不使用该关键字，则表示设置默认永久性表空间。

查询默认表空间:
select default_tablespace from user_users;

select property_name, property_value
from database_properties 
where property_name IN (‘DEFAULT_PERMANENT_TABLESPACE‘, ‘DEFAULT_TEMP_TABLESPACE‘);

创建日志文件
创建日志文件组
语法：
ALTER DATAFILE database_name
ADD LOGFILE [GROUP group_number]
(file_name [,file_name[,…]])
[SIZE size] [REUSE];

说明：
*GROUP group_number:为日志文件组指定组编号
*file_name :为该组创建日志文件成员
*SIZE number:指定日志文件成员的大小
*REUSE :如果创建的日志文件成员已存在，可以使用REUSE关键字覆盖已存在的文件。但是该文件不能已经属于其他日志文件组。否则无法替换。

创建日志文件
一般是指向日志文件组中添加日志成员，需要使用ALTER DATABASE … ADD LOGFILE MEMBER语句

例如：
alter database add logfile member
‘f:/oraclefile/logfile/redo03.log‘
to group 4;

查看日志文件信息
select group#, member from v$logfile;

创建日志文件
alter database add logfile group 4
(
   ‘E:/app/myspace/redo01.log‘,
   ‘E:/app/myspace/redo02.log‘
) SIZE 10M;



********************************表空间解析******************************************
数据库最多可以有65535（64K）个表空间文件（分为smallfile、bigfile文件），一个smallfile的表空间最多可以有1023个数据文件，
Oracle中每个small file数据文件最多只能包含2的22次方 - 1 个数据块，所以数据库最大为8KB*(2^22-1)=32GB-8KB
bigfile表空间只能有一个文件，最大可为32T，DB_BLOCK_SIZE决定。

1、64位linux 和64位oracle，默认oracle表空间数据文件用的BLOCKSIZE是8k，表空间数据文件最大是32G。
SQL>show parameter k_cache_size
查看数据库默认的块大小
SQL> show parameter db_block_size
db_block_size                        integer     8192
2、为了让一个表空间数据文件存64G，你需要告诉oracle用BLOCKSIZE 是16k
CREATE TABLESPACE TEST DATAFILE ‘/data1/test_ts1.dbf’ SIZE 512M AUTOEXTEND ON NEXT 256M MAXSIZE UNLIMITED BLOCKSIZE 16k;
提前需要设置db_16k_cache_size
alter system set db_16k_cache_size=16M scope=both;
否则会报错ORA-29339:
tablespace block size 16384 does not match configured block sizes

在64位系统中，Oracle数据库的存储能力被扩展到了8 EB（1EB =1024PB，1PB = 1024TB，1TB=1024GB）。

大文件表空间
在Oracle中用户可以创建大文件表空间（bigfile tablespace）。这样Oracle数据库使用的表空间（tablespace）可以由一个单一的大文件构成，
而不是若干个小数据文件。这使Oracle可以发挥64位系统的能力，创建、管理超大的文件。在64位系统中，Oracle数据库的存储能力被扩展到了8 EB（1EB =1024PB，1PB = 1024TB，1TB=1024GB）。
当数据库文件由Oracle管理（Oracle-managed files），且使用大文件表空间（bigfile tablespace）时，数据文件对用户完全透明。换句话说，用户只须针对表空间（tablespace）执行管理操作，
而无须关心处于底层的数据文件 （datafile）。使用大文件表空间，使表空间成为磁盘空间管理，备份，和恢复等操作的主要对象。使用大文件表空间，并与由Oracle管理数据库文件（Oracle-managed files）技术以及自动存储管理（Automatic Storage  Management）技术相结合，
就不再需要管理员手工创建新的数据文件（datafile）并维护众多数据库文件，因此简化了数据库文件管理工作。数据库默认创建的是小文件表空间（smallfile tablespace），即Oracle中传统的表空间（tablespace）类型。
数据库中 SYSTEM 和 SYSAUX 表空间在创建时总是使用传统类型只有本地管理的（locally managed），且段空间自动管理（automatic segmentspace  management）的表空间（tablespace）才能使用大文件表空间（bigfile tablespace）。 
但是有两个例外：本地管理的撤销表空间（undo tablespace）和临时表空间（temporary tablespace），即使其段（segment）为手工管理（manually managed），也可以使用大文件表空间。
一个Oracle数据库可以同时包含大文件/小文件表空间（bigfile/smallfile   tablespace）。SQL语句执行时无需考虑表空间（tablespace）的类型，除非语句中显式地引用了数据文件（datafile）名。
管理员可以创建一组临时表空间（temporary tablespace），用户在需要时可以利用组内各个表空间（tablespace）提供的临时空间。管理员还可以指定表空间组（tablespace group）为数据库默认的临时表空间。
当用户需要大量临时空间进行排序操作时，就可以利用大文件表空间及表空间组。

使用大文件表空间的优势
● 使用大文件表空间（bigfile tablespace）可以显著地增强Oracle数据库的存储能力。一个小文件表空间（smallfile tablespace）最多可以包含1024个数据文件（datafile），而 一个大文件表空间中只包含一个文件，这个数据文件的最大容量是小数据文件的1024倍。
这样看来，大文件表空间和小文件表空间的最大容量是相同的。但是由 于每个数据库最多使用64K个数据文件，因此使用大文件表空间时数据库中表空间的极限个数是使用小文件表空间时的1024倍，使用大文件表空间时的总数据 库容量比使用小文件表空间时高出三个数量级。
换言之，当一个Oracle数据库使用大文件表空间，且使用最大的数据块容量时（32K），其总容量可以达到 8EB。
● 在超大型数据库中使用大文件表空间减少了数据文件的数量，因此也简化了对数据文件的管理工作。由于数据文件的减少，SGA中关于数据文件的信息，以及控制文件（control file）的容量也得以减小。
● 由于数据文件对用户透明，由此简化了数据库管理工作。

使用大文件表空间时需要考虑的因素
● 大文件表空间（bigfile tablespace）应该和自动存储管理（Automatic  Storage Management）或其他逻辑卷管理工具（logical volume manager）配合使用，这些工具应该能够支持动态扩展逻辑卷，也能支持striping（数据跨磁盘分布）或RAID。
● 应该避免在不支持striping的系统上使用大文件表空间，因为这将不利于并行执行（parallel execution）及 RMAN 的并行备份（backup parallelization）。
● 当表空间正在使用的磁盘组（disk group）可能没有足够的空间，且扩展表空间的唯一办法是向另一个磁盘组加入数据文件时，应避免使用大文件表空间。
● 不建议在不支持大文件的平台上使用大文件表空间，这会限制表空间（tablespace）的容量。参考相关的操作系统文档了解其支持的最大文件容量。
● 如果使用大文件表空间替代传统的表空间，数据库开启（open），checkpoints，以及 DBWR 进程的性能会得到提高。但是增大数据文件（datafile）容量可能会增加备份与恢复的时间。
