create or replace TRIGGER orders_before_insert
BEFORE INSERT
    ON accidents
   FOR EACH ROW   
DECLARE
   v_username varchar2(10);   
BEGIN
   -- Найти персону username, осуществляющего INSERT в таблицу
   SELECT user INTO v_username
     FROM dual;   
   -- обновить поле create_date на текущую системную дату
   :new.start_time := sysdate;   
   -- обновить поле created_by на персону username осуществившую INSERT   
   insert into user_log values(v_username, message);
END;


create or replace TRIGGER orders_before_delete
BEFORE DELETE
    ON accidents
   FOR EACH ROW   
DECLARE
   v_username varchar2(10);   
BEGIN
   -- Найти персону username, осуществляющего DELETE из таблицы accidents
   SELECT user INTO v_username
     FROM dual;   
   -- обновить поле created_by на персону username осуществившую delete   
   insert into user_log values(SYSTIMESTAMP , v_username, 'delete');
END;