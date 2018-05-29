declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table l_plan.l_parameter');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('Ошибка '||sqlerrm);
end;
/
create table l_plan.l_parameter (uk         number         not null,
                                 param_name varchar2(255),
                                 param_desc varchar2(4000) not null)
tablespace l_plan;

comment on table l_plan.l_parameter is 'Справочник параметров';

comment on column l_plan.l_parameter.uk         is 'UK параметра';
comment on column l_plan.l_parameter.param_name is 'Наименование параметра';
comment on column l_plan.l_parameter.param_desc is 'Скрипт параметра';

create unique index l_plan.parameter_pk_uk on l_plan.l_parameter
(uk)
tablespace l_plan;

alter table l_plan.l_parameter
add (constraint parameter_pk_uk primary key (uk) using index parameter_pk_uk);

create unique index l_plan.parameter_pk_name on l_plan.l_parameter
(param_name)
tablespace l_plan;

alter table l_plan.l_parameter
add (constraint parameter_pk_name unique (param_name) using index parameter_pk_name);

create or replace trigger l_plan.tr_l_parameter 
before insert
on l_plan.l_parameter 
referencing new as new old as old
for each row
begin
    
    if :new.uk is null then

        select l_plan.l_s_action.nextval
        into   :new.uk 
        from   dual;
    
    end if;

end;
/
