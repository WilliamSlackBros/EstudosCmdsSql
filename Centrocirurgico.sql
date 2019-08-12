
  --CREATE OR REPLACE FORCE VIEW "DBAMV"."VDIC_ORCAMENTO_OPMEV2" ("DT_VIGENCIA", "NR_PRODUTO", "QT_AUT_SOLCITACAO", "QT_AUT_CONVENIO", "FUNC_GEROU", "DS_OBSERVACAO", "TP_PRE_POS_CIRURGICO", "DS_PRODUTO", "DS_CIRURGIA", "PROC_CONV_TUSS", "NM_FORNECEDOR", "NM_FABRICANTE", "NR_RMS", "CD_OPME_FORN", "VL_PERC_FRACAO", "VL_TAXA_COMERCIALIZACAO", "VL_UNITARIO", "VL_TOTAL", "DS_OBSERVACAO_OPME_IT_GUIA", "GETDSOBSITGUIAITOPME", "NR_ATENDIMENTO", "CD_PACIENTE", "HR_AVISO_MEDICO", "CD_PRO_INT", "CD_CONVENIO", "NM_CONVENIO", "CD_PRESTADOR", "CD_USUARIO_CRM", "NM_PRESTADOR", "DS_AVISO_OBS", "NR_CART_MATRICULA", "CD_GUIA", "NR_GUIA", "TP_GUIA", "CD_ATENDIMENTO", "NR_SENHA", "NM_PACIENTE", "DT_REALIZACAO", "DS_PLANO", "AVISO_CIRURGIA") AS 
  SELECT DISTINCT
    trunc(it_guia.dt_geracao)         AS dt_vigencia,
    it_guia.cd_pro_fat                AS nr_produto,
    it_guia.qt_autorizado             AS qt_aut_solcitacao,
    it_guia.qt_autorizada_convenio    AS qt_aut_convenio,
    it_guia.cd_usu_geracao            AS func_gerou,
    it_guia.ds_observacao             AS ds_observacao,
    it_guia.tp_pre_pos_cirurgico      AS tp_pre_pos_cirurgico,
    ( pro_fat.ds_pro_fat ) AS ds_produto,
    NULL AS ds_cirurgia,
    (
        SELECT
            MAX(t.cd_tuss) AS tuss
        FROM
            dbamv.tuss t
        WHERE
            t.cd_pro_fat IN (
                pro_fat.cd_pro_fat)
            AND ( t.cd_convenio IN (
                guia.cd_convenio)
                  OR t.cd_convenio IS NULL )
    ) AS proc_conv_tuss,
    (
        SELECT
            f.nm_fantasia
        FROM
            dbamv.fornecedor f
        WHERE
            f.cd_fornecedor IN (
                val_opme_it_guia.cd_fornecedor
            )
    ) AS nm_fornecedor,
    val_opme_it_guia.cd_laborator     AS nm_fabricante,
    val_opme_it_guia.cd_rms           AS nr_rms,
    val_opme_it_guia.cd_opme_forn     AS cd_opme_forn,
    val_opme_it_guia.vl_perc_fracao   AS vl_perc_fracao,
    --val_opme_it_guia.vl_taxa_comercializacao   AS vl_taxa_comercializacao,
    ( val_opme_it_guia.vl_taxa_comercializacao / it_guia.qt_autorizado ) AS vl_taxa_comercializacao,
    val_opme_it_guia.vl_unitario      AS vl_unitario,
    --val_opme_it_guia.vl_total                  AS vl_total,
    (
        --(val_opme_it_guia.vl_unitario * it_guia.qt_autorizado)+(val_opme_it_guia.vl_taxa_comercializacao*it_guia.qt_autorizado)
      (val_opme_it_guia.vl_unitario * it_guia.qt_autorizado+ nvl(val_opme_it_guia.vl_taxa_comercializacao,0))) AS vl_total,
    val_opme_it_guia.ds_observacao    AS ds_observacao_opme_it_guia,
    (
        SELECT
            getdsobsopme(aviso_cirurgia.cd_aviso_cirurgia)
        FROM
            dual
    ) AS getdsobsitguiaitopme,
    NULL AS nr_atendimento,
    aviso_cirurgia.cd_paciente        AS cd_paciente,
    TO_CHAR(aviso_cirurgia.dt_previsao_internacao, 'DD/MM/YYYY - HH24:MI:SS') AS hr_aviso_medico,
    NULL AS cd_pro_int,
    guia.cd_convenio                  AS cd_convenio,
    (
        SELECT
            nm_convenio
        FROM
            convenio
        WHERE
            cd_convenio = guia.cd_convenio
    ) AS nm_convenio,
    NULL AS cd_prestador,
    NULL AS cd_usuario_crm,
    NULL AS nm_prestador,
    aviso_cirurgia.ds_obs_aviso       AS ds_aviso_obs,
    NULL                              AS nr_cart_matricula,
    /******Dados da Guia *******/
    guia.cd_guia                      AS cd_guia,
    guia.nr_guia                      AS nr_guia,
    guia.tp_guia                      AS tp_guia,
    guia.cd_atendimento               AS cd_atendimento,
    guia.cd_senha                     AS nr_senha,
    aviso_cirurgia.nm_paciente        AS nm_paciente,
    trunc(aviso_cirurgia.dt_prev_inter) AS dt_realizacao,
    NULL AS ds_plano,
    guia.cd_aviso_cirurgia            AS aviso_cirurgia
FROM
    dbamv.aviso_cirurgia     aviso_cirurgia,
    dbamv.guia               guia,
    dbamv.it_guia            it_guia,
    dbamv.val_opme_it_guia   val_opme_it_guia,
    dbamv.pro_fat            pro_fat,
    dbamv.con_pla            con_pla
WHERE
    --guia.cd_aviso_cirurgia is not null
    guia.cd_aviso_cirurgia IN (264445)
    --aviso_cirurgia.cd_aviso_cirurgia IN (270825)--268019  270825
     AND aviso_cirurgia.cd_aviso_cirurgia IN (
        guia.cd_aviso_cirurgia
    )
    AND guia.cd_paciente IN (
        aviso_cirurgia.cd_paciente
    )
    AND guia.tp_guia IN (
        'O'
    )
    AND it_guia.cd_guia = guia.cd_guia--it guia para pegar o produto
    AND val_opme_it_guia.cd_guia = guia.cd_guia  --guia.cd_guia
    AND val_opme_it_guia.cd_it_guia = it_guia.cd_it_guia
    AND pro_fat.cd_pro_fat = it_guia.cd_pro_fat
    AND con_pla.cd_convenio = guia.cd_convenio
    AND aviso_cirurgia.cd_atendimento IS NULL
UNION 
/*****  segundo select para com atendimento -- mais completo o retorno *****/
SELECT DISTINCT
/***** itens da Guia ****/
--'trunc' - modificação necessaria para mvreport trabalhar com data----
    trunc(it_guia.dt_geracao) AS dt_vigencia,
    it_guia.cd_pro_fat                AS nr_produto,
    it_guia.qt_autorizado             AS qt_aut_solcitacao,
    it_guia.qt_autorizada_convenio    AS qt_aut_convenio,
    it_guia.cd_usu_geracao            AS func_gerou,
    it_guia.ds_observacao             AS ds_observacao,
    it_guia.tp_pre_pos_cirurgico      AS tp_pre_pos_cirurgico,
/******* Busca Procedimento e descricao do Procedimento ***/
    ( pro_fat.ds_pro_fat
      || it_guia.ds_observacao ) AS ds_produto,
   -- it_guia.ds_observacao                      AS ds_observacao,
    (
        SELECT
            fat.ds_pro_fat
        FROM
            pro_fat fat
        WHERE
            fat.cd_pro_fat IN (
                atendime.cd_pro_int
            )
    ) AS ds_cirurgia,
    (
        SELECT
            MAX(t.cd_tuss) AS tuss
        FROM
            dbamv.tuss t
        WHERE
            t.cd_pro_fat IN (
                pro_fat.cd_pro_fat
            )
            AND ( t.cd_convenio IN (
                atendime.cd_convenio
            )
                  OR t.cd_convenio IS NULL )
    ) AS proc_conv_tuss, --caso o procedimento não esteja null e esteja vinculada a um convenio especifico será nada como resposta
/*** parte val_opme_it_guia ***/
/******   valores calculados taxas fabricante *****/
    (
        SELECT
            f.nm_fantasia
        FROM
            dbamv.fornecedor f
        WHERE
            f.cd_fornecedor IN (
                val_opme_it_guia.cd_fornecedor
            )
    ) AS nm_fornecedor,
    val_opme_it_guia.cd_laborator     AS nm_fabricante,
    val_opme_it_guia.cd_rms           AS nr_rms,
    val_opme_it_guia.cd_opme_forn     AS cd_opme_forn,
    val_opme_it_guia.vl_perc_fracao   AS vl_perc_fracao,
    --val_opme_it_guia.vl_taxa_comercializacao   AS vl_taxa_comercializacao,
    ( val_opme_it_guia.vl_taxa_comercializacao / it_guia.qt_autorizado ) AS vl_taxa_comercializacao,
    val_opme_it_guia.vl_unitario      AS vl_unitario,
    --val_opme_it_guia.vl_total                  AS vl_total,
    (
        --(val_opme_it_guia.vl_unitario * it_guia.qt_autorizado)+(val_opme_it_guia.vl_taxa_comercializacao*it_guia.qt_autorizado)
     ( val_opme_it_guia.vl_unitario * it_guia.qt_autorizado ) + ( val_opme_it_guia.vl_taxa_comercializacao ) ) AS vl_total,
    val_opme_it_guia.ds_observacao    AS ds_observacao_opme_it_guia,
    (
        SELECT
            getdsobsopme(aviso_cirurgia.cd_aviso_cirurgia)
        FROM
            dual
    ) AS getdsobsitguiaitopme,--268019 aviso_cirurgia.cd_aviso_cirurgia
/****** fim dos  valores calculados taxas fabricante *****/

/******Dados Atendimento *******/
    atendime.cd_atendimento           AS nr_atendimento,
    atendime.cd_paciente              AS cd_paciente,
    --'trunc' - modificação necessaria para mvreport trabalhar com data----
    TO_CHAR(atendime.hr_aviso_medico, 'DD/MM/YYYY - HH24:MI:SS') AS hr_aviso_medico,
    --(select * from atendime where cd_paciente = 218178)
    atendime.cd_pro_int               AS cd_pro_int,
    atendime.cd_convenio              AS cd_convenio,
    (
        SELECT
            c.nm_convenio
        FROM
            dbamv.convenio c
        WHERE
            c.cd_convenio IN (
                atendime.cd_convenio
            )
    ) AS nm_convenio,
    atendime.cd_prestador             AS cd_prestador,
    (
        SELECT
            substr(usuario.cd_usuario, 2)
        FROM
            dbasgu.usuarios usuario
        WHERE
            usuario.cd_prestador IN (
                atendime.cd_prestador
            )
    ) AS cd_usuario_crm,
    (
        SELECT
            usuario.nm_usuario
        FROM
            dbasgu.usuarios usuario
        WHERE
            usuario.cd_prestador IN (
                atendime.cd_prestador
            )
    ) AS nm_prestador,
    atendime.ds_aviso_obs             AS ds_aviso_obs,
    atendime.nr_carteira              AS nr_cart_matricula,

/******Dados da Guia *******/
    guia.cd_guia                      AS cd_guia,
    guia.nr_guia                      AS nr_guia,
    guia.tp_guia                      AS tp_guia,
    guia.cd_atendimento               AS cd_atendimento,
--,guia.cd_convenio----não necessario, pois atendime.cd_convenio
    guia.cd_senha                     AS nr_senha,

/****** Dados aviso_cirurgia  ******/
    aviso_cirurgia.nm_paciente        AS nm_paciente,
    --'trunc' - modificação necessaria para mvreport trabalhar com data----
      --aviso_cirurgia.nm_paciente                 AS nm_paciente,

    --'trunc' - modificação necessaria para mvreport trabalhar com data----
    --TO_CHAR(aviso_cirurgia.dt_prev_inter, 'dd/mm/YYYY - HH24:MI:SS') AS dt_realizacao
    trunc(aviso_cirurgia.dt_prev_inter) AS dt_realizacao,

/***** retornar o plano****/
    con_pla.ds_con_pla                AS ds_plano,
    /********* Aviso Cirurgia Base para pesquisa *****/
    guia.cd_aviso_cirurgia            AS aviso_cirurgia
FROM
    dbamv.guia               guia,
    dbamv.it_guia            it_guia,
    dbamv.val_opme_it_guia   val_opme_it_guia,
    dbamv.pro_fat            pro_fat,
    dbamv.atendime           atendime,
    dbamv.aviso_cirurgia     aviso_cirurgia,
    dbamv.con_pla            con_pla
WHERE
--select * from guia where cd_paciente in(834030) order by   dt_geracao desc 
    --guia.cd_aviso_cirurgia is not null
    guia.cd_aviso_cirurgia IN (264445)--sem taxa de comercializacao 268019
    --guia.cd_aviso_cirurgia in(270825)--270825 sem taxa de comercializacao
    --guia.cd_aviso_cirurgia IN (254212)--com taxa de comercializacao
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
/*****
Destino: Setor OPME
Criado em: 17/06/2019
Relatório: Relatorio de Orçamento - 'Para o Convênio'
Objetivo: Reajustar o valor total e o valor unitário, pois está sendo calculado errado na valorização.
Criado por: William - Matricula F16231
*****/;
 
select * from DBASGU.usuarios where cd_usuario in('F16036');-- guia