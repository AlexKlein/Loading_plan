declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table l_plan.l_parameter');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('Ошибка '||sqlerrm);
end;
/
create table l_plan.l_parameter (uk         number         not null,
                                 param_name varchar2(255),
                                 param_desc varchar2(4000) not null)
tablespace l_plan;

comment on table l_plan.l_parameter is 'Справочник параметров';

comment on column l_plan.l_parameter.uk         is 'UK параметра';
comment on column l_plan.l_parameter.param_name is 'Наименование параметра';
comment on column l_plan.l_parameter.param_desc is 'Скрипт параметра';

create unique index l_plan.parameter_pk_uk on l_plan.l_parameter
(uk)
tablespace l_plan;

alter table l_plan.l_parameter
add (constraint parameter_pk_uk primary key (uk) using index parameter_pk_uk);

create unique index l_plan.parameter_pk_name on l_plan.l_parameter
(param_name)
tablespace l_plan;

alter table l_plan.l_parameter
add (constraint parameter_pk_name unique (param_name) using index parameter_pk_name);

create or replace trigger l_plan.tr_l_parameter 
before insert
on l_plan.l_parameter 
referencing new as new old as old
for each row
begin
    
    if :new.uk is null then

        select l_plan.l_s_action.nextval
        into   :new.uk 
        from   dual;
    
    end if;

end;
/
insert into l_plan.l_parameter (uk,
                                param_name,
                                param_desc) values (l_plan.l_s_action.nextval,
                                                   'Установка параметров отчетов oracleBi',
                                                   'update report_obi.report_delivery set parameter1 = ''infaptst''');
insert into l_plan.l_parameter (uk,
                                param_name,
                                param_desc) values (l_plan.l_s_action.nextval,
                                                    'Настройка глубины синхронизации DMFR.ADJUSTMENTPLRB_UA_VHIST',
                                                    'update op_user.sync_param '||chr(10)|| 
                                                    'set    day_count = trunc(sysdate) - to_date(''$$P_START_MONTH'',''YYYYMMDD'') + 1 '||chr(10)||  
                                                    'where  ownname in (''DMFR'') and '||chr(10)|| 
                                                    '       tabname in (''ADJUSTMENTPLRB_UA_VHIST'')');
insert into l_plan.l_parameter (uk,
                                param_name,
                                param_desc) values (l_plan.l_s_action.nextval,
                                                    'Настройка глубины синхронизации DMFRUA.PLOPERATION_TRAN',
                                                    'update op_user.sync_param '||chr(10)|| 
                                                    'set    day_count = trunc(sysdate) - to_date(''$$P_START_MONTH'',''YYYYMMDD'') + 1 '||chr(10)||  
                                                    'where  ownname in (''DMFRUA'') and '||chr(10)|| 
                                                    '       tabname in (''PLOPERATION_TRAN'')');
insert into l_plan.l_parameter (uk,
                                param_name,
                                param_desc) values (l_plan.l_s_action.nextval,
                                                    'Расчет старой пенетарции за месяц',
                                                    'insert into loading_period (workflow_name,  operation_day,  report_period_start,  report_period_end,  loading_id,  cycle_count,  start_stamp,  end_stamp) '||chr(10)|| 
                                                    'values (''wf_CTL_DMPP_LOADING_W'', null, to_date(''$$P_START_MONTH'', ''YYYYMMDD''), to_date(''29990101'', ''YYYYMMDD''), null, 1, null, null)');
insert into l_plan.l_parameter (uk,
                                param_name,
                                param_desc) values (l_plan.l_s_action.nextval,
                                                    'Сбор статистики SETS_PENETRATIONFLTR_VHIST',
                                                    'exec dbms_stats.gather_table_stats(''DWH'',''SETS_PENETRATIONFLTR_VHIST'',null,1)');
insert into l_plan.l_parameter (uk,
                                param_name,
                                param_desc) values (l_plan.l_s_action.nextval,
                                                    'Расчет старой пенетрации за неделю',
                                                    'insert into loading_period (workflow_name,  operation_day,  report_period_start,  report_period_end,  loading_id,  cycle_count,  start_stamp,  end_stamp) '||chr(10)|| 
                                                    'values (''wf_ctl_dmpp_loading_w'', null, to_date(''$$P_START_MONTH'', ''YYYYMMDD''), to_date(''29990101'', ''YYYYMMDD''), null, 1, null, null)');
insert into l_plan.l_parameter (uk,
                                param_name,
                                param_desc) values (l_plan.l_s_action.nextval,
                                                    'Удалить расчет старой доходности',
                                                    'insert into loading_period (workflow_name,  operation_day,  report_period_start,  report_period_end,  loading_id,  cycle_count,  start_stamp,  end_stamp) '||chr(10)|| 
                                                    'values (''wf_CTL_DMPP_LOADING_PROFITABILITY_56_PROV_M'' , null, to_date(''$$P_START_MONTH'', ''YYYYMMDD''), to_date(''29990101'', ''YYYYMMDD''), null, 1, null, null)');
insert into l_plan.l_parameter (uk,
                                param_name,
                                param_desc) values (l_plan.l_s_action.nextval,
                                                    'Расчет Куба',
                                                    'insert into loading_period (workflow_name,  operation_day,  report_period_start,  report_period_end,  loading_id,  cycle_count,  start_stamp,  end_stamp) '||chr(10)|| 
                                                    'values (''wf_CTL_CUBERB_LOADING_M'', null, to_date(''$$P_START_MONTH'', ''YYYYMMDD''), to_date(''29990101'', ''YYYYMMDD''), null, 1, null, null)');
insert into l_plan.l_parameter (uk,
                                param_name,
                                param_desc) values (l_plan.l_s_action.nextval,
                                                    'Установка параметров для расчета Куба',
                                                    'insert into loading_period (workflow_name,  operation_day,  report_period_start,  report_period_end,  loading_id,  cycle_count,  start_stamp,  end_stamp) '||chr(10)|| 
                                                    'values (''WF_CTL_RBCC_LOADING_M'', null, to_date(''$$P_START_MONTH'', ''YYYYMMDD''), to_date(''P_START_MONTH'', ''YYYYMMDD''), null, 1, null, null)');
insert into l_plan.l_parameter (uk,
                                param_name,
                                param_desc) values (l_plan.l_s_action.nextval,
                                                    '',
                                                    'update ctl_workflow '||chr(10)|| 
                                                    'set    mode_type = ''RELOAD'' '||chr(10)|| 
                                                    'where  folder_name = ''FLOW_CONTROL_DMRB'' and '||chr(10)|| 
                                                    '       ctl_workflow_name = ''WF_CTL_RBCC_LOADING_M''');                                                     
insert into l_plan.l_parameter (uk,
                                param_name,
                                param_desc) values (l_plan.l_s_action.nextval,
                                                    'Исчторический расчет RWA',
'declare '||chr(10)||
'    p_operation_day             constant date := trunc (sysdate); '||chr(10)||
'    c_reload_ctl_folder_name    constant varchar2 (100) := ''FLOW_CONTROL_DMRB''; '||chr(10)||
'    c_reload_ctl_workflow_name_1         varchar2 (100) '||chr(10)||
'        := ''WF_CTL_DMRB_LOADING_DMRWA_MAN_DLRISKW''; '||chr(10)||
'    c_reload_report_period_type constant varchar2 (50) := ''DAY''; '||chr(10)||
'begin '||chr(10)||
'    delete from ctl_workflow '||chr(10)||
'    where  folder_name = c_reload_ctl_folder_name and '||chr(10)||
'           ctl_workflow_name = c_reload_ctl_workflow_name_1; '||chr(10)||

'    insert into ctl_workflow (folder_name, '||chr(10)||
'                              ctl_workflow_name, '||chr(10)||
'                              target_type, '||chr(10)||
'                              mode_type, '||chr(10)||
'                              report_period_type) '||chr(10)||
'    values (c_reload_ctl_folder_name, '||chr(10)||
'            c_reload_ctl_workflow_name_1, '||chr(10)||
'            ''DM'', '||chr(10)||
'            ''RELOAD'', '||chr(10)||
'            c_reload_report_period_type); '||chr(10)||
'    commit; '||chr(10)||
'    delete from loading_period '||chr(10)||
'    where  workflow_name in (c_reload_ctl_workflow_name_1) and '||chr(10)||
'           (loading_id is null or '||chr(10)||
'            loading_id in (select loading_id '||chr(10)||
'                           from   loading '||chr(10)||
'                           where  workflow_name in (c_reload_ctl_workflow_name_1) and '||chr(10)||
'                                  end_dttm is null)); '||chr(10)||
'    delete from loading_cycle_period '||chr(10)||
'    where  workflow_name in (c_reload_ctl_workflow_name_1) and '||chr(10)||
'           (start_dttm is null or end_dttm is null); '||chr(10)||
'    insert into loading_period (workflow_name, '||chr(10)||
'                                operation_day, '||chr(10)||
'                                report_period_start, '||chr(10)||
'                                report_period_end, '||chr(10)||
'                                loading_id, '||chr(10)||
'                                cycle_count) '||chr(10)||
'    values (c_reload_ctl_workflow_name_1, '||chr(10)||
'            p_operation_day, '||chr(10)||
'            to_date (''$$P_START_MONTH'', ''YYYYMMDD''), '||chr(10)||
'            to_date (''$$P_START_MONTH'', ''YYYYMMDD''), '||chr(10)||
'            null, '||chr(10)||
'            1); '||chr(10)||
'    commit; '||chr(10)||
'end'); 
insert into l_plan.l_parameter (uk,
                                param_name,
                                param_desc) values (l_plan.l_s_action.nextval,
                                                    'Обновление параметров исчторического расчет RWA',
                                                    'update ctl_workflow '||chr(10)||
                                                    'set    mode_type = ''REGULAR'' '||chr(10)||
                                                    'where  folder_name = ''FLOW_CONTROL_DMRB'' and '||chr(10)||
                                                    '       ctl_workflow_name = ''WF_CTL_DMRB_LOADING_DMRWA_MAN_DLRISKW'''); 
insert into l_plan.l_parameter (uk,
                                param_name,
                                param_desc) values (l_plan.l_s_action.nextval,
                                                    'Установка параметров исчторического пересчет RWA',
                                                    'insert into dm_loading (report_period_start, '||chr(10)||
                                                    '                        report_period_end, '||chr(10)||
                                                    '                        fct_period_start, '||chr(10)||
                                                    '                        fct_period_end, '||chr(10)||
                                                    '                        loading_id) '||chr(10)||
                                                    '    (select lp.report_period_start, '||chr(10)||
                                                    '            lp.report_period_end, '||chr(10)||
                                                    '            l.start_dttm, '||chr(10)||
                                                    '            l.end_dttm, '||chr(10)||
                                                    '            l.loading_id '||chr(10)||
                                                    '     from   loading l '||chr(10)||
                                                    '            join loading_period lp on l.loading_id = lp.loading_id '||chr(10)||
                                                    '            left join dm_loading dl on l.loading_id = dl.loading_id '||chr(10)||
                                                    '     where  l.workflow_name = ''WF_CTL_DMRB_LOADING_DMRWA_MAN_DLRISKW'' and '||chr(10)||
                                                    '            dl.loading_id is null and '||chr(10)||
                                                    '            l.folder_name = ''FLOW_CONTROL_DMRB'')');
insert into l_plan.l_parameter (uk,
                                param_name,
                                param_desc) values (l_plan.l_s_action.nextval,
                                                    'Расчет Мобилити за месяц',
'declare '||chr(10)||
'    p_operation_day             constant date := trunc (sysdate); '||chr(10)||
'    c_reload_ctl_folder_name    constant varchar2 (100) := ''FLOW_CONTROL_DMRB''; '||chr(10)||
'    c_reload_ctl_workflow_name_1         varchar2 (100) '||chr(10)||
'                                             := ''WF_CTL_DMRB_LOADING_MOBILITY''; '||chr(10)||
'    c_reload_report_period_type constant varchar2 (50) := ''DAY''; '||chr(10)||
'begin '||chr(10)||
'    delete from loading_period '||chr(10)||
'    where  workflow_name in (c_reload_ctl_workflow_name_1) and '||chr(10)||
'           (loading_id is null or '||chr(10)||
'            loading_id in (select loading_id '||chr(10)||
'                           from   loading '||chr(10)||
'                           where  workflow_name in (c_reload_ctl_workflow_name_1) and '||chr(10)||
'                                  end_dttm is null)); '||chr(10)||
'    delete from loading_cycle_period '||chr(10)||
'    where  workflow_name in (c_reload_ctl_workflow_name_1) and '||chr(10)||
'           (start_dttm is null or end_dttm is null); '||chr(10)||
'    insert into loading_period (workflow_name, '||chr(10)||
'                                operation_day, '||chr(10)||
'                                report_period_start, '||chr(10)||
'                                report_period_end, '||chr(10)||
'                                loading_id, '||chr(10)||
'                                cycle_count) '||chr(10)||
'    values (c_reload_ctl_workflow_name_1, '||chr(10)||
'            p_operation_day, '||chr(10)||
'            to_date (''$$P_START_MONTH'', ''YYYYMMDD''), '||chr(10)||
'            to_date (''$$P_START_MONTH'', ''YYYYMMDD''), '||chr(10)||
'            null, '||chr(10)||
'            1); '||chr(10)||
'    commit; '||chr(10)||
'end;');
insert into l_plan.l_parameter (uk,
                                param_name,
                                param_desc) values (l_plan.l_s_action.nextval,
                                                    'Выставление параметров для WF_CTL_DMACRM_LOADING_ETL_DMACRMPROV',
'declare '||chr(10)||
'    c_reg_folder_name   constant varchar2 (100) := ''FLOW_CONTROL_DMRB''; '||chr(10)||
'    c_reg_workflow_name constant varchar2 (100) '||chr(10)||
'                                     := ''WF_REG_DMACRM_REGULAR_PROV_AW'' ; '||chr(10)||
'    c_folder_name       constant varchar2 (100) := ''FLOW_CONTROL_DMRB''; '||chr(10)||
'    c_workflow_name     constant varchar2 (100) '||chr(10)||
'        := ''WF_CTL_DMACRM_LOADING_ETL_DMACRMPROV''; '||chr(10)||
'begin '||chr(10)||
'    um_api_rb.delparamoverride (p_reg_folder_name   => c_reg_folder_name, '||chr(10)||
'                                p_reg_workflow_name => c_reg_workflow_name); '||chr(10)||
'    for wf '||chr(10)||
'        in (select folder_name, workflow_name '||chr(10)||
'            from   (select distinct '||chr(10)||
'                           c2.folder as folder_name, '||chr(10)||
'                           c2.workflow_name as workflow_name '||chr(10)||
'                    from   wf_rel c1 '||chr(10)||
'                           left join dwswflowstructure_ldim c2 '||chr(10)||
'                               on c1.wf_id_from = c2.wfst_id '||chr(10)||
'                           left join dwswflowstructure_ldim c3 '||chr(10)||
'                               on c1.wf_id_to = c3.wfst_id '||chr(10)||
'                           inner join dwswflowstructure_ldim ctlwf '||chr(10)||
'                               on c1.ctl_workflow_id = ctlwf.wfst_id and '||chr(10)||
'                                  ctlwf.workflow_name = c_workflow_name and '||chr(10)||
'                                  ctlwf.folder = c_folder_name '||chr(10)||
'                    where  c1.validto > sysdate) '||chr(10)||
'            where  workflow_name is not null) '||chr(10)||
'    loop '||chr(10)||
'        um_api_rb.newparamoverride ( '||chr(10)||
'            p_reg_folder_name   => c_reg_folder_name, '||chr(10)||
'            p_reg_workflow_name => c_reg_workflow_name, '||chr(10)||
'            p_folder_name       => wf.folder_name, '||chr(10)||
'            p_workflow_name     => wf.workflow_name, '||chr(10)||
'            p_param_name        => ''$$P_REPORT_PERIOD_END'', '||chr(10)||
'            p_param_value       => ''$$P_START_MONTH''); '||chr(10)||
'    end loop; '||chr(10)||
'    commit; '||chr(10)||
'end;');
insert into l_plan.l_parameter (uk,
                                param_name,
                                param_desc) values (l_plan.l_s_action.nextval,
                                                    'Расчет Opex за месяц',
'declare '||chr(10)||
'    c_reg_folder_name   constant varchar2 (100) := ''FLOW_CONTROL_DMRB''; '||chr(10)||
'    c_reg_workflow_name constant varchar2 (100) '||chr(10)||
'                                     := ''WF_REG_DMRB_REGULAR_DMRBIFRS_OPEX'' ; '||chr(10)||
'    c_folder_name       constant varchar2 (100) := ''FLOW_CONTROL_DMRB''; '||chr(10)||
'    c_workflow_name     constant varchar2 (100) '||chr(10)||
'        := ''WF_CTL_DMRB_LOADING_ETL_DMRBIFRS_OPEX'' ; '||chr(10)||
'begin '||chr(10)||
'    um_api_rb.delparamoverride (p_reg_folder_name   => c_reg_folder_name, '||chr(10)||
'                                p_reg_workflow_name => c_reg_workflow_name); '||chr(10)||
'    for wf '||chr(10)||
'        in (select folder_name, workflow_name '||chr(10)||
'            from   (select distinct '||chr(10)||
'                           c2.folder as folder_name, '||chr(10)||
'                           c2.workflow_name as workflow_name '||chr(10)||
'                    from   wf_rel c1 '||chr(10)||
'                           left join dwswflowstructure_ldim c2 '||chr(10)||
'                               on c1.wf_id_from = c2.wfst_id '||chr(10)||
'                           left join dwswflowstructure_ldim c3 '||chr(10)||
'                               on c1.wf_id_to = c3.wfst_id '||chr(10)||
'                           inner join dwswflowstructure_ldim ctlwf '||chr(10)||
'                               on c1.ctl_workflow_id = ctlwf.wfst_id and '||chr(10)||
'                                  ctlwf.workflow_name = c_workflow_name and '||chr(10)||
'                                  ctlwf.folder = c_folder_name '||chr(10)||
'                    where  c1.validto > sysdate) '||chr(10)||
'            where  workflow_name is not null) '||chr(10)||
'    loop '||chr(10)||
'        um_api_rb.newparamoverride ( '||chr(10)||
'            p_reg_folder_name   => c_reg_folder_name, '||chr(10)||
'            p_reg_workflow_name => c_reg_workflow_name, '||chr(10)||
'            p_folder_name       => wf.folder_name, '||chr(10)||
'            p_workflow_name     => wf.workflow_name, '||chr(10)||
'            p_param_name        => ''$$P_REPORT_PERIOD_START'', '||chr(10)||
'            p_param_value       => ''$$P_START_MONTH''); '||chr(10)||
'        um_api_rb.newparamoverride ( '||chr(10)||
'            p_reg_folder_name   => c_reg_folder_name, '||chr(10)||
'            p_reg_workflow_name => c_reg_workflow_name, '||chr(10)||
'            p_folder_name       => wf.folder_name, '||chr(10)||
'            p_workflow_name     => wf.workflow_name, '||chr(10)||
'            p_param_name        => ''$$P_REPORT_PERIOD_END'', '||chr(10)||
'            p_param_value       => ''$$P_START_MONTH''); '||chr(10)||
'        um_api_rb.newparamoverride ( '||chr(10)||
'            p_reg_folder_name   => c_reg_folder_name, '||chr(10)||
'            p_reg_workflow_name => c_reg_workflow_name, '||chr(10)||
'            p_folder_name       => wf.folder_name, '||chr(10)||
'            p_workflow_name     => wf.workflow_name, '||chr(10)||
'            p_param_name        => ''$$P_RELOADING'', '||chr(10)||
'            p_param_value       => ''1''); '||chr(10)||
'    end loop; '||chr(10)||
'    commit; '||chr(10)||
'end;');
insert into l_plan.l_parameter (uk,
                                param_name,
                                param_desc) values (l_plan.l_s_action.nextval,
                                                    'Выставление параметров для WF_CTL_DMRB_LOADING_ETL_DMRBDETPL_DMFRUA',
'declare '||chr(10)||
'    c_reg_folder_name   constant varchar2 (100) := ''FLOW_CONTROL_DMRB''; '||chr(10)||
'    c_reg_workflow_name constant varchar2 (100) '||chr(10)||
'        := ''WF_REG_DMRB_REGULAR_DMRBDETPL_DMFRUAMAN'' ; '||chr(10)||
'    c_folder_name       constant varchar2 (100) := ''FLOW_CONTROL_DMRB''; '||chr(10)||
'    c_workflow_name     constant varchar2 (100) '||chr(10)||
'        := ''WF_CTL_DMRB_LOADING_ETL_DMRBDETPL_DMFRUA'' ; '||chr(10)||
'begin '||chr(10)||
'    um_api_rb.delparamoverride (p_reg_folder_name   => c_reg_folder_name, '||chr(10)||
'                                p_reg_workflow_name => c_reg_workflow_name); '||chr(10)||
'    for wf '||chr(10)||
'        in (select folder_name, workflow_name '||chr(10)||
'            from   (select distinct '||chr(10)||
'                           c2.folder as folder_name, '||chr(10)||
'                           c2.workflow_name as workflow_name '||chr(10)||
'                    from   wf_rel c1 '||chr(10)||
'                           left join dwswflowstructure_ldim c2 '||chr(10)||
'                               on c1.wf_id_from = c2.wfst_id '||chr(10)||
'                           left join dwswflowstructure_ldim c3 '||chr(10)||
'                               on c1.wf_id_to = c3.wfst_id '||chr(10)||
'                           inner join dwswflowstructure_ldim ctlwf '||chr(10)||
'                               on c1.ctl_workflow_id = ctlwf.wfst_id and '||chr(10)||
'                                  ctlwf.workflow_name = c_workflow_name and '||chr(10)||
'                                  ctlwf.folder = c_folder_name '||chr(10)||
'                    where  c1.validto > sysdate) '||chr(10)||
'            where  workflow_name is not null) '||chr(10)||
'    loop '||chr(10)||
'        um_api_rb.newparamoverride ( '||chr(10)||
'            p_reg_folder_name   => c_reg_folder_name, '||chr(10)||
'            p_reg_workflow_name => c_reg_workflow_name, '||chr(10)||
'            p_folder_name       => wf.folder_name, '||chr(10)||
'            p_workflow_name     => wf.workflow_name, '||chr(10)||
'            p_param_name        => ''$$P_REPORT_PERIOD_START'', '||chr(10)||
'            p_param_value       => ''$$P_START_MONTH''); '||chr(10)||
'        um_api_rb.newparamoverride ( '||chr(10)||
'            p_reg_folder_name   => c_reg_folder_name, '||chr(10)||
'            p_reg_workflow_name => c_reg_workflow_name, '||chr(10)||
'            p_folder_name       => wf.folder_name, '||chr(10)||
'            p_workflow_name     => wf.workflow_name, '||chr(10)||
'            p_param_name        => ''$$P_REPORT_PERIOD_END'', '||chr(10)||
'            p_param_value       => ''$$P_START_MONTH''); '||chr(10)||
'    end loop; '||chr(10)||
'    commit; '||chr(10)||
'end;');
insert into l_plan.l_parameter (uk,
                                param_name,
                                param_desc) values (l_plan.l_s_action.nextval,
                                                    '',
'declare '||chr(10)||
'    c_reg_folder_name   constant varchar2 (100) := ''FLOW_CONTROL_DMPP''; '||chr(10)||
'    c_reg_workflow_name constant varchar2 (100) '||chr(10)||
'                                     := ''WF_REG_DMPP_RELOADING_ANY_CTL'' ; '||chr(10)||
'    c_param_name        constant varchar2 (100) := ''$$P_DMPP_CTL_NAME''; '||chr(10)||
'    p_dmpp_ctl_name              varchar2 (300) '||chr(10)||
'                                     := ''WF_CTL_DMPP_LOADING_ETL_PNLAGG_DMPP''; '||chr(10)||
'    p_start_date                 varchar2 (10) '||chr(10)||
'        := to_date (''$$P_START_MONTH'', ''YYYYMMDD''); '||chr(10)||
'    p_end_date                   varchar2 (10) '||chr(10)||
'        := to_date (''$$P_START_MONTH'', ''YYYYMMDD''); '||chr(10)||
'    p_regtype                    varchar2 (1) := ''M''; '||chr(10)||
'begin '||chr(10)||
'    um_api_dmpp.paramoverride_reloading ( '||chr(10)||
'        p_reg_folder_name   => c_reg_folder_name, '||chr(10)||
'        p_reg_workflow_name => c_reg_workflow_name, '||chr(10)||
'        p_dmpp_wf_name      => p_dmpp_ctl_name, '||chr(10)||
'        p_param_name        => c_param_name, '||chr(10)||
'        p_start_date        => p_start_date, '||chr(10)||
'        p_end_date          => p_end_date, '||chr(10)||
'        p_regtype           => p_regtype); '||chr(10)||
'    commit; '||chr(10)||
'end;');
/
commit;
/