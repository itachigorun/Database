1. DB2查询表空间使用率
select current timestamp, substr(TBSP_NAME,1,20) as TBSP_NAME, tbsp_type||''||case TBSP_AUTO_RESIZE_ENABLED
 when 1 then 'AUTO' ELSE '' END as TBSP_TYPE, TBSP_TOTAL_SIZE_KB, TBSP_USED_SIZE_KB, TBSP_UTILIZATION_PERCENT 
 from sysibmadm.TBSP_UTILIZATION order by 6 desc,1