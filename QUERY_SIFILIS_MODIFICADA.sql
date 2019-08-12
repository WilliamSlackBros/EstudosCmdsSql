CREATE OR REPLACE FORCE VIEW "DBAMV"."VDIC_NOTIF_COMPULSORIA_VDRL"
(
"CODIGO_PEDIDO", 
"PRESCRICAO", 
"DATA_PEDIDO", 
"HORA_PEDIDO", 
"DATA_LAUDO", 
"CODIGO_SETOR", 
"SETOR", 
"ATENDIMENTO",
"DATA_ALTA", 
"CODIGO_ALTA", 
"MOTIVO_ALTA", 
"PACIENTE", 
"CODIGO_EXAME", 
"NOME_EXAME",
"RESULTADO", 
"MATERIAL", 
"DT_NASCIMENTO", 
"IDADE", 
"SEXO",
"NOME_MAE",
"ENDERECO_PAC", 
"TELEFONE", 
"CIDADE", 
"HEMATOCRITO", 
"LEUCOCITOS", 
"PLAQUETAS", 
"DT_RESULTADO"
)
AS
--CREATE OR REPLACE FORCE VIEW "DBAMV"."VDIC_NOTIF_COMPULSORIA_VDRL"  AS 
SELECT distinct
       pl.cd_ped_lab                                                                               codigo_pedido
    ,  pm.cd_pre_med                                                                                Prescricao
    ,  to_char(pl.dt_pedido, 'dd/mm/yyyy')                                                          data_pedido
    ,  To_Char(pl.hr_ped_lab, 'HH24:mi')                                                            hora_pedido
    ,  ipl.dt_laudo                                                                                 Data_laudo
    ,  pl.cd_setor                                                                                  codigo_setor
    ,  se.nm_setor                                                                                  setor
    ,  pl.cd_atendimento                                                                            atendimento
    ,  trunc(ae.dt_alta)                                                                            data_alta
    ,  ae.cd_mot_alt                                                                                codigo_alta
    ,  motalt.ds_mot_alt                                                                                motivo_alta
    ,  pa.nm_paciente                                                                               paciente
    ,  el.cd_exa_lab                                                                                codigo_exame
    ,  el.nm_exa_lab                                                                                nome_exame
    ,  Upper(ra.ds_resultado)                                                                       Resultado
    ,  ma.ds_material                                                                               Material
    ,  pa.dt_nascimento                                                                             Dt_nascimento
    ,  trunc((sysdate - pa.dt_nascimento)/365,0)                                                    Idade
    ,  decode(pa.tp_sexo, 'M', 'MASCULINO',
                          'F', 'FEMININO')                                                          Sexo
    ,  pa.nm_mae                                                                                    Nome_Mae
    ,  pa.ds_endereco||', '||pa.nr_endereco||', '||pa.ds_complemento||', '||pa.nm_bairro            Endereco_Pac
    ,  pa.nr_fone                                                                                   Telefone
    ,  ci.nm_cidade                                                                                 Cidade
    ,  nc.HEMATOCRITO                                                                               Hematocrito
    ,  nc.LEUCOCITOS                                                                                Leucocitos
    ,  nc.PLAQUETAS                                                                                 Plaquetas
    ,  nc.dt_pedido                                                                                 Dt_Resultado
   
FROM
    atendime                ae
    INNER JOIN ped_lab      pl
    ON ae.cd_atendimento    =   pl.cd_atendimento
    INNER JOIN  itped_lab   ipl
    ON ipl.cd_ped_lab = pl.cd_ped_lab
    INNER JOIN  exa_lab     el
    ON ipl.cd_exa_lab =   el.cd_exa_lab
    AND el.cd_exa_lab           in   (1374)
    INNER JOIN   res_exa    ra
    ON ra.cd_exa_lab = ipl.cd_exa_lab
    AND ra.ds_resultado is not null
    INNER JOIN   material   ma
    ON ma.cd_material = ipl.cd_material
    INNER JOIN   paciente   pa
    ON pa.cd_paciente = ae.cd_paciente
    INNER JOIN   setor      se
    ON se.cd_setor = pl.cd_setor
    INNER JOIN   cidade     ci
    ON ci.cd_cidade = pa.cd_cidade
    INNER JOIN   pre_med    pm
    ON pm.cd_pre_med = pl.cd_pre_med
    INNER JOIN vdic_result_exa_not_compuls nc 
    ON nc.atendimento = pl.cd_atendimento
    INNER JOIN   mot_alt    motAlt
    ON motalt.cd_mot_alt = ae.cd_mot_alt
WHERE
    (pl.dt_pedido BETWEEN TO_DATE('01/05/2019','DD/MM/YYYY') AND TO_DATE('10/05/2019','DD/MM/YYYY') )
    GROUP by pl.dt_pedido
    ;
   -- pl.dt_pedido between '01/05/2019' and '10/05/2019';
  -- ROWNUM < 3;
  -- ra.ds_resultado is not null
  -- and el.cd_exa_lab           in   (1374);
   --modificado para aparecer paciente que estao ainda internados e fizeram exame de DENGUE '30/04/2019'--
  -- and ra.nm_campo not like '%OBS%'
   --and el.cd_exa_lab           =    nc.Cd_exa
  -- and el.cd_exa_lab           in   (1849)
  --and pl.dt_pedido            between '01/05/2019' and '30/05/2019'
  --modificado '30/04/2019' para retorna somente exames com DENGUE e nao null--
  --and el.nm_exa_lab like Upper('%DENGUE%')

  --and el.cd_exa_lab           in   (1374,1309,1849,140)
 

