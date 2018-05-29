declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table l_plan.l_loading_plan');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('Ошибка '||sqlerrm);
end;
/
create table l_plan.l_loading_plan (action_id       number         not null,
                                    comments        varchar2(4000),
                                    environment_id  number         not null,
                                    project_id      number         not null,
                                    db_um_id        number         not null,
                                    domain_id       number         not null,
                                    int_service_id  number         not null,
                                    run_id          number)
tablespace l_plan;

comment on table l_plan.l_loading_plan is 'План загрузки';

comment on column l_plan.l_loading_plan.action_id      is 'Действие';
comment on column l_plan.l_loading_plan.comments       is 'Комментарий';
comment on column l_plan.l_loading_plan.environment_id is 'ID среды';
comment on column l_plan.l_loading_plan.project_id     is 'ID проекта';
comment on column l_plan.l_loading_plan.db_um_id       is 'ID БД УМ';
comment on column l_plan.l_loading_plan.domain_id      is 'ID домена';
comment on column l_plan.l_loading_plan.int_service_id is 'ID интеграционного сервиса';
comment on column l_plan.l_loading_plan.run_id         is 'ID взятого в работу плана';
