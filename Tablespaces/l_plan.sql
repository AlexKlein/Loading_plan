begin
    execute immediate ('drop tablespace l_plan');
exception
    when others then
        null;
end;
/
create tablespace l_plan datafile 
  '/oradata/u00/MY_DBASE/data_files/data/L_PLAN_01.dbf' size 512m autoextend on next 256m maxsize unlimited;