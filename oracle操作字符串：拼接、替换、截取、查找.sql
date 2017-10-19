1、拼接字符串

1）可以使用“||”来拼接字符串

1 select '拼接'||'字符串' as str from dual 
2）通过concat()函数实现

1 select concat('拼接', '字符串') as str from dual 
注：oracle的concat函数只支持两个参数的方法，即只能拼接两个参数，如要拼接多个参数则嵌套使用concat可实现，如：

1 select concat(concat('拼接', '多个'), '字符串') from dual 
2、截取字符串

SUBSTR(string,start_position,[length])    求子字符串，返回字符串
解释：string 源字符串
       start_position   开始位置（从0开始）
       length 可选项，子字符串的个数

1 select substr(to_char(sysdate, 'yyyy-mm-dd HH:mi:ss'), 12, 5) as time from dual 
1 substr("ABCDEFG", 0); //返回：ABCDEFG，截取所有字符 
2 substr("ABCDEFG", 2); //返回：CDEFG，截取从C开始之后所有字符 
3 substr("ABCDEFG", 0, 3); //返回：ABC，截取从A开始3个字符 
4 substr("ABCDEFG", 0, 100); //返回：ABCDEFG，100虽然超出预处理的字符串最长度，但不会影响返回结果，系统按预处理字符串最大数量返回。 
5 substr("ABCDEFG", -3); //返回：EFG，注意参数-3，为负值时表示从尾部开始算起，字符串排列位置不变。
3、查找字符串

INSTR（string,subString,position,ocurrence）查找字符串位置

解释：string：源字符串
        subString：要查找的子字符串
        position：查找的开始位置
        ocurrence：源字符串中第几次出现的子字符串

1 select INSTR('CORPORATE FLOOR','OR', 3, 2) as loc from dual 
4、替换字符串

replace(strSource, str1, str2) 将strSource中的str1替换成str2

解析：strSource:源字符串

　　   str1: 要替换的字符串

  　　 str2: 替换后的字符串

1 select '替换字符串' as oldStr, replace('替换字符串', '替换', '修改') as newStr from dual