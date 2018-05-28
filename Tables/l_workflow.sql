declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table l_plan.l_workflow');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('Ошибка '||sqlerrm);
end;
/
create table l_plan.l_workflow (uk     number        not null,
                                folder varchar2(255) not null,
                                name   varchar2(255) not null)
tablespace l_plan;

comment on table l_plan.l_workflow is 'Справочник запускаемых потоков';

comment on column l_plan.l_workflow.uk             is 'UK потока';
comment on column l_plan.l_workflow.folder         is 'Папка потока';
comment on column l_plan.l_workflow.name           is 'Наименование потока';

create unique index l_plan.workflows_pk_uk on l_plan.l_workflow
(uk)
tablespace l_plan;

alter table l_plan.l_workflow
add (constraint workflows_pk_uk primary key (uk) using index workflows_pk_uk);

create unique index l_plan.workflows_pk_name on l_plan.l_workflow
(folder,
 name)
tablespace l_plan;

alter table l_plan.l_workflow
add (constraint workflows_pk_name unique (folder,name) using index workflows_pk_name);

create or replace trigger l_plan.tr_l_workflow before insert
on l_plan.l_workflow 
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
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMRB', 
                                             'WF_REG_DMRB_REGULAR_DWH');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMRB', 
                                             'WF_ACTL_DM_LOADING_DWH_AW_thursday');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMRB', 
                                             'WF_ACTL_DM_LOADING_DMFR_M7_b');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMRB', 
                                             'WF_REG_DMRB_REGULAR_DMRBDETPL_DMFRUAMAN');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMRB', 
                                             'WF_ACTL_DM_LOADING_DWH_D');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMRB', 
                                             'WF_CTL_DMOUTDMRB_LOADING');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMRB', 
                                             'WF_ACTL_DM_LOADING_DWH_OTHERBANK_D');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMPP', 
                                             'wf_CTL_DMPP_LOADING_W');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_CUBERB', 
                                             'wf_CTL_CUBERB_LOADING_M');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMRB', 
                                             'WF_CTL_RBCC_LOADING_M');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMRB', 
                                             'WF_CTL_DMRB_LOADING_MOBILITY');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMRB', 
                                             'WF_REG_DMACRM_REGULAR_MOTIV_DMRB_W');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMRB', 
                                             'WF_REG_DMRB_REGULAR_DMRBIFRS_OPEX');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMRB', 
                                             'WF_REG_DMRB_LOADING_D_IDWHDBP');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMRB', 
                                             'WF_ACTL_DM_LOADING_DWH_W_wednesday');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMPP', 
                                             'WF_ACTL_DM_LOADING_DMFR_D_b');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMPP', 
                                             'wf_CTL_DMPP_LOADING_PROFITABILITY_56_PROV_M');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMRB', 
                                             'WF_ACTL_DM_LOADING_VDWH_D');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMPP', 
                                             'WF_REG_DMPP_LOADING_M');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMPP', 
                                             'WF_REG_DMPP_LOADING_AW');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMRB', 
                                             'WF_REG_DMACRM_REGULAR_PROV_M');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMRB', 
                                             'WF_ACTL_DM_LOADING_DMFRUA_D');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMRB', 
                                             'WF_ACTL_DM_LOADING_DMFR_D_a');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMRB', 
                                             'WF_ACTL_DM_LOADING_DWH_M3');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMPP', 
                                             'WF_ACTL_DM_LOADING_MAN_DETPL');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'DMCOLL_REPORTS', 
                                             'WF_ENTITY_UPDATES');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'DMCOLL_REPORTS', 
                                             'WF_COLLECTIONSUMSEB');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'DMCOLL_REPORTS', 
                                             'WF_COLLECTIONSUMSEB_BB');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'DMCOLL_REPORTS', 
                                             'WF_ELEKTRONNYI_REESTR');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'DMCOLL_REPORTS', 
                                             'WF_BADPHONES');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'DMCOLL_REPORTS', 
                                             'WF_HARDSUMSEB');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'DMCOLL_REPORTS', 
                                             'WF_INDEXES');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'DMCOLL_REPORTS', 
                                             'WF_INDEXES_BB');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'DMCOLL_REPORTS', 
                                             'WF_KOLICHESTVU_ZVONKOV_SOTRUDNIKOV_OKV_BB_DAY');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'DMCOLL_REPORTS', 
                                             'WF_KOLICHESTVU_ZVONKOV_SOTRUDNIKOV_OKV_DAY');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'DMCOLL_REPORTS', 
                                             'WF_PAYMENTSOKV');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'DMCOLL_REPORTS', 
                                             'WF_PAYMENTSOKV_BB');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'DMCOLL_REPORTS', 
                                             'WF_REESTRTOHARD');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'DMCOLL_REPORTS', 
                                             'WF_REESTRTOHARD_BB');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'DMCOLL_REPORTS', 
                                             'WF_REESTR_FOR_CKM');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'DMCOLL_REPORTS', 
                                             'WF_RSTR_RUCH_OBZVONA');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'DMCOLL_REPORTS', 
                                             'WF_RSTR_RUCH_OBZVONA_BB');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'DMCOLL_REPORTS', 
                                             'WF_ROUTERACCTCOLLSTRATEGY_CLIENT_PHONES_PROC');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMPP', 
                                             'WF_CYCLE_DMPP_RELOADING_ANY_CTL');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMRB', 
                                             'WF_CTL_DMRB_LOADING_ORS');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMRB', 
                                             'WF_ACTL_DM_LOADING_DMRWA_MAN_DLRISKW');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMRB', 
                                             'WF_REG_DMACRM_REGULAR_MOTIV_DMRB_M');
insert into l_plan.l_workflow (uk,
                               folder,
                               name) values (l_plan.l_s_action.nextval,
                                             'FLOW_CONTROL_DMRB', 
                                             'WF_REG_DMACRM_REGULAR_PROV_AW');
/
commit;
/