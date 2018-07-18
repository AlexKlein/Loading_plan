declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table l_plan.v_l_variable_value');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('Ошибка '||sqlerrm);
end;
/
create or replace view l_plan.v_l_variable_value (row_id,
                                                  param_id,
                                                  param_name,
                                                  param_desc,
                                                  param_value,
                                                  environment_id,
                                                  project_id,
                                                  db_um_id,
                                                  domain_id,
                                                  int_service_id)
as
    select varval.rowid as row_id,
           varval.param_id,
           var.param_name,
           var.param_desc,
           varval.param_value,
           varval.environment_id,
           varval.project_id,
           varval.db_um_id,
           varval.domain_id,
           varval.int_service_id
    from   l_plan.l_variable_value varval
    left outer join l_plan.l_variable var 
                 on var.id = varval.param_id;

comment on column l_plan.v_l_variable_value.row_id         is 'ROWID значений переменных';
comment on column l_plan.v_l_variable_value.param_id       is 'ID переменной';
comment on column l_plan.v_l_variable_value.param_name     is 'Переменная как в параметрах';
comment on column l_plan.v_l_variable_value.param_desc     is 'Описание переменной';
comment on column l_plan.v_l_variable_value.param_value    is 'Значение переменной';
comment on column l_plan.v_l_variable_value.environment_id is 'ID среды';
comment on column l_plan.v_l_variable_value.project_id     is 'ID проекта';
comment on column l_plan.v_l_variable_value.db_um_id       is 'ID БД УМ';
comment on column l_plan.v_l_variable_value.domain_id      is 'ID домена';
comment on column l_plan.v_l_variable_value.int_service_id is 'ID интеграционного сервиса';
/