create or replace package body l_plan.meta_do_plan_pkg
/******************************* HISTORY *******************************************\
Дата        Автор            ID       Описание
----------  ---------------  -------- ----------------------------------------------------
05.05.2017  Клейн А.М.      [000000]  Создание пакета.
20,04,2018  Клейн А.М.      [000000]  Измененеие выполнения плана, создание новых обхектов
\******************************* HISTORY *******************************************/
is

-- процедура обработки исключений
    procedure my_exception
      is
    begin
        dbms_output.put_line('Ошибка '  ||chr(10)||
        dbms_utility.format_error_stack||
        dbms_utility.format_error_backtrace());
        commit;

    end my_exception;

-- процедура фиксации окончания плана
    procedure finish_plan
        is
    begin
        
        -- завершение плана
        update l_plan.l_loading_plan
        set    run_id = null
        where  run_id = vCurrentRunID;
    
        commit;
        
    exception
        when others then
            -- логирование ошибки
            make_log ('Ошибка выполнения процедуры finish_plan '||sqlcode||' '||sqlerrm);
            my_exception;
                        
    end finish_plan;
   
-- процедура архивирования логов
    procedure make_arch_logs
        is
    begin
        -- перегрузка логов в архив
        insert into l_plan.l_log_loading_arch (time_stamp,
                                               project_id,
                                               environment_id,
                                               db_um_id,
                                               domain_id,
                                               int_service_id,
                                               action_desc,
                                               user_name,
                                               action_id,
                                               run_id,
                                               workflow_run_id,
                                               workflow_start,
                                               workflow_end)
        select time_stamp,
               project_id,
               environment_id,
               db_um_id,
               domain_id,
               int_service_id,
               action_desc,
               user_name,
               action_id,
               run_id,
               workflow_run_id,
               workflow_start,
               workflow_end
        from   l_plan.l_log_loading
        where (environment_id,
               project_id,
               db_um_id,
               domain_id,
               int_service_id) in (select environment_id,
                                          project_id,
                                          db_um_id,
                                          domain_id,
                                          int_service_id
                                   from   l_plan.l_loading_plan
                                   where  run_id = vCurrentRunID);
        
        commit;
                         
        -- очистка таблицы оперативных логов
        delete from l_plan.l_log_loading
        where (environment_id,
               project_id,
               db_um_id,
               domain_id,
               int_service_id) in (select environment_id,
                                          project_id,
                                          db_um_id,
                                          domain_id,
                                          int_service_id
                                   from   l_plan.l_loading_plan
                                   where  run_id = vCurrentRunID);
            
        commit;
            
    exception
        when others then  
            -- логирование ошибки
            make_log ('Ошибка выполнения процедуры make_arch_logs '||sqlcode||' '||sqlerrm);
            my_exception;
            
    end make_arch_logs;

-- процедура ручного архивирования лога падения
    procedure make_arch_fall (pRunID    number,
                              pActionID number)
        is
    begin
        -- перегрузка логов в архив
        insert into l_plan.l_log_loading_arch (time_stamp,
                                               project_id,
                                               environment_id,
                                               db_um_id,
                                               domain_id,
                                               int_service_id,
                                               action_desc,
                                               user_name,
                                               action_id,
                                               run_id,
                                               workflow_run_id,
                                               workflow_start,
                                               workflow_end)
        select time_stamp,
               project_id,
               environment_id,
               db_um_id,
               domain_id,
               int_service_id,
               action_desc,
               user_name,
               action_id,
               run_id,
               workflow_run_id,
               workflow_start,
               workflow_end
        from   l_plan.l_log_loading
        where  action_desc like 'Падение плана%' and
               action_id = pActionID and
               run_id    = pRunID;
        
        commit;
                         
        -- очистка таблицы оперативных логов
        delete from l_plan.l_log_loading
        where  action_desc like 'Падение плана%' and
               action_id = pActionID and
               run_id    = pRunID;
            
        commit;
            
    exception
        when others then  
            -- логирование ошибки
            make_log ('Падение плана'||chr(10)||
                      'Номер текущего плана '||pRunID||chr(10)||
                      'Номер переносимого действия '||pActionID||chr(10)||
                      'Ошибка выполнения процедуры make_arch_fall '||sqlcode||' '||sqlerrm);
            my_exception;
            
    end make_arch_fall;

-- процедура ручного архивирования лога выполняемых действий
    procedure make_arch_run (pRunID    number,
                             pActionID number)
        is
    begin
        -- перегрузка логов в архив
        insert into l_plan.l_log_loading_arch (time_stamp,
                                               project_id,
                                               environment_id,
                                               db_um_id,
                                               domain_id,
                                               int_service_id,
                                               action_desc,
                                               user_name,
                                               action_id,
                                               run_id,
                                               workflow_run_id,
                                               workflow_start,
                                               workflow_end)
        select time_stamp,
               project_id,
               environment_id,
               db_um_id,
               domain_id,
               int_service_id,
               action_desc,
               user_name,
               action_id,
               run_id,
               workflow_run_id,
               workflow_start,
               workflow_end
        from   l_plan.l_log_loading
        where  action_desc like 'Выполнение действия' and
               action_id = pActionID and
               run_id    = pRunID;
        
        commit;
                         
        -- очистка таблицы оперативных логов
        delete from l_plan.l_log_loading
        where  action_desc like 'Выполнение действия' and
               action_id = pActionID and
               run_id    = pRunID;
            
        commit;
            
    exception
        when others then  
            -- логирование ошибки
            make_log ('Падение плана'||chr(10)||
                      'Номер текущего плана '||pRunID||chr(10)||
                      'Номер переносимого действия '||pActionID||chr(10)||
                      'Ошибка выполнения процедуры make_arch_run '||sqlcode||' '||sqlerrm);
            my_exception;
            
    end make_arch_run;
    
-- процедура логирования
    procedure make_log (pMsg varchar2)
    is
        vProject_id     number;  -- проект
        vEnvironment_id number;  -- среда запуск
        vDB_um_id       number;  -- УМ запуска
        vDomain_id      number;  -- домен IPC
        vInt_service_id number;  -- интеграционный сервис
    begin
        -- выбор параметров среды на которой выполняется план
        select distinct
               environment_id,
               project_id,
               db_um_id,
               domain_id,
               int_service_id
        into   vEnvironment_id,
               vProject_id,
               vDB_um_id,
               vDomain_id,
               vInt_service_id
        from   l_plan.l_loading_plan lp
        where  run_id    = vCurrentRunID and
               action_id = vCurrentActionID;
                   
        -- вставка записи в лог плана
        insert into l_plan.l_log_loading (time_stamp,
                                          project_id,
                                          environment_id,
                                          db_um_id,
                                          domain_id,
                                          int_service_id,
                                          action_desc,
                                          user_name,
                                          action_id,
                                          run_id,
                                          workflow_run_id,
                                          workflow_start) values (systimestamp,
                                                                  vProject_id,
                                                                  vEnvironment_id,
                                                                  vDB_um_id,
                                                                  vDomain_id,
                                                                  vInt_service_id,
                                                                  pMsg,
                                                                  vUserName,
                                                                  vCurrentActionID,
                                                                  vCurrentRunID,
                                                                  vCurrentWFrunID,
                                                                  vCurrentWFstart);
        commit;
    
    exception
        when others then
            my_exception;
                                                                        
    end make_log;

-- процедура выбора папок и названий потоков
    procedure get_workflow (pWorkflowUK in  number,
                            pFolder     out varchar2,
                            pWorkflow   out varchar2)
        is
    begin
        
        -- выбор папки и потока
        select folder,
               name
        into   pFolder,
               pWorkflow
        from   l_plan.l_workflow
        where  uk = pWorkflowUK;      
        
    exception
        when others then
            -- логирование ошибки
            make_log ('Падение плана'||chr(10)||
                      'Ошибка выполнения процедуры get_workflow при выборе папки и названия потока'||chr(10)||
                      'с ошибкой '||sqlcode||' '||sqlerrm);
            
            -- выставление пустых значений запуска
            select '' as folder,
                   '' as workflow
            into   pFolder,
                   pWorkflow
            from   dual;
            my_exception;
            
    end get_workflow;

-- процедура проверки зависимостей
    procedure check_depends (pRunID       in  number,
                             pActionID    in  number,
                             pRepSchema   in  varchar2,
                             pDbUmCcode   in  varchar2,
                             pLogMsg      out varchar2)
    is
        -- курсор типов подписок зависимостей
        cursor cSubS (p_run_id number,
                      p_action_id number)
            is
        select row_number () over (partition by sub.action_id 
               order by sub.type_id, sub.dependency_ccode) as rn,
               nvl(sub.type_id,0) as type_id,   
               sub.dependency_ccode,
               case
                   when max(lg.action_id) is null then
                       'N'
                   else
                       'Y'
               end as existing_flag,
               substr(sub.dependency_ccode,1,
               instr(sub.dependency_ccode,'~')-1) as folder,
               substr(sub.dependency_ccode, 
               instr(sub.dependency_ccode,'~')+1) as workflow
        from   dual
        left outer join (select dep.type_id,
                                dep.dependency_ccode,
                                sub.action_id
                         from   l_plan.l_dependency_subscriber sub
                         inner join l_plan.l_dependency dep
                                 on sub.dependency_id = dep.id
                         inner join l_plan.l_dependency_type typ
                                 on dep.type_id = typ.id
                         where  sub.action_id = p_action_id) sub 
                     on  1 = 1
        left outer join l_plan.l_log_loading lg
                     on lg.run_id    = p_run_id    and
                        lg.action_id = p_action_id and
                        lg.workflow_run_id is not null
        group by sub.action_id, 
                 sub.type_id,
                 sub.dependency_ccode
        order by nvl(sub.type_id,0);
                     
        vFlag varchar2(5);           -- флаг разрешения запуска
        
        type CurTyp is ref cursor;   -- тип курсор для динамического SQL
        cCursorSubs CurTyp;          -- курсор для проверки подписки
        cCursorTxt  varchar2(4000);  -- текст запроса проверки подписки
        
        
    begin
        
        -- выбираем подписки зависимостей действия
        for l in cSubS(pRunID,
                       pActionID) loop
                
            -- проверка на запуск пункта плана
            if l.existing_flag = 'Y' then
                -- установка флага запрета
                if pLogMsg is null then 
                    -- листинг проверок пустой
                    pLogMsg := 'Записи по этому действию есть в логе'||chr(10)||
                               'Запуск ****запрещен****'; 
                else 
                    -- в листинге проверок уже есть записи
                    pLogMsg := pLogMsg||chr(10)||chr(10)||chr(10)||
                               'Записи по этому действию есть в логе'||chr(10)||
                               'Запуск ****запрещен****';
                end if;
                
            end if;
            
            -- зависимостей нет
            if    l.type_id = 0 then
                        
                -- установка флага разрешения
                if pLogMsg is null then 
                    -- листинг проверок пустой
                    pLogMsg := 'Зависимость в списке действия номер '||l.rn||chr(10)||
                               'Тип зависимостей - 0 (без зависимостей)'||chr(10)||
                               'Запуск ****разрешен****'; 
                else 
                    -- в листинге проверок уже есть записи
                    pLogMsg := pLogMsg||chr(10)||chr(10)||chr(10)||
                               'Зависимость в списке действия номер '||l.rn||chr(10)||
                               'Тип зависимостей - 0 (без зависимостей)'||chr(10)||
                               'Запуск ****разрешен****';
                end if;
                           
                               
            -- зависимость на окончание WF
            elsif l.type_id = 1 then
                        
                -- сборка запроса к подпискам
                cCursorTxt := 
                    'select case '||chr(10)||
                    '           when max(ld.as_of_day) is null then '||chr(10)||
                    '               ''NULL'' '||chr(10)||
                    '           when max(ld.as_of_day)-max(mas.as_of_day) = 0 then '||chr(10)|| 
                    '               ''Y'' '||chr(10)||
                    '           else '||chr(10)||
                    '               ''N'' '||chr(10)||
                    '       end as is_finish_flag '||chr(10)||
                    'from   dual '||chr(10)||
                    'left outer join loading@'||pDbUmCcode||' ld '||chr(10)||
                    '             on folder_name   = '''||l.folder||'''   and '||chr(10)||
                    '                workflow_name = '''||l.workflow||''' and '||chr(10)||
                    '                end_dttm is not null '||chr(10)||
                    'left outer join (select max(as_of_day) as as_of_day '||chr(10)||
                    '                 from as_of_day@'||pDbUmCcode||') mas '||chr(10)||
                    '             on 1 = 1 '||chr(10)||
                    'group by folder_name, '||chr(10)||
                    '         workflow_name';
                        
                -- запуск запроса к подписка
                open cCursorSubs for cCursorTxt;
                        
                -- выбор флага запуска
                fetch cCursorSubs into vFlag;
                    
                -- закрытие запроса к подпискам
                close cCursorSubs;
                    
                -- проверка флага разрешения запуска
                if    vFlag = 'NULL' then
                
                    -- установка флага запрета
                    if pLogMsg is null then 
                        -- листинг проверок пустой
                        pLogMsg := 'Зависимость в списке действия номер '||l.rn||chr(10)||
                                   'Тип зависимостей - 1 (зависимость на завершение работы потока)'||chr(10)||
                                   'Зависимость на завершение потока '||l.dependency_ccode||chr(10)||
                                   'В УМ никогда небыло запусков данного потока '||chr(10)||
                                   'Запуск ****запрещен****';
                    
                    else 
                        -- в листинге проверок уже есть записи
                        pLogMsg := pLogMsg||chr(10)||chr(10)||chr(10)||
                                   'Зависимость в списке действия номер '||l.rn||chr(10)||
                                   'Тип зависимостей - 1 (зависимость на завершение работы потока)'||chr(10)||
                                   'Зависимость на завершение потока '||l.dependency_ccode||chr(10)||
                                   'В УМ никогда небыло запусков данного потока '||chr(10)||
                                   'Запуск ****запрещен****';
                    end if;
                    
                elsif vFlag = 'Y'    then

                    -- установка флага разрешения
                    if pLogMsg is null then 
                        -- листинг проверок пустой
                        pLogMsg := 'Зависимость в списке действия номер '||l.rn||chr(10)||
                                   'Тип зависимостей - 1 (зависимость на завершение работы потока)'||chr(10)||
                                   'Зависимость на завершение потока '||l.dependency_ccode||chr(10)||
                                   'Запуск ****разрешен****';
                    else 
                        -- в листинге проверок уже есть записи
                        pLogMsg := pLogMsg||chr(10)||chr(10)||chr(10)||
                                   'Зависимость в списке действия номер '||l.rn||chr(10)||
                                   'Тип зависимостей - 1 (зависимость на завершение работы потока)'||chr(10)||
                                   'Зависимость на завершение потока '||l.dependency_ccode||chr(10)||
                                   'Запуск ****разрешен****';
                    end if;
                    
                else

                    -- установка флага запрета
                    if pLogMsg is null then 
                        -- листинг проверок пустой
                        pLogMsg := 'Зависимость в списке действия номер '||l.rn||chr(10)||
                                   'Тип зависимостей - 1 (зависимость на завершение работы потока)'||chr(10)||
                                   'Зависимость на завершение потока '||l.dependency_ccode||chr(10)||
                                   'Запуск ****запрещен****';
                    
                    else 
                        -- в листинге проверок уже есть записи
                        pLogMsg := pLogMsg||chr(10)||chr(10)||chr(10)||
                                   'Зависимость в списке действия номер '||l.rn||chr(10)||
                                   'Тип зависимостей - 1 (зависимость на завершение работы потока)'||chr(10)||
                                   'Зависимость на завершение потока '||l.dependency_ccode||chr(10)||
                                   'Запуск ****запрещен****';
                    end if;
                    
                end if;
                    
            -- зависимость на время
            elsif l.type_id = 2 then
                        
                -- сборка запроса к подпискам
                cCursorTxt := 
                    'select case '||chr(10)||
                    '           when (sysdate - dtime) >= 0 then '||chr(10)|| 
                    '               ''Y'' '||chr(10)||
                    '           else '||chr(10)||
                    '               ''N'' '||chr(10)||
                    '       end as is_finish_flag '||chr(10)||
                    'from  (select case '||chr(10)||
                    '                  when length(dependency_ccode) < 8 then '||chr(10)||
                    '                       to_date(to_char(sysdate, ''dd.mm.yyyy'')|| '||chr(10)||
                    '                       dep.dependency_ccode, '||chr(10)|| 
                    '                     ''dd.mm.yyyy hh24:mi'') '||chr(10)||
                    '                  else '||chr(10)||
                    '                      to_date(dep.dependency_ccode, ''dd.mm.yyyy hh24:mi'') '||chr(10)||
                    '              end as dtime '||chr(10)||
                    '       from   l_plan.l_dependency_subscriber sub '||chr(10)||
                    '       inner join l_plan.l_dependency dep '||chr(10)||
                    '               on sub.dependency_id = dep.id '||chr(10)||
                    '       where  sub.action_id = '||pActionID||')';
                        
                -- запуск запроса к подписка
                open cCursorSubs for cCursorTxt;
                        
                -- выбор флага запуска
                fetch cCursorSubs into vFlag;
                    
                -- закрытие запроса к подпискам
                close cCursorSubs;
                    
                -- проверка флага разрешения запуска
                if vFlag = 'Y' then
                    
                    -- установка флага разрешения
                    if pLogMsg is null then 
                        -- листинг проверок пустой
                        pLogMsg := 'Зависимость в списке действия номер '||l.rn||chr(10)||
                                   'Тип зависимостей - 2 (зависимость на время запуска потока)'||chr(10)||
                                   'Зависимость на дату/время '||l.dependency_ccode||chr(10)||
                                   'Запуск ****разрешен****';
                    else 
                        -- в листинге проверок уже есть записи
                        pLogMsg := pLogMsg||chr(10)||chr(10)||chr(10)||
                                   'Зависимость в списке действия номер '||l.rn||chr(10)||
                                   'Тип зависимостей - 2 (зависимость на время запуска потока)'||chr(10)||
                                   'Зависимость на дату/время '||l.dependency_ccode||chr(10)||
                                   'Запуск ****разрешен****';
                    end if;
                    
                else
                    
                    -- установка флага запрета
                    if pLogMsg is null then 
                        -- листинг проверок пустой
                        pLogMsg := 'Зависимость в списке действия номер '||l.rn||chr(10)||
                                   'Тип зависимостей - 2 (зависимость на время запуска потока)'||chr(10)||
                                   'Зависимость на дату/время '||l.dependency_ccode||chr(10)||
                                   'Запуск ****запрещен****';
                    else 
                        -- в листинге проверок уже есть записи
                        pLogMsg := pLogMsg||chr(10)||chr(10)||chr(10)||
                                   'Зависимость в списке действия номер '||l.rn||chr(10)||
                                   'Тип зависимостей - 2 (зависимость на время запуска потока)'||chr(10)||
                                   'Зависимость на дату/время '||l.dependency_ccode||chr(10)||
                                   'Запуск ****запрещен****';
                    end if;
                    
                end if;   
                    
            -- зависимость на завершение пункта плана
            elsif l.type_id = 3 then

                -- сборка запроса к подпискам
                cCursorTxt := 
                    'select case '||chr(10)||
                    '           when wf.run_status_code = 1 then '||chr(10)|| 
                    '               ''Y'' '||chr(10)||
                    '           else '||chr(10)||
                    '               ''N'' '||chr(10)||
                    '       end as is_finish_flag '||chr(10)||
                    'from  dual '||chr(10)||
                    'left outer join '||pRepSchema||'.opb_wflow_run@'||pDbUmCcode||' wf '||chr(10)||
                    '             on 1 = 1 and '||chr(10)||
                    '                wf.end_time is not null and '||chr(10)||
                    '                wf.workflow_run_id in (select workflow_run_id '||chr(10)||
                    '                                       from   l_plan.l_log_loading '||chr(10)||
                    '                                       where  run_id = '||pRunID||' and '||chr(10)||
                    '                                              action_id = '||l.dependency_ccode||' and '||chr(10)||
                    '                                              workflow_run_id is not null)';
                        
                -- запуск запроса к подписка
                open cCursorSubs for cCursorTxt;
                        
                -- выбор флага запуска
                fetch cCursorSubs into vFlag;
                
                -- закрытие запроса к подпискам
                close cCursorSubs;
                    
                -- проверка флага разрешения запуска
                if vFlag = 'Y' then
                    
                    -- установка флага разрешения
                    if pLogMsg is null then 
                        -- листинг проверок пустой
                        pLogMsg := 'Зависимость в списке действия номер '||l.rn||chr(10)||
                                   'Тип зависимостей - 3 (зависимость на завершение работы пункта плана)'||chr(10)||
                                   'Зависимость на пункт плана '||l.dependency_ccode||chr(10)||
                                   'Запуск ****разрешен****';
                    else 
                        -- в листинге проверок уже есть записи
                        pLogMsg := pLogMsg||chr(10)||chr(10)||chr(10)||
                                   'Зависимость в списке действия номер '||l.rn||chr(10)||
                                   'Тип зависимостей - 3 (зависимость на завершение работы пункта плана)'||chr(10)||
                                   'Зависимость на пункт плана '||l.dependency_ccode||chr(10)||
                                   'Запуск ****разрешен****';
                    end if;
                    
                else
                    
                    -- установка флага запрета
                    if pLogMsg is null then 
                        -- листинг проверок пустой
                        pLogMsg := 'Зависимость в списке действия номер '||l.rn||chr(10)||
                                   'Тип зависимостей - 3 (зависимость на завершение работы пункта плана)'||chr(10)||
                                   'Зависимость на пункт плана '||l.dependency_ccode||chr(10)||
                                   'Запуск ****запрещен****';
                    
                    else 
                        -- в листинге проверок уже есть записи
                        pLogMsg := pLogMsg||chr(10)||chr(10)||chr(10)||
                                   'Зависимость в списке действия номер '||l.rn||chr(10)||
                                   'Тип зависимостей - 3 (зависимость на завершение работы пункта плана)'||chr(10)||
                                   'Зависимость на пункт плана '||l.dependency_ccode||chr(10)||
                                   'Запуск ****запрещен****';
                    
                    end if;
                                   
                end if;
                
            end if;
             
        end loop;
    
    exception
        when others then
            -- логирование ошибки
            make_log ('Падение плана'||chr(10)||
                      'Ошибка выполнения процедуры check_depends'||chr(10)||
                      'с ошибкой ' ||sqlcode||' '||sqlerrm||chr(10)||
                      'Во время проверки зависимостей');
            my_exception;
                
    end check_depends;

-- процедура проверки завершения работы потоков
    procedure check_wf_end (pIntServiceCcode varchar2,
                            pDbUmCcode       varchar2)
    is
        type CurTyp is ref cursor;   -- тип курсор для динамического SQL
        cCursorRun  CurTyp;          -- курсор для выбора ID потока
        cCursorRTxt varchar2(4000);  -- текст запроса для выбора ID потока
        
        vWFrunID    number;          -- ID запущенного потока
        vWFendTime  date;            -- дата завершения потока
    begin
        -- выбор ID потока информатики для вставки в лог
        cCursorRTxt := 'select wf.workflow_run_id, '||chr(10)||
                       '       wf.end_time '||chr(10)||
                       'from   '||replace(lower(pIntServiceCcode),'int','rep')||'.opb_wflow_run@'||pDbUmCcode||'   wf '||chr(10)||
                       'inner join '||replace(lower(pIntServiceCcode),'int','rep')||'.opb_subject@'||pDbUmCcode||' subj '||chr(10)||
                       '        on subj.subj_id = wf.subject_id '||chr(10)||
                       'where  wf.end_time is not null and '||chr(10)||
                       '       wf.run_status_code = 1  and '||chr(10)||
                       '       workflow_run_id in (select distinct workflow_run_id '||chr(10)||
                       '                           from   l_plan.l_log_loading '||chr(10)||
                       '                           where  workflow_run_id is not null and '||chr(10)||
                       '                                  workflow_end    is null)';
        
        -- запуск запроса к метаданным информатики
        open cCursorRun for cCursorRTxt;
        
        loop
            -- выход из петли после последней строки курсора
            exit when cCursorRun%notfound;
            
            -- выбор ID и времени завершения потока
            fetch cCursorRun into vWFrunID,
                                  vWFendTime;
            
            update l_plan.l_log_loading
            set    workflow_end    = vWFendTime
            where  workflow_run_id = vWFrunID;
            
            commit; 
            
        end loop;
        
        -- закрытие запроса к метаданным информатики 
        close cCursorRun;
    
    exception
        when others then
            -- логирование ошибки
            make_log ('Падение плана'||chr(10)||
                      'Ошибка выполнения процедуры check_wf_end '||chr(10)||
                      'с ошибкой ' ||sqlcode||' '||sqlerrm);
            my_exception;
    
    end check_wf_end;

-- процедура запуска параметров
    procedure exec_param (pParameterUK in  number,
                          pDbUmCcode   in  varchar2,
                          pFailFalg    out varchar2) 
    is
        vSQL varchar2(4000);  -- текст параметра
    begin
        -- выбор текста скрипта параметра
        vSQL := get_parameter(pParameterUK);
                                
        -- замена параметра db_link на заданный
        vSQL := replace(vSQL,'*DB_UM*',pDbUmCcode);
                                    
        -- замена всех параметров
        for i in (select var.param_name,
                         varv.param_value 
                  from   l_plan.l_variable_value varv
                  inner join l_plan.l_variable   var
                          on varv.param_id = var.id
                  where (varv.environment_id,
                         varv.project_id,
                         varv.domain_id,
                         varv.int_service_id) in (select environment_id,
                                                         project_id,
                                                         domain_id,
                                                         int_service_id
                                                  from   l_plan.l_loading_plan
                                                  where  run_id = vCurrentRunID)
                  order by var.param_name) loop
                                                  
            if vSQL like '%*'||i.param_name||'*%' then
                                            
                vSQL := replace(vSQL,'*'||i.param_name||'*',i.param_value);
                                            
            end if;
                                        
        end loop;
                                
        -- проверка наличия параметра
        if vSQL is not null then
                                    
            -- логирование установки параметров
            make_log ('Запуск скрипта выставления параметров '||chr(10)||
                      'для потока без зависимостей '||chr(10)||
                      vSQL);
                                    
            -- запуск установки параметров
            execute immediate (vSQL);
                                    
        end if;
                         
        commit;
        
        -- падения не было при запуске параметров
        pFailFalg := 'N';
        
    exception
        when others then
            -- установка флага падения
            pFailFalg := 'Y';
            -- логирование ошибки
            make_log ('Падение плана'||chr(10)||
                      'Ошибка выполнения процедуры exec_param '||chr(10)||
                      'Во время выставления параметров'||chr(10)||
                      'с ошибкой ' ||sqlcode||' '||sqlerrm);
            my_exception;
            
    end exec_param;

-- процедура запуска потоков
    procedure exec_workflow (pFolder          varchar2,
                             pWorkflow        varchar2,
                             pDomainCode      varchar2,
                             pDomainUsr       varchar2,
                             pDomainPass      varchar2,
                             pIntServiceCcode varchar2,
                             pDbUmCcode       varchar2)
    is

        type CurTyp is ref cursor;   -- тип курсор для динамического SQL
        cCursorRun  CurTyp;          -- курсор для выбора ID потока
        cCursorRTxt varchar2(4000);  -- текст запроса для выбора ID потока
        
    begin
        
        -- выставление параметров
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',1,pDomainCode);
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',2,pIntServiceCcode);
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',3,pDomainUsr);
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',4,pDomainPass);
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',5,pFolder);
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',6,pWorkflow);
                                
        -- запуск потока
        dbms_scheduler.run_job('EXEC_WORKFLOW_JOB');
                                
        -- защитная очистка параметров
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',5,'');
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',6,'');
                            
        -- выбор ID потока информатики для вставки в лог
        cCursorRTxt := 'select wf.workflow_run_id, '||chr(10)||
                       '       wf.start_time '||chr(10)||
                       'from   '||replace(lower(pIntServiceCcode),'int','rep')||'.opb_wflow_run@'||pDbUmCcode||'   wf '||chr(10)||
                       'inner join '||replace(lower(pIntServiceCcode),'int','rep')||'.opb_subject@'||pDbUmCcode||' subj '||chr(10)||
                       '        on subj.subj_id = wf.subject_id '||chr(10)||
                       'where  end_time is null and '||chr(10)||
                       '       subj.subj_name = '''||pFolder||''' and '||chr(10)||
                       '       wf.workflow_name = '''||pWorkflow||'''';
        
        -- очистка ID и даты запуска потока в информатике
        vCurrentWFrunID := null;
        vCurrentWFstart := null;
        
        -- запуск запроса к метаданным информатики
        open cCursorRun for cCursorRTxt;
                            
        -- выбор ID потока
        fetch cCursorRun into vCurrentWFrunID,
                              vCurrentWFstart;
        
        -- закрытие запроса к метаданным информатики 
        close cCursorRun;
                            
        -- логирование запуска потока
        make_log ('Выполнение действия');
                                
        commit;             
    
    exception
        when others then
            -- логирование ошибки
            make_log ('Падение плана'||chr(10)||
                      'Ошибка выполнения процедуры exec_workflow '||chr(10)||
                      'Во время запуска потока'||chr(10)||
                      'с ошибкой ' ||sqlcode||' '||sqlerrm);
            my_exception;
                     
    end exec_workflow;

-- процедура подготовки плана
    procedure prepare_plan (pEnvironmentID number,
                            pProjectID     number,
                            pDbUmID        number,
                            pDomainID      number,
                            pIntServiceID  number)
    is
        vRun_ID number;  -- номер плана
    begin
        
        -- выбор нового номера плана
        vRun_ID := l_plan.l_s_run.nextval;
    
        -- установка уникального ID плана для запуска потоком
        update l_plan.l_loading_plan
        set    run_id = vRun_ID
        where  environment_id = pEnvironmentID and
               project_id     = pProjectID     and
               db_um_id       = pDbUmID        and
               domain_id      = pDomainID      and
               int_service_id = pIntServiceID;
               
        commit;                             
        
    exception
        when others then
            -- логирование ошибки
            make_log ('Ошибка выполнения процедуры prepare_plan '||chr(10)||
                      'с ошибкой ' ||sqlcode||' '||sqlerrm);
            my_exception;
    
    end prepare_plan;
    
-- процедура запуска плана загрузок
    procedure do_plan (pUserName varchar2 default 'ETL_USER')
    is
        -- курсор последовательных действий плана
        cursor cToDoList 
            is
        select distinct 
               act.parameter_uk,
               act.workflow_uk,
               lp.action_id,
               lp.run_id,
               lp.environment_id,
               lp.project_id,
               lp.db_um_id,
               lp.domain_id,
               lp.int_service_id
        from   l_plan.l_action act
        inner join l_plan.l_loading_plan lp
                on lp.action_id = act.id
        where((lp.action_id,
               lp.run_id) not in (select distinct 
                                         lg.action_id,
                                         lg.run_id
                                  from   l_plan.l_log_loading lg
                                  where (lg.action_desc  like 'Выполнение действия' and 
                                         lg.workflow_end is not null)               or
                                         lg.action_desc  like 'Падение плана%')     or
              (lp.action_id,
               lp.run_id) in (select distinct 
                                     lg.action_id,
                                     lg.run_id
                              from   l_plan.l_log_loading lg
                              where  lg.workflow_run_id is not null and 
                                     lg.workflow_start  is not null and
                                     lg.workflow_end    is null)) and
               lp.run_id is not null
        order by lp.environment_id,
                 lp.project_id,
                 lp.db_um_id,
                 lp.domain_id,
                 lp.int_service_id,
                 lp.run_id,
                 lp.action_id;
        
        vDomain_ccode      varchar2(50);  -- домен для запуска
        vDomain_user       varchar2(50);  -- LogIn из под которого будет запуск
        vDomain_pass       varchar2(50);  -- пароль для запуска
        vInt_service_ccode varchar2(50);  -- интеграционный сервис
        vDB_Um_ccode       varchar2(50);  -- УМ
        
        vWFlog    varchar2(255);          -- лог запускаемого шедулера
        vFail     varchar2(1);            -- флаг падения процедуры выставления параметров 
        vFinish   varchar2(1);            -- флаг окончания работы плана
        vJobFlag  varchar2(1);            -- флаг наличия Job запуска потоков
        vLogMsg   varchar2(4000);         -- текст прохождения подписок
        
        vFolder   varchar2(50);           -- папка запуска потока
        vWorkflow varchar2(50);           -- запускаемый поток
        
        exNoJob   exception;              -- пользовательское исключение отсутствия Job
        -- инициализация пользовательского исключения
        pragma exception_init(exNoJob, -20001);

    begin
        -- очистка переменных, чтобы не происходили ложные запуски
        vWFlog   := null;
        vFail    := null;
        vFinish  := null;
        vJobFlag := null;
        vLogMsg  := null;
        
        vFolder   := null;
        vWorkflow := null;
        
        -- проверка наличия job для запуска потоков
        select case
                   when count(1) > 0 then
                       'Y'
                   else
                       'N'
               end as JobFlag
        into   vJobFlag
        from   all_scheduler_jobs
        where  lower(owner)    = 'l_plan' and
               lower(job_name) = 'exec_workflow_job';
        
        if vJobFlag != 'Y' then
            
            -- вызов пользовательского исключения об отсутствии job
            --raise_application_error(-20001, 'Отсутствие Job, нет возиможности выполнить план');
            -- создание job
            dbms_scheduler.create_job(job_name     => 'EXEC_WORKFLOW_JOB',
                                          program_name => 'EXEC_WORKFLOW',
                                          auto_drop    => false);
            dbms_scheduler.enable('EXEC_WORKFLOW_JOB');
            
            make_log ('Создание Job');
            
        end if;
        
        -- очистка параметров процедуры запуска потоков
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',1,'');
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',2,'');
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',3,'');
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',4,'');
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',5,'');
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',6,'');
        
        -- выполнение действий планов
        for r in cToDoList loop
        
            -- установка переменных запуска 
            vCurrentRunID    := r.run_id;
            vCurrentActionID := r.action_id;
            vUserName        := pUserName;
            
            -- сбор кодов параметров запуска
            select ccode,
                   user_name,
                   user_pass
            into   vDomain_ccode,
                   vDomain_user,
                   vDomain_pass
            from   l_plan.l_domain
            where  id = r.domain_id;
            
            select ccode
            into   vInt_service_ccode
            from   l_plan.l_int_service
            where  id = r.int_service_id;
            
            select ccode
            into   vDB_Um_ccode
            from   l_plan.l_db_um
            where  id = r.db_um_id;
            
            -- выставления завершения пунктов планов
            check_wf_end (vInt_service_ccode,
                          vDB_Um_ccode);
            
            -- проверка зависимостей запусков
            check_depends (r.run_id,
                           r.action_id,
                           replace(lower(vInt_service_ccode),'int','rep'),
                           vDB_Um_ccode,
                           vLogMsg);
            
            -- проверка разрешений запуска
            if lower(vLogMsg) not like '%****запрещен****%' then 
                
                -- выбор папки и потока
                get_workflow(r.workflow_uk,
                             vFolder,
                             vWorkflow);
                                 
                -- логирование прохождение проверок
                make_log ('Проверки пройдены, готовится запуск потока '||vFolder||'.'||vWorkflow);
                    
                -- выбор папки и потока
                get_workflow(r.workflow_uk,
                             vFolder,
                             vWorkflow);
                    
                -- установка параметров
                if r.parameter_uk is not null then
                                    
                    exec_param (r.parameter_uk,
                                vDB_Um_ccode,
                                vFail);
                               
                end if;
                                
                -- проверка на наличие потока запуска
                if vFolder   is not null and
                   vWorkflow is not null and
                   nvl(vFail, 'N') = 'N' then
                                
                    -- логирование запуска потока
                    make_log ('Запуск потока '||vFolder||'\'||vWorkflow);
                                    
                    -- запуск потока
                    exec_workflow (vFolder,
                                   vWorkflow,
                                   vDomain_ccode,
                                   vDomain_user,
                                   vDomain_pass,
                                   vInt_service_ccode,
                                   vDB_Um_ccode);
                                       
                    -- очистка номера и даты потока
                    vCurrentWFrunID := null;
                    vCurrentWFstart := null;
                                                   
                -- нет потока
                else
                    -- логирование запуска потока
                    make_log ('Запуск потока '||vFolder||'\'||vWorkflow||' невозможен');
                                
                end if;
                                    
                commit;
            
            end if;
        
            -- формирование флага завершения плана
            select case
                       when count(action_id) = 0 then
                           'Y'
                       else
                           'N'
                   end
            into   vFinish
            from  (select distinct action_id 
                   from   l_plan.l_loading_plan
                   where  run_id = r.run_id
                   minus
                   select distinct action_id
                   from   l_plan.l_log_loading
                   where  environment_id = r.environment_id and
                          project_id     = r.project_id     and
                          db_um_id       = r.db_um_id       and
                          domain_id      = r.domain_id      and
                          int_service_id = r.int_service_id and
                          action_desc not like 'Падение плана%'  and
                          action_desc like 'Выполнение действия' and
                          not exists (select distinct 1 
                                      from   l_plan.l_log_loading
                                      where  environment_id = r.environment_id and
                                             project_id     = r.project_id     and
                                             db_um_id       = r.db_um_id       and
                                             domain_id      = r.domain_id      and
                                             int_service_id = r.int_service_id and
                                             workflow_run_id is not null and
                                             workflow_end    is null));
                          
            -- проверка завершение плана
            if vFinish = 'Y' then
                
                -- логирование завершения плана
                make_log ('Завершение плана '||r.run_id);
                
                -- отправка логов в архив
                make_arch_logs;
                
                -- завершение плана
                finish_plan;
                
            end if;

        end loop;
        
        commit;
        
        -- очистка параметров процедуры запуска потоков
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',1,'');
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',2,'');
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',3,'');
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',4,'');
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',5,'');
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',6,'');
        
    exception
        when exNoJob then
            make_log ('Ошибка '||sqlcode||' '||sqlerrm);
            
        when others then  
            make_log ('Падение плана'||chr(10)||
                      'Ошибка выполнения процедуры do_plan'||chr(10)||
                      'с ошибкой '||sqlcode||' '||sqlerrm);
            my_exception;
            
    end do_plan;

-- функция выбора скрипта параметра
    function get_parameter (pParameterUK number) return varchar2
    as
        res varchar2(4000);
    begin
        
        -- выбор текста параметра
        select param_desc
        into   res
        from   l_plan.l_parameter
        where  uk = pParameterUK;
        
        -- возврат текста
        return res;
        
    exception
        when others then
            -- логирование ошибки
            make_log ('Падение плана'||chr(10)||
                      'Ошибка выполнения функции get_parameter '||chr(10)||
                      'При выборе параметра в плане'||chr(10)||
                      'с ошибкой ' ||sqlcode||' '||sqlerrm);
            my_exception;
            return '';
            
    end get_parameter;

end meta_do_plan_pkg;
/
