select 
1 as Select_Principal_1
,2 as campos_no_select_principal
,select_secundario --deixando campo do select secundario
,select_ternario
from 
(

    select 3 as select_secundario , select_ternario from  
    (select distinct 4 as select_ternario from dual)
    dual
    
    --Errado
   --select 3 as select_secundario from   dual
   --,select distinct 4 as select_ternario from dual
)
dual;