begin
    execute immediate ('drop tablespace temp_1');
exception
    when others then
        null;
end;
/
create temporary tablespace temp_1 tempfile 
  '/oradata/u00/MY_DBASE/data_files/data/temp02.dbf' size 67108832k autoextend on next 10m maxsize unlimited
tablespace group ''
extent management local uniform size 1m;
