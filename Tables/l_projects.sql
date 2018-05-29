declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table l_plan.l_projects');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('Ошибка '||sqlerrm);
end;
/
create table l_plan.l_projects (id    number       not null,
                                ccode varchar2(50),
                                name  varchar2(256))
tablespace l_plan;
/
comment on table l_plan.l_projects is 'Справочник проектов';
/
comment on column l_plan.l_projects.id    is 'ID проекта';
comment on column l_plan.l_projects.ccode is 'Символьный код проекта';
comment on column l_plan.l_projects.name  is 'Наименование проекта';
/
create unique index l_plan.projects_pk_id on l_plan.l_projects
(id)
tablespace l_plan;
/
alter table l_plan.l_projects
add (constraint projects_pk_id primary key (id) using index projects_pk_id);
/
create or replace trigger l_plan.tr_l_projects before insert
on l_plan.l_projects 
referencing new as new old as old
for each row
begin
    
    if :new.id is null then

        select (max(id)+1) 
        into   :new.id 
        from   l_plan.l_projects;
    end if;
end;
/
