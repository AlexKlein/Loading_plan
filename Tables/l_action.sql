declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table l_plan.l_action');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('Ошибка '||sqlerrm);
end;
/
create table l_plan.l_action (id            number        not null,
                              parameter_uk  number,
                              workflow_uk   number,
                              name         varchar2(255) not null)
tablespace l_plan;

comment on table l_plan.l_action is 'Перечень описанных действия для составления плана';

comment on column l_plan.l_action.id           is 'ID действия';
comment on column l_plan.l_action.parameter_uk is 'UK SQL скрипта параметра';
comment on column l_plan.l_action.workflow_uk  is 'UK запускаемого потока';
comment on column l_plan.l_action.name         is 'Краткое наименование действия';

create unique index l_plan.action_pk_id on l_plan.l_action
(id)
tablespace l_plan;

alter table l_plan.l_action
add (constraint action_pk_id primary key (id) using index action_pk_id);

create or replace trigger l_plan.tr_l_action 
before insert
on l_plan.l_action 
referencing new as new old as old
for each row
begin

    if :new.id is null then
    
        select (max(id)+1) 
        into   :new.id 
        from   l_plan.l_action;

    end if;
    
end;
/
