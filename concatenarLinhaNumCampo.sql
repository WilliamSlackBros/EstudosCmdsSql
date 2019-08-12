select wm_concat(cd_laborator) from dbamv.val_opme_it_guia;
SELECT * FROM TUSS WHERE CD_TUSS IN('03010087');
SELECT * FROM DBAMV.pro_fat where cd_pro_fat in('03010087');
SELECT * FROM DBAMV.pro_fat where cd_pro_fat in('03010032');
SELECT
    *
FROM
atendime
where
cd_atendimento in(2635256);

select * from dbamv.itent_pro pro where pro.cd_produto in(17547);

select rtrim(xmlagg(xmlelement(e,cd_laborator))) from dbamv.val_opme_it_guia;

select LISTAGG(cd_laborator,",") within group  (ORDER BY cd_laborator desc) from dbamv.val_opme_it_guia;

select v.cd_guia,v.* from val_opme_it_guia v;-- where ds_observacao;
select * from  val_opme_it_guia valOpmeItGuia; 
select  wm_concat(valOpmeItGuia.ds_observacao || itguia.ds_observacao) from  val_opme_it_guia valOpmeItGuia, it_guia itguia where  valOpmeItGuia.cd_it_guia in(2230792);-- valOpmeItGuia.cd_it_guia = it_guia.cd_it_guia
select  wm_concat(valOpmeItGuia.ds_observacao) from  val_opme_it_guia valOpmeItGuia where  valOpmeItGuia.cd_it_guia in(2230792);
select v.cd_guia,v.* from val_opme_it_guia v where  v.cd_guia in(2230792);
SELECT @Lista = @Lista + ',' + COALESCE(CAMPO_DA_TABELA, '') FROM TABELA