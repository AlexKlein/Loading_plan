declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table l_plan.l_log_loading_arch');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('Ошибка '||sqlerrm);
end;
/
create table l_plan.l_log_loading_arch (time_stamp      timestamp      default sysdate        not null,
                                        project_id      number                                not null,
                                        environment_id  number                                not null,
                                        db_um_id        number                                not null,
                                        domain_id       number                                not null,
                                        int_service_id  number                                not null,
                                        action_desc     varchar2(4000)                        not null,
                                        user_name       varchar2(255),
                                        action_id       number,
                                        run_id          number,
                                        workflow_run_id number,
                                        workflow_start  date,
                                        workflow_end    date)
tablespace l_plan;

comment on table l_plan.l_log_loading_arch is 'Логирование действий по плану загрузки';

comment on column l_plan.l_log_loading_arch.time_stamp      is 'Дата и время действия';
comment on column l_plan.l_log_loading_arch.project_id      is 'ID проекта';
comment on column l_plan.l_log_loading_arch.environment_id  is 'ID среды';
comment on column l_plan.l_log_loading_arch.db_um_id        is 'ID БД УМ';
comment on column l_plan.l_log_loading_arch.domain_id       is 'ID домена';
comment on column l_plan.l_log_loading_arch.int_service_id  is 'ID интеграционного сервиса';
comment on column l_plan.l_log_loading_arch.action_desc     is 'Действие пункта';
comment on column l_plan.l_log_loading_arch.user_name       is 'Пользователь, запустивший загрузку';
comment on column l_plan.l_log_loading_arch.action_id       is 'ID действия, взятого в работу';
comment on column l_plan.l_log_loading_arch.run_id          is 'ID плана, взятого в работу';
comment on column l_plan.l_log_loading_arch.workflow_run_id is 'ID запущенного потока в информатике';
comment on column l_plan.l_log_loading_arch.workflow_start  is 'Время запуска потока в информатике';
comment on column l_plan.l_log_loading_arch.workflow_end    is 'Время завершения потока в информатике';

create index l_plan.loaidng_arch_env on l_plan.l_log_loading_arch
(time_stamp, 
 project_id, 
 environment_id, 
 domain_id, 
 int_service_id)
tablespace l_plan;

create index l_plan.loaidng_arch_act on l_plan.l_log_loading_arch
(time_stamp,
 action_desc, 
 action_id)
tablespace l_plan;