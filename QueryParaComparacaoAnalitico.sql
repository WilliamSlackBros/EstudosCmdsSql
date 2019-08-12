SELECT DISTINCT
    ATE.CD_CONVENIO      AS NR_CONVENIO
    ,CONV.NM_CONVENIO    AS  NM_CONVENIO
    ,ATE.CD_ATENDIMENTO  AS  NR_ATENDIMENTO
    ,ATE.DT_ATENDIMENTO  AS  DT_ATENDIMENTO
    ,ATE.DT_ALTA         AS  DT_ALTA
    ,ATE.CD_PACIENTE     AS  NR_PACIENTE
    ,PAC.NM_PACIENTE     AS  NM_PACIENTE
    ,1                   AS  QTD
    ,ORI.DS_ORI_ATE      AS  ORIGEM_ATENDIMENTO
FROM
    ATENDIME    ATE
    ,ORI_ATE    ORI
    ,CONVENIO   CONV
    ,PACIENTE   PAC
WHERE
    ATE.CD_ORI_ATE = ORI.CD_ORI_ATE
    AND ATE.CD_CONVENIO=CONV.CD_CONVENIO
    AND ATE.CD_PACIENTE=PAC.CD_PACIENTE
AND ATE.SN_RETORNO = 'N'
AND ATE.CD_ORI_ATE in(3)--,4,30,51)
and ATE.CD_CONVENIO not in(1,2)
and ATE.tp_atendimento in ('A','E')
and TO_CHAR(ATE.DT_ATENDIMENTO,'MM/YYYY')='01/2018'
ORDER BY CONV.NM_CONVENIO ASC;

SELECT DISTINCT
   ATE.CD_ATENDIMENTO ATENDIMENTOS
FROM
    ATENDIME    ATE
    ,ORI_ATE    ORI
    ,CONVENIO   CONV
    ,PACIENTE   PAC
WHERE
    ATE.CD_ORI_ATE = ORI.CD_ORI_ATE
    AND ATE.CD_CONVENIO=CONV.CD_CONVENIO
    AND ATE.CD_PACIENTE=PAC.CD_PACIENTE
AND ATE.SN_RETORNO = 'N'
AND ATE.CD_ORI_ATE in(3)--,4,30,51)
and ATE.CD_CONVENIO not in(1,2)
and ATE.tp_atendimento in ('A','E')
and TO_CHAR(ATE.DT_ATENDIMENTO,'MM/YYYY')='01/2018'
ORDER BY ATENDIMENTOS ASC;
