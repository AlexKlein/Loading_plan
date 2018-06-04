begin
    dbms_scheduler.drop_program (program_name => 'L_PLAN.EXEC_WORKFLOW');
exception
    when others then
        null;
end;
/
begin
    dbms_scheduler.create_program (program_name         => 'L_PLAN.EXEC_WORKFLOW',
                                   program_type         => 'EXECUTABLE',
                                   program_action       => '/home/oracle/run_wf.sh',
                                   number_of_arguments  => 6,
                                   enabled              => false,
                                   comments             => null);

    dbms_scheduler.define_program_argument (program_name      => 'L_PLAN.EXEC_WORKFLOW',
                                            argument_name     => 'DOMAIN',
                                            argument_position => 1,
                                            argument_type     => 'VARCHAR2',
                                            default_value     => '');

    dbms_scheduler.define_program_argument (program_name      => 'L_PLAN.EXEC_WORKFLOW',
                                            argument_name     => 'INT_SERV',
                                            argument_position => 2,
                                            argument_type     => 'VARCHAR2',
                                            default_value     => '');

    dbms_scheduler.define_program_argument (program_name      => 'L_PLAN.EXEC_WORKFLOW',
                                            argument_name     => 'USER_NAME',
                                            argument_position => 3,
                                            argument_type     => 'VARCHAR2',
                                            default_value     => '');

    dbms_scheduler.define_program_argument (program_name      => 'L_PLAN.EXEC_WORKFLOW',
                                            argument_name     => 'PASS',
                                            argument_position => 4,
                                            argument_type     => 'VARCHAR2',
                                            default_value     => '');

    dbms_scheduler.define_program_argument (program_name      => 'L_PLAN.EXEC_WORKFLOW',
                                            argument_name     => 'FOLDER',
                                            argument_position => 5,
                                            argument_type     => 'VARCHAR2',
                                            default_value     => '');

    dbms_scheduler.define_program_argument (program_name      => 'L_PLAN.EXEC_WORKFLOW',
                                            argument_name     => 'WORKFLOW',
                                            argument_position => 6,
                                            argument_type     => 'VARCHAR2',
                                            default_value     => '');

    dbms_scheduler.enable (name => 'L_PLAN.EXEC_WORKFLOW');
end;
/
