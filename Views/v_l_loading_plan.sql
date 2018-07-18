declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table l_plan.v_l_loading_plan');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('Ошибка '||sqlerrm);
end;
/
create or replace view l_plan.v_l_loading_plan (action_id,
                                                action_rowid,
                                                comments,
                                                workflow,
                                                var_list,
                                                depend,
                                                environment_id,
                                                project_id,
                                                db_um_id,
                                                domain_id,
                                                int_service_id,
                                                run_id,
                                                param_uk)
as
    select pl.action_id,
           act.rowid as action_rowid,
           pl.comments,
           wf.folder||'\'||chr(10)||'    '||wf.name as workflow,
           regexp_replace (replace (
           case
               when trim (
                        listagg (
                            var.param_name ||
                            ' ' ||
                            var_val.param_value,
                            ', ')
                        within group (order by var.param_name))
                        is null
               then
                   null
               else
                   trim (
                       listagg (
                           var.param_name ||
                           ' - ' ||
                           var_val.param_value,
                           ', ')
                       within group (order by var.param_name))
           end, ' - ,', ' - ???,'), '[ -]$', '- ???') as var_list,
           dep.depend,
           pl.environment_id,
           pl.project_id,
           pl.db_um_id,
           pl.domain_id,
           pl.int_service_id,
           pl.run_id,
           pr.uk
    from   l_plan.l_loading_plan pl
    left outer join l_plan.l_action act 
                 on pl.action_id = act.id
    left outer join l_plan.l_workflow wf 
                 on act.workflow_uk = wf.uk
    left outer join l_plan.l_parameter pr 
                 on act.parameter_uk = pr.uk
    left outer join l_plan.l_variable var
                 on pr.param_desc like
                    '%'||chr(42)||var.param_name||chr(42)||'%'
    left outer join l_plan.l_variable_value var_val
                 on var_val.param_id = var.id and
                    var_val.db_um_id = pl.db_um_id and
                    var_val.domain_id = pl.domain_id and
                    var_val.environment_id = pl.environment_id and
                    var_val.int_service_id = pl.int_service_id and
                    var_val.project_id = pl.project_id
    left outer join (select sub.action_id,
                            listagg(typ.description||' '||dep.dependency_ccode,
                            ','||chr(10)) within group (order by sub.action_id) as depend
                     from   l_plan.l_dependency_subscriber sub
                     inner join l_plan.l_dependency dep
                             on sub.dependency_id = dep.id
                     inner join l_plan.l_dependency_type typ
                             on dep.type_id = typ.id
                     group by sub.action_id) dep
                 on dep.action_id = pl.action_id
    group by pl.action_id,
             act.rowid,
             pl.comments,
             pl.environment_id,
             pl.project_id,
             pl.db_um_id,
             pl.domain_id,
             pl.int_service_id,
             pl.run_id,
             pr.uk,
             wf.folder||'\'||chr(10)||'    '||wf.name,
             dep.depend;

comment on column l_plan.v_l_loading_plan.action_id      is 'Действие';
comment on column l_plan.v_l_loading_plan.action_rowid   is 'ROWID действия';
comment on column l_plan.v_l_loading_plan.comments       is 'Комментарий';
comment on column l_plan.v_l_loading_plan.workflow       is 'Папка и название потока';
comment on column l_plan.v_l_loading_plan.var_list       is 'Список переменных';
comment on column l_plan.v_l_loading_plan.depend         is 'Список зависимостей';
comment on column l_plan.v_l_loading_plan.environment_id is 'ID среды';
comment on column l_plan.v_l_loading_plan.project_id     is 'ID проекта';
comment on column l_plan.v_l_loading_plan.db_um_id       is 'ID БД УМ';
comment on column l_plan.v_l_loading_plan.domain_id      is 'ID домена';
comment on column l_plan.v_l_loading_plan.int_service_id is 'ID интеграционного сервиса';
comment on column l_plan.v_l_loading_plan.run_id         is 'ID взятого в работу плана';
comment on column l_plan.v_l_loading_plan.param_uk       is 'UK параметра';
/
