declare
    object_not_found exception;
    pragma exception_init(object_not_found, -02289);
begin
    execute immediate ('drop sequence l_plan.l_s_action');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('Ошибка '||sqlerrm);
end;
/
create sequence l_plan.l_s_action;
/