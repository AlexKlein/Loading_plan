declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table l_plan.i_landscape_relation');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('Ошибка '||sqlerrm);
end;
/
create table l_plan.i_landscape_relation (domain_id    number not null,
                                          landscape_id number not null)
tablespace l_plan;

comment on table l_plan.i_landscape_relation is 'Связь доменов и ландшафтов';

comment on column l_plan.i_landscape_relation.domain_id    is 'ID домена';
comment on column l_plan.i_landscape_relation.landscape_id is 'ID БД УМ';

create unique index l_plan.i_landscape_relation_pk on l_plan.i_landscape_relation
(domain_id,
 landscape_id)
tablespace l_plan;