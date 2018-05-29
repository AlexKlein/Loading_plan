begin
    dbms_scheduler.drop_job (job_name => 'L_PLAN.EXEC_WORKFLOW_JOB');
exception
    when others then
        null;
end;
/
begin
    dbms_scheduler.create_job (job_name     => 'EXEC_WORKFLOW_JOB',
                                   program_name => 'EXEC_WORKFLOW',
                                   auto_drop    => false);
    
    dbms_scheduler.enable('EXEC_WORKFLOW_JOB');

    dbms_scheduler.set_job_argument_value (job_name       => 'L_PLAN.EXEC_WORKFLOW_JOB',
                                                argument_name  => 'DOMAIN',
                                                argument_value => '');

    dbms_scheduler.set_job_argument_value (job_name       => 'L_PLAN.EXEC_WORKFLOW_JOB',
                                                argument_name  => 'INT_SERV',
                                                argument_value => '');

    dbms_scheduler.set_job_argument_value (job_name       => 'L_PLAN.EXEC_WORKFLOW_JOB',
                                                argument_name  => 'USER_NAME',
                                                argument_value => '');

    dbms_scheduler.set_job_argument_value (job_name       => 'L_PLAN.EXEC_WORKFLOW_JOB',
                                                argument_name  => 'PASS',
                                                argument_value => '');

    dbms_scheduler.set_job_argument_value (job_name       => 'L_PLAN.EXEC_WORKFLOW_JOB',
                                                argument_name  => 'FOLDER',
                                                argument_value => '');

    dbms_scheduler.set_job_argument_value (job_name       => 'L_PLAN.EXEC_WORKFLOW_JOB',
                                                argument_name  => 'WORKFLOW',
                                                argument_value => '');
end;
/