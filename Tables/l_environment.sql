declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table l_plan.l_environment');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('Ошибка '||sqlerrm);
end;
/
create table l_plan.l_environment (id    number not null,
                                   ccode varchar2(50),
                                   name  varchar2(256))
tablespace l_plan;
/
comment on table l_plan.l_environment is 'Справочник сред';
/
comment on column l_plan.l_environment.id    is 'ID среды';
comment on column l_plan.l_environment.ccode is 'Буквенный код среды';
comment on column l_plan.l_environment.name  is 'Наименование среды';
/
create unique index l_plan.environment_pk_id on l_plan.l_environment
(id)
tablespace l_plan;
/
alter table l_plan.l_environment
add (constraint environment_pk_id primary key (id) using index environment_pk_id);
/
create or replace trigger l_plan.tr_l_environment before insert
on l_plan.l_environment 
referencing new as new old as old
for each row
begin

    if :new.id is null then
    
        select (max(id)+1) 
        into   :new.id 
        from   l_plan.l_environment;
    end if;
end;
/
insert into l_plan.l_environment (id,
                                  ccode,
                                  name) values (1,
                                                'DEV',
                                                'Среда разработки');
insert into l_plan.l_environment (id,
                                  ccode,
                                  name) values (2,
                                                'TST',
                                                'Среда тестирования');
insert into l_plan.l_environment (id,
                                  ccode,
                                  name) values (3,
                                                'PRE',
                                                'Среда PreLive');
insert into l_plan.l_environment (id,
                                  ccode,
                                  name) values (4,
                                                'PROD',
                                                'Среда Production');
/
commit;
/