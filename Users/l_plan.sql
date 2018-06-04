begin
    execute immediate ('drop user l_plan');
exception
    when others then
        null;
end;
/
create user l_plan
  identified by <password>
  default tablespace l_plan
  temporary tablespace temp_1
  profile default
  account unlock;
  
grant create cluster       to l_plan;
grant create database link to l_plan;
grant create dimension     to l_plan;
grant create external job  to l_plan;
grant create indextype     to l_plan;
grant create job           to l_plan;
grant create materialized view to l_plan;
grant create operator      to l_plan;
grant create procedure     to l_plan;
grant create sequence      to l_plan;
grant create session       to l_plan;
grant create synonym       to l_plan;
grant create table         to l_plan;
grant create trigger       to l_plan;
grant create type          to l_plan;
grant create view          to l_plan;

alter user l_plan quota unlimited on l_plan;
alter user l_plan grant connect through apex_rest_public_user;