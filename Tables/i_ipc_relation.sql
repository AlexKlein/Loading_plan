declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table l_plan.i_ipc_relation');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('ќшибка '||sqlerrm);
end;
/
create table l_plan.i_ipc_relation (domain_id       number not null,
                                    int_service_id  number not null)
tablespace l_plan;

comment on table l_plan.i_ipc_relation is 'Связь доменов и интеграционных сервисов';

comment on column l_plan.i_ipc_relation.domain_id      is 'ID домена';
comment on column l_plan.i_ipc_relation.int_service_id is 'ID интеграционного сервиса';

create unique index l_plan.i_ipc_relation_pk on l_plan.i_ipc_relation
(domain_id,
 int_service_id)
tablespace l_plan;
/
