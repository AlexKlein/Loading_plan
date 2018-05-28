declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table l_plan.l_int_service');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('������ '||sqlerrm);
end;
/
create table l_plan.l_int_service (id    number not null,
                                   ccode varchar2(50),
                                   name  varchar2(50))
tablespace l_plan;
/
comment on table l_plan.l_int_service is '���������� �������������� ��������';
/
comment on column l_plan.l_int_service.id    is 'ID ��������������� �������';
comment on column l_plan.l_int_service.ccode is '��������� ��� �������';
comment on column l_plan.l_int_service.name  is '�������� �������';
/
create unique index l_plan.int_service_pk_id on l_plan.l_int_service
(id)
tablespace l_plan;
/
alter table l_plan.l_int_service
add (constraint int_service_pk_id primary key (id) using index int_service_pk_id);
/
create or replace trigger l_plan.tr_l_int_service before insert
on l_plan.l_int_service 
referencing new as new old as old
for each row
begin

    if :new.id is null then
    
        select (max(id)+1) 
        into   :new.id 
        from   l_plan.l_int_service;
    end if;
end;
/
insert into l_plan.l_int_service (id,
                                  ccode,
                                  name) values (1,
                                                'INT_RB_TST1',
                                                '������ ����� DMRB');
insert into l_plan.l_int_service (id,
                                  ccode,
                                  name) values (2,
                                                'INT_DW_TST2',
                                                '������ ����� ����');
insert into l_plan.l_int_service (id,
                                  ccode,
                                  name) values (3,
                                                'INT_EX_PRE',
                                                '������ PreLive');
commit;
/