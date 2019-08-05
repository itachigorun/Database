1. DB2查询表空间使用率
select current timestamp, substr(TBSP_NAME,1,20) as TBSP_NAME, tbsp_type||''||case TBSP_AUTO_RESIZE_ENABLED
 when 1 then 'AUTO' ELSE '' END as TBSP_TYPE, TBSP_TOTAL_SIZE_KB, TBSP_USED_SIZE_KB, TBSP_UTILIZATION_PERCENT 
 from sysibmadm.TBSP_UTILIZATION order by 6 desc,1



select substr(tbsp_name,1,20) as TABLESPACE_NAME,substr(tbsp_content_type,1,10) as TABLESPACE_TYPE,
sum(tbsp_total_size_kb)/1024 as TOTAL_MB,sum(tbsp_used_size_kb)/1024 as USED_MB,sum(tbsp_free_size_kb)/1024 
as FREE_MB,tbsp_page_size AS PAGE_SIZE from SYSIBMADM.TBSP_UTILIZATION group by tbsp_name,tbsp_content_type,
tbsp_page_size  order by 1


查询表空间有什么表
SELECT TABNAME FROM SYSCAT.TABLES WHERE TBSPACE='TBS_FCS_DTL' 
查询表属于哪个表空间
select tbspace, index_tbspace from syscat.tables where tabname='TABLE_TEST_1';