表空间创建建议：初始1G，自动扩增1G，最大扩增到20G
查询表空间时候，文件10G,使用9G，可扩展到20G，这时候查询文件使用率是45%，查询表空间使用率是90%。

--查询表空间使用情况
SELECT Upper(F.TABLESPACE_NAME)         "表空间名",
       D.TOT_GROOTTE_MB                 "表空间大小(M)",
       D.TOT_GROOTTE_MB - F.TOTAL_BYTES "已使用空间(M)",
       To_char(Round(( D.TOT_GROOTTE_MB - F.TOTAL_BYTES ) / D.TOT_GROOTTE_MB * 100, 2), '990.99')
       || '%'                           "使用比",
       F.TOTAL_BYTES                    "空闲空间(M)",
       F.MAX_BYTES                      "最大块(M)"
FROM   (SELECT TABLESPACE_NAME,
               Round(Sum(BYTES) / ( 1024 * 1024 ), 2) TOTAL_BYTES,
               Round(Max(BYTES) / ( 1024 * 1024 ), 2) MAX_BYTES
        FROM   SYS.DBA_FREE_SPACE
        GROUP  BY TABLESPACE_NAME) F,
       (SELECT DD.TABLESPACE_NAME,
               Round(Sum(DD.BYTES) / ( 1024 * 1024 ), 2) TOT_GROOTTE_MB
        FROM   SYS.DBA_DATA_FILES DD
        GROUP  BY DD.TABLESPACE_NAME) D
WHERE  D.TABLESPACE_NAME = F.TABLESPACE_NAME
ORDER  BY 1;

--查询表空间的free space
select tablespace_name, count(*) AS extends,round(sum(bytes) / 1024 / 1024, 2) AS MB,sum(blocks) AS blocks from dba_free_space group BY tablespace_name;

--查询表空间的总容量
select tablespace_name, sum(bytes) / 1024 / 1024 as MB from dba_data_files group by tablespace_name;

--查询表空间使用率
SELECT total.tablespace_name,
       Round(total.MB, 2)           AS Total_MB,
       Round(total.MB - free.MB, 2) AS Used_MB,
       Round(( 1 - free.MB / total.MB ) * 100, 2)
       || '%'                       AS Used_Pct
FROM   (SELECT tablespace_name,
               Sum(bytes) / 1024 / 1024 AS MB
        FROM   dba_free_space
        GROUP  BY tablespace_name) free,
       (SELECT tablespace_name,
               Sum(bytes) / 1024 / 1024 AS MB
        FROM   dba_data_files
        GROUP  BY tablespace_name) total
WHERE  free.tablespace_name = total.tablespace_name;





SELECT a.tablespace_name                        "表空间名",
       total                                    "表空间大小",
       free                                     "表空间剩余大小",
       ( total - free )                         "表空间使用大小",
       Round(( total - free ) / total, 4) * 100 "使用率   %"
FROM   (SELECT tablespace_name,
               Sum(bytes) free
        FROM   DBA_FREE_SPACE
        GROUP  BY tablespace_name) a,
       (SELECT tablespace_name,
               Sum(bytes) total
        FROM   DBA_DATA_FILES
        GROUP  BY tablespace_name) b
WHERE  a.tablespace_name = b.tablespace_name;




SELECT TABLESPACE_NAME "TABLESPACE_NAME",
       To_char(Round(BYTES / 1024, 2), '99990.00')
       || ''           "TOTAL ",
       To_char(Round(FREE / 1024, 2), '99990.00')
       || 'G'          "FREE ",
       To_char(Round(( BYTES - FREE ) / 1024, 2), '99990.00')
       || 'G'          "USED ",
       To_char(Round(10000 * USED / BYTES) / 100, '99990.00')
       || '%'          "% USED"
FROM   (SELECT A.TABLESPACE_NAME                             TABLESPACE_NAME,
               Floor(A.BYTES / ( 1024 * 1024 ))              BYTES,
               Floor(B.FREE / ( 1024 * 1024 ))               FREE,
               Floor(( A.BYTES - B.FREE ) / ( 1024 * 1024 )) USED
        FROM   (SELECT TABLESPACE_NAME TABLESPACE_NAME,
                       Sum(BYTES)      BYTES
                FROM   DBA_DATA_FILES
                GROUP  BY TABLESPACE_NAME) A,
               (SELECT TABLESPACE_NAME TABLESPACE_NAME,
                       Sum(BYTES)      FREE
                FROM   DBA_FREE_SPACE
                GROUP  BY TABLESPACE_NAME) B
        WHERE  A.TABLESPACE_NAME = B.TABLESPACE_NAME)
--WHERE TABLESPACE_NAME LIKE 'CDR%' --这一句用于指定表空间名称
ORDER  BY Floor(10000 * USED / BYTES) DESC;




select tablespace_name,
       max_gb,
       used_gb,
       round(100 * used_gb / max_gb) pct_used
  from (select a.tablespace_name tablespace_name,
               round((a.bytes_alloc - nvl(b.bytes_free, 0)) / power(2, 30),
                     2) used_gb,
               round(a.maxbytes / power(2, 30), 2) max_gb
          from (select f.tablespace_name,
                       sum(f.bytes) bytes_alloc,
                       sum(decode(f.autoextensible,
                                  'YES',
                                  f.maxbytes,
                                  'NO',
                                  f.bytes)) maxbytes
                  from dba_data_files f
                 group by tablespace_name) a,
               (select f.tablespace_name, sum(f.bytes) bytes_free
                  from dba_free_space f
                 group by tablespace_name) b
         where a.tablespace_name = b.tablespace_name(+)
        union all
        select h.tablespace_name tablespace_name,
               round(sum(nvl(p.bytes_used, 0)) / power(2, 30), 2) used_gb,
               round(sum(decode(f.autoextensible,
                                'YES',
                                f.maxbytes,
                                'NO',
                                f.bytes)) / power(2, 30),
                     2) max_gb
          from v$temp_space_header h, v$temp_extent_pool p, dba_temp_files f
         where p.file_id(+) = h.file_id
           and p.tablespace_name(+) = h.tablespace_name
           and f.file_id = h.file_id
           and f.tablespace_name = h.tablespace_name
         group by h.tablespace_name)
order by 4;


Oracle 查询单表占用空间
SELECT segment_name AS TABLENAME,
       BYTES B,
       BYTES / 1024 KB,
       BYTES / 1024 / 1024 MB
  FROM user_segments
where segment_name = upper('tablename');


select sum("已使用容量(MB)") as "数据库容量(MB)" from (select a.tablespace_name,a.bytes/1024/1024 "总容量(MB)",(a.bytes-b.bytes)/1024/1024 "已使用容量(MB)",b.bytes/1024/1024 "剩余容量(MB)",
   round(((a.bytes-b.bytes)/a.bytes)*100,2) "使用百分比"
   from
   (select tablespace_name,sum(bytes) bytes from dba_data_files group by tablespace_name) a,
   (select tablespace_name,sum(bytes) bytes,max(bytes) largest from dba_free_space group by tablespace_name) b
   where a.tablespace_name=b.tablespace_name
   order by ((a.bytes-b.bytes)/a.bytes) desc
  );

 select a.tablespace_name,a.bytes/1024/1024 "总容量(MB)",(a.bytes-b.bytes)/1024/1024 "已使用容量(MB)",b.bytes/1024/1024 "剩余容量(MB)",
    round(((a.bytes-b.bytes)/a.bytes)*100,2) "使用百分比"
    from
    (select tablespace_name,sum(bytes) bytes from dba_data_files group by tablespace_name) a,
    (select tablespace_name,sum(bytes) bytes,max(bytes) largest from dba_free_space group by tablespace_name) b
    where a.tablespace_name=b.tablespace_name
    order by ((a.bytes-b.bytes)/a.bytes) desc;