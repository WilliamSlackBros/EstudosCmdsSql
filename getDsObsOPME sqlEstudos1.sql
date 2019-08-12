CREATE or replace FUNCTION getDsObsOPME(nraviso IN NUMBER) 
RETURN  VARCHAR2 
 IS ds_obs VARCHAR2(2000);
BEGIN
SELECT 
  wm_concat(
   it_guia.ds_observacao
  ) AS ds_observacao_it_opme_it_guia
   INTO ds_obs
/*
  wm_concat(
  val_opme_it_guia.ds_observacao || it_guia.ds_observacao
  ) AS ds_observacao_it_opme_it_guia
   INTO ds_obs
   */
FROM
    dbamv.guia               guia,
    dbamv.it_guia            it_guia,
    dbamv.val_opme_it_guia   val_opme_it_guia,
    dbamv.pro_fat            pro_fat,
    dbamv.atendime           atendime,
    dbamv.aviso_cirurgia     aviso_cirurgia,
    dbamv.con_pla            con_pla
WHERE
    guia.cd_aviso_cirurgia in(nraviso)
     --guia.cd_aviso_cirurgia is not null
    --guia.cd_aviso_cirurgia in(268019)--sem taxa de comercializacao
    --guia.cd_aviso_cirurgia IN (268019)--com taxa de comercializacao
    AND guia.tp_guia IN (
        'O'
    )
    AND it_guia.cd_guia IN (
        guia.cd_guia
    )
    AND atendime.cd_atendimento = guia.cd_atendimento
    AND val_opme_it_guia.cd_it_guia = it_guia.cd_it_guia
    AND pro_fat.cd_pro_fat = it_guia.cd_pro_fat
    AND aviso_cirurgia.cd_aviso_cirurgia IN (
        guia.cd_aviso_cirurgia
    )
    AND con_pla.cd_con_pla IN (
        atendime.cd_con_pla
    )
    AND con_pla.cd_convenio IN (
        atendime.cd_convenio
    )
    ORDER BY guia.cd_aviso_cirurgia ASC;
      RETURN(ds_obs); 
     END getDsObsOPME;
/*****
Destino: Setor OPME
Criado em: 17/06/2019
Relatório: Relatorio de Orçamento - 'Para o Convênio'
Objetivo: Reajustar o valor total e o valor unitário, pois está sendo calculado errado na valorização.
Criado por: William - Matricula F16231
*****/

/*
CREATE FUNCTION get_bal(acc_no IN NUMBER) 
   RETURN NUMBER 
   IS acc_bal NUMBER(11,2);
   BEGIN 
      SELECT order_total 
      INTO acc_bal 
      FROM orders 
      WHERE customer_id = acc_no; 
      RETURN(acc_bal); 
    END;
*/