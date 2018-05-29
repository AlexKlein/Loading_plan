declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table l_plan.l_dependency_type');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('Ошибка '||sqlerrm);
end;
/
create table l_plan.l_dependency_type (id          number        not null,
                                       description varchar2(255))
tablespace l_plan;

comment on table l_plan.l_dependency_type is 'Перечень описанных зависимостей для действий';

comment on column l_plan.l_dependency_type.id          is 'ID типа зависимости';
comment on column l_plan.l_dependency_type.description is 'Краткое описание типа зависимости';

create unique index l_plan.dependency_type_pk_id on l_plan.l_dependency_type
(id)
tablespace l_plan;

alter table l_plan.l_dependency_type add (constraint dependency_type_pk_id primary key
(id) using index l_plan.dependency_type_pk_id enable validate);

create or replace trigger l_plan.tr_l_dependency_type 
before insert
on l_plan.l_dependency_type 
referencing new as new old as old
for each row
begin

    if :new.id is null then
    
        select (max(id)+1) 
        into   :new.id 
        from   l_plan.l_dependency_type;

    end if;
    
end;
/
