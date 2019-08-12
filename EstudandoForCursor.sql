select * from SUE_SANTACASA.sue_ctrl_pag_rpa;

select p.nm_prestador from dbamv.prestador p;

INSERT INTO
SUE_SANTACASA.SUE_CTRL_PAG_RPA 
(
CD_CTRL_PAG_RPA, CD_MEDICO_PLANTAO,
"DATA",
HORARIO,
CD_MEDICO_SUBSTITUTO,
HORAS, 
MATRICULA) 
VALUES 
(
0, JOAO BATISTA VIEIRA, '2019-05-01', 
TO_DATE('2019-05-15 00:00:00', 'yyyy-mm-dd hh24:mi:ss'),
ACCD SAUDE LTDA, 8, '')
SELECT
    CD_CTRL_PAG_RPA,
    CD_MEDICO_PLANTAO,
    DATA,
    HORARIO,
    CD_MEDICO_SUBSTITUTO,
    HORAS,
    MATRICULA
	FROM
    SUE_SANTACASA.SUE_CTRL_PAG_RPA
	WHERE
    MATRICULA IN(UPPER('F16231'))
	ORDER BY DATA DESC, HORARIO DESC

SELECT
CD_CTRL_PAG_RPA, 
CD_MEDICO_PLANTAO, 
TO_DATE(TO_CHAR(HORARIO, 'yyyy-mm-dd hh24:mi:ss'), 
'yyyy-mm-dd hh24:mi:ss'), 
CD_MEDICO_SUBSTITUTO,
HORAS 
from 
SUE_SANTACASA.SUE_CTRL_PAG_RPA 
where 
MATRICULA IN(UPPER('F16231')) 
order by DATA DESC,
HORARIO DESC; 

SELECT
    CD_CTRL_PAG_RPA,
    CD_MEDICO_PLANTAO,
    'DATA',
    HORARIO,
    CD_MEDICO_SUBSTITUTO,
    HORAS,
    MATRICULA
	FROM
    SUE_SANTACASA.SUE_CTRL_PAG_RPA
	WHERE
    MATRICULA IN(UPPER('F16231'))
	ORDER BY DATA DESC, HORARIO DESC;

SELECT
    CD_CTRL_PAG_RPA,
    CD_MEDICO_PLANTAO,
    "DATA",
    HORARIO,
    CD_MEDICO_SUBSTITUTO,
    HORAS,
    MATRICULA
FROM
    SUE_SANTACASA.SUE_CTRL_PAG_RPA
WHERE
    (MATRICULA IN(UPPER('F16231')))--[P_MATRICULA]
OR
    (MATRICULA  IS NOT NULL)
ORDER BY DATA DESC, HORARIO DESC
select * from sue_ctrl_pag_rpa where (select * from sue_santacasa.sue_usuarios u where u.matricula in(UPPER('f16231')) or (select * from sue_santacasa.sue_usuarios u where u.matricula in(UPPER('f16231')));
create or REPLACE function retornar_lista 
return varchar
is
begin
return 
end;
create function test_cursor 
            return sys_refcursor
            is
                    c_result sys_refcursor;
            begin
                    open c_result for
                    select * from dual;
                    return c_result;
            end;
            select test_cursor  from dual;
----111111111----
create or REPLACE PROCEDURE  proc_test_cursor( prc out sys_refcursor)
 is
            begin
               
                   open prc for   select * from sue_usuarios;
                   
            end proc_test_cursor;
            var rc refcursor;
  execute proc_test_cursor(:rc) ;
  print rc;
---11111111111----
---222222222----
--create or REPLACE FUNCTION  proc_pipe
create or REPLACE PROCEDURE  proc_pipe

is
    
begin

    for record_output in(select * from sue_usuarios)
    loop
        pipe row (record_output.matricula);
    end loop;

end;
--SELECT * FROM TABLE(proc_test_pipe);
EXECUTE proc_pipe;

---222222222----
-----0000----   
create or REPLACE function test_cursor 
            return sys_refcursor
            is
                    c_result sys_refcursor;
            begin
                    open c_result for
                      select * from sue_usuarios;
                    return c_result;
            end;
            select test_cursor  from dual;
-----0000----
declare 
c_result  sys_refcursor;
begin
    open c_result for  select * from sue_usuarios;
    return c_result;
end;
SET SERVEROUTPUT ON;
Declare
      Cursor Cusuarios Is
     select * from sue_usuarios;
    Reg_User Cusuarios%Rowtype;
Begin
 Open Cusuarios;
    Fetch   Cusuarios into Reg_User;
    Dbms_Output.Put_Line(Reg_User.matricula);

     Close Cusuarios;
         SELECT
        *
    FROM sue_usuarios;
End;
SET SERVEROUTPUT ON;
declare
    cursor Cusuarios is
        select * from sue_usuarios;
       Reg_User Cusuarios%Rowtype;
begin
    Open Cusuarios;
        loop
            Fetch   Cusuarios into Reg_User;
           
            exit when Cusuarios%NotFound;
             Dbms_Output.Put_Line(Reg_User.matricula);
        end Loop;
    Close Cusuarios;
end;

SET SERVEROUTPUT ON;
Declare
      Cursor Cusuarios Is
     select * from sue_usuarios;
     OUTPUT_USUARIO PIPELINED;
Begin
      For Reg_Cli in Cusuarios
      Loop
        Dbms_Output.Put_Line(Reg_Cli.NM_USUARIO);
        --select Reg_Cli.NM_USUARIO from dual;
       PIPE ROW (OUTPUT_USUARIO(Reg_Cli.NM_USUARIO));
      End Loop;
End;