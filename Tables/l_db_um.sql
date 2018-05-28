declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table l_plan.l_db_um');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('Ошибка '||sqlerrm);
end;
/
create table l_plan.l_db_um (id      number not null,
                             ccode   varchar2(50),
                             name    varchar2(255))
tablespace l_plan;

comment on table l_plan.l_db_um is 'Справочник БД УМ';

comment on column l_plan.l_db_um.id      is 'ID БД';
comment on column l_plan.l_db_um.ccode   is 'Буквенный код БД УМ';
comment on column l_plan.l_db_um.name    is 'Наименование БД УМ';

create unique index l_plan.db_um_pk_id on l_plan.l_db_um
(id)
tablespace l_plan;

alter table l_plan.l_db_um
add (constraint db_um_pk_id primary key (id) using index db_um_pk_id);

create or replace trigger l_plan.tr_l_db_um before insert
on l_plan.l_db_um 
referencing new as new old as old
for each row
begin

    if :new.id is null then
    
        select (max(id)+1) 
        into   :new.id 
        from   l_plan.l_db_um;
    end if;
end;
/
insert into l_plan.l_db_um (id,
                            ccode,
                            name) values (1,
                                          'EXINFPRE',
                                          'УМ Prelive');
insert into l_plan.l_db_um (id,
                            ccode,
                            name) values (2,     
                                          'UMRBTST2',
                                          'УМ RBTST2');
commit;
/