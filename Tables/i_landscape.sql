declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table l_plan.i_landscape');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('Ошибка '||sqlerrm);
end;
/
create table l_plan.i_landscape (id    number not null,
                                 ccode varchar2(50),
                                 name  varchar2(256))
tablespace l_plan;

comment on table l_plan.i_landscape is 'Справочник ландшафтов';

comment on column l_plan.i_landscape.id    is 'ID ландшафта';
comment on column l_plan.i_landscape.ccode is 'Символьный код';
comment on column l_plan.i_landscape.name  is 'Наименование ландшафта';

create unique index l_plan.landscape_pk_id on l_plan.i_landscape
(id)
tablespace l_plan;

alter table l_plan.i_landscape
add (constraint landscape_pk_id primary key (id) using index landscape_pk_id);

create or replace trigger l_plan.tr_i_landscape before insert
on l_plan.i_landscape 
referencing new as new old as old
for each row
begin

    if :new.id is null then
    
        select (max(id)+1) 
        into   :new.id 
        from   l_plan.i_landscape;
    end if;
end;
/
