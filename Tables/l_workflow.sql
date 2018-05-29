declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table l_plan.l_workflow');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('Ошибка '||sqlerrm);
end;
/
create table l_plan.l_workflow (uk     number        not null,
                                folder varchar2(255) not null,
                                name   varchar2(255) not null)
tablespace l_plan;

comment on table l_plan.l_workflow is 'Справочник запускаемых потоков';

comment on column l_plan.l_workflow.uk             is 'UK потока';
comment on column l_plan.l_workflow.folder         is 'Папка потока';
comment on column l_plan.l_workflow.name           is 'Наименование потока';

create unique index l_plan.workflows_pk_uk on l_plan.l_workflow
(uk)
tablespace l_plan;

alter table l_plan.l_workflow
add (constraint workflows_pk_uk primary key (uk) using index workflows_pk_uk);

create unique index l_plan.workflows_pk_name on l_plan.l_workflow
(folder,
 name)
tablespace l_plan;

alter table l_plan.l_workflow
add (constraint workflows_pk_name unique (folder,name) using index workflows_pk_name);

create or replace trigger l_plan.tr_l_workflow before insert
on l_plan.l_workflow 
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
