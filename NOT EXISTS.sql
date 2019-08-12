SELECT 
"CD_ATENDIMENTO","CD_SSM_CIH","CD_CID","CD_MOT_ALT","CD_PRO_INT_PROCEDIMENTO_ENTRAD","CD_CONVENIO","CD_PACIENTE",
"DS_ENDERECO","NR_ENDERECO","NR_CEP","CD_CIDADE","CD_IBGE","CD_UF","DT_NASCIMENTO","TP_SEXO","NM_CIDADE","DT_ALTA",
"CD_MULTI_EMPRESA", "CD_UNID_INT", "CD_LEITO" , "DT_ATENDIMENTO"
FROM 
             (SELECT ATENDIME.CD_ATENDIMENTO 
                    ,ATENDIME.CD_SSM_CIH 
                    ,ATENDIME.CD_CID 
                    ,ATENDIME.CD_MOT_ALT 
                    ,ATENDIME.CD_PRO_INT_PROCEDIMENTO_ENTRAD 
                    ,ATENDIME.CD_CONVENIO 
                    ,PACIENTE.CD_PACIENTE 
                    ,PACIENTE.DS_ENDERECO 
                    ,PACIENTE.NR_ENDERECO 
                    ,PACIENTE.NR_CEP 
                    ,PACIENTE.CD_CIDADE 
                    ,CIDADE.CD_IBGE 
                    ,CIDADE.CD_UF 
                    ,PACIENTE.DT_NASCIMENTO 
                    ,PACIENTE.TP_SEXO 
                    ,CIDADE.NM_CIDADE
                    ,ATENDIME.DT_ALTA
                    ,ATENDIME.CD_MULTI_EMPRESA                    
                    ,UNID_INT.CD_UNID_INT
                    ,LEITO.CD_LEITO
                    ,ATENDIME.DT_ATENDIMENTO
              FROM   DBAMV.ATENDIME 
                    ,DBAMV.CONVENIO 
                    ,DBAMV.CID 
                    ,DBAMV.MOT_ALT 
                    ,DBAMV.PACIENTE 
                    ,DBAMV.CIDADE
                    ,DBAMV.UNID_INT
                    ,DBAMV.LEITO
		    ,DBAMV.EMPRESA_CONVENIO
             WHERE
             dbamv.atendime.cd_atendimento in(2482409)
             and ATENDIME.TP_ATENDIMENTO IN ( 'I','H' )
             and atendime.cd_multi_empresa = dbamv.Pkg_Mv2000.Le_Empresa
             and convenio.cd_convenio = empresa_convenio.cd_convenio /* pda 118607/129023*/
	     and empresa_convenio.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa /* pda 118607/129023*/
	     AND    ATENDIME.CD_ATENDIMENTO_PAI IS NULL 
             AND    ATENDIME.CD_PACIENTE = PACIENTE.CD_PACIENTE 
             AND    ATENDIME.CD_CONVENIO = CONVENIO.CD_CONVENIO 
             AND    UNID_INT.CD_UNID_INT = LEITO.CD_UNID_INT
             AND    LEITO.CD_LEITO       = ATENDIME.CD_LEITO
             AND    CONVENIO.TP_CONVENIO IN ('C','P') 
             AND    PACIENTE.CD_CIDADE = CIDADE.CD_CIDADE(+) 
             AND    ATENDIME.CD_CID = CID.CD_CID(+) 
             AND    ATENDIME.CD_MOT_ALT = MOT_ALT.CD_MOT_ALT(+) )I
WHERE 
   CD_CID IS NULL
   OR    (CD_PRO_INT_PROCEDIMENTO_ENTRAD IS NULL
          AND CD_SSM_CIH IS NULL)
   OR    CD_MOT_ALT IS NULL
   OR    DS_ENDERECO IS NULL      
   OR    NR_ENDERECO IS NULL 
   OR    NR_CEP IS NULL 
   OR    CD_CIDADE IS NULL 
   OR    CD_IBGE IS NULL 
   OR    CD_UF IS NULL 
   OR    DT_NASCIMENTO IS NULL 
   OR    NVL(TP_SEXO, 'I') = 'I'
   OR    Dbamv.Pkg_Inconsiste_CIH.Fn_Verifica_Inconsist (TP_SEXO
                                                        ,CD_SSM_CIH
                                                        ,CD_PRO_INT_PROCEDIMENTO_ENTRAD) = 'I'
   OR  (NOT EXISTS(SELECT '*'
                   FROM   DBAMV.CEP_LOCALIDADES
                   WHERE  NM_LOCALIDADE = I.NM_CIDADE
                   AND    CD_UF         = I.CD_UF
                   AND    LPAD(NR_CEP, 8, '0') = I.NR_CEP
                   )
        AND
        NOT EXISTS(SELECT '*'
                   FROM   DBAMV.CEP_LOCALIDADES LOCA,
                          DBAMV.CEP_LOGRADOUROS LOGR
                   WHERE  LOCA.CD_LOCALIDADE      = LOGR.CD_LOCALIDADE
                   AND    LOCA.NM_LOCALIDADE      = I.NM_CIDADE
                   AND    LOCA.CD_UF              = I.CD_UF
                   AND    LPAD(LOGR.NR_CEP, 8, '0') = I.NR_CEP
                  )
)
ORDER BY CD_ATENDIMENTO;