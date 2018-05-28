declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table l_plan.l_variable');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('Ошибка '||sqlerrm);
end;
/
create table l_plan.l_variable (id          number        not null,
                                param_name  varchar2(255) not null,
                                param_desc  varchar2(1024))
tablespace l_plan;

comment on table l_plan.l_variable is 'Справочник Переменных';

comment on column l_plan.l_variable.id         is 'ID переменной';
comment on column l_plan.l_variable.param_name is 'Переменная как в параметрах';
comment on column l_plan.l_variable.param_desc is 'Описание переменной';

create or replace trigger l_plan.tr_l_variable 
before insert
on l_plan.l_variable 
referencing new as new old as old
for each row
begin
    
    if :new.id is null then

        select (max(id)+1) 
        into   :new.id 
        from   l_plan.l_variable;
    
    end if;

end;
/
