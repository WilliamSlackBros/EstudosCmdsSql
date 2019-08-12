select * from dbamv.atendime;
select * from VW_INCONSIST_CIH;
select * from VDIC_ATENDIMENTO_SANTA_TESTE;
select * from VDIC_ATENDIMENTO;
select * from PW_REGISTRO_ALTA;
select * from ATENDIME_KBP_AGOSTO;
SELECT
TABLE_NAME,
COLUMN_NAME
FROM
ALL_TAB_COLUMNS
WHERE
--TABLE_NAME LIKE '%TPA%' AND
COLUMN_NAME LIKE '%CD_SSM_CIH%'
/*
SELECT 
     T.name AS Tabela, 
     C.name AS Coluna
FROM 
    -- sys.sysobjects AS T (NOLOCK)
    SYS.sys_objects  T --(NOLOCK)
--INNER JOIN sys.all_columns AS C (NOLOCK) ON T.id = C.object_id AND T.XTYPE = 'U' 
WHERE 
     C.NAME LIKE '%CD_SSM_CIH%' 
--ORDER BY 
     --T.name ASC
     */