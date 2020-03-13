create or replace PACKAGE BODY FILL_ACC IS
-- Процедура для записи логов --
PROCEDURE write_log (
	level_log 		IN VARCHAR2,  
	procedure_name 	IN VARCHAR2,
	message 		IN VARCHAR2
) 
IS PRAGMA AUTONOMOUS_TRANSACTION; -- включение автономных транзакций
BEGIN
	insert into log_table values (systimestamp, level_log, procedure_name, message);
	commit;
END write_log;

--Процедура для генерации данных в таблицу accidents--
PROCEDURE data_ins 
AS 
    id          varchar2(100);
    source_id   number;
    tmc_id      number;
    severity    number;
    start_time  date;
    end_time    date;
    start_lat   number;
    start_lng   number;
    end_lat     number;
    end_lng     number;
    distance    number;
    state_id_p  number;
    city_id_p   number;
    timezone_p  varchar2(100);
    street_id_p number;
    side        VARCHAR2(100);
    state_count number;
    message     varchar2(1000);
    c_min       number;
    c_max       number;
    s_min       number;
    s_max       number;
BEGIN
    LOCK TABLE ACCIDENTS IN EXCLUSIVE MODE NOWAIT;
    LOCK TABLE CITY IN EXCLUSIVE MODE NOWAIT;
    LOCK TABLE SOURCE IN EXCLUSIVE MODE NOWAIT;
    LOCK TABLE STATE IN EXCLUSIVE MODE NOWAIT;
    LOCK TABLE STREET IN EXCLUSIVE MODE NOWAIT;
    LOCK TABLE TMC IN EXCLUSIVE MODE NOWAIT;
    SELECT cast(systimestamp - INTERVAL '2' YEAR as date) into start_time from dual; 
    SELECT count(*) into state_count from state;
    for iter IN 1..100000 LOOP
       id := 'A'||iter;
       source_id := trunc(dbms_random.value(1,4));
       tmc_id := trunc(dbms_random.value(1,6));
       end_time := start_time + 2/trunc(dbms_random.value(2,4));
       start_lat := round(dbms_random.value(-90,90),6);
       start_lng := round(dbms_random.value(-180,180),6);
       end_lat := round(start_lat + dbms_random.normal/2,6);
       end_lng := round(start_lng + dbms_random.normal/2,6);
       distance := trunc(dbms_random.value(1,10));
       state_id_p := trunc(dbms_random.value(1,state_count));
       select min,max into c_min,c_max from city_mv where state_id = state_id_p; 
       city_id_p := trunc(dbms_random.value(c_min,c_max));
       select min,max into s_min,s_max from street_mv where city_id = city_id_p;
       street_id_p := trunc(dbms_random.value(s_min,s_max));
       select timezone into timezone_p from city where city_id = city_id_p;
       case true 
            when abs(trunc(dbms_random.normal)) = 1 then side := 'l';
            else side := 'r';
       end case;
       insert into accidents values(id, source_id, tmc_id, decode(trunc(dbms_random.value(1,10)), 1, 1, 2, 1, 3, 1, 4, 1,
                                                       5, 2, 6, 2, 7, 2,
                                                       8, 3,
                                                       9, 4), start_time, end_time, start_lat, start_lng, end_lat, end_lng,
                                                       distance, state_id_p, city_id_p, street_id_p, side, timezone_p);
       start_time := start_time + (end_time - start_time)*trunc(dbms_random.value(1,2));
    END LOOP;
    commit;
    EXCEPTION WHEN others THEN
    message := TO_CHAR(sqlcode)||'-'||sqlerrm||'. '||dbms_utility.format_error_backtrace;
    write_log('ERROR', 'data_ins', message);
END data_ins;
--Заполнение справочника City--
PROCEDURE fill_city
IS
    city_id     number;
    state_id    number;
    city_name   VARCHAR2(100);
    timezone    VARCHAR2(100);
    type        list_of_vowels is table of VARCHAR2(100) index by PLS_INTEGER;
    vowel       list_of_vowels;
begin
    vowel(1) := 'а';
    vowel(2) := 'e';
    vowel(3) := 'i';
    vowel(4) := 'o';
    vowel(5) := 'u';
    vowel(6) := 'y';
    city_id  := 0;
    for state_id in 1..50 loop
        timezone := 'UTC-'||TRUNC(DBMS_RANDOM.value(4,10));
        for i in 1..trunc(dbms_random.value(4,15)) loop
            city_id := city_id + 1;
            city_name := DBMS_RANDOM.STRING('U',1)||DBMS_RANDOM.STRING('L',1)||vowel(TRUNC(dbms_random.value(1,6)))
            ||DBMS_RANDOM.STRING('L', DBMS_RANDOM.VALUE(1,2))||vowel(TRUNC(dbms_random.value(1,6)))
            ||DBMS_RANDOM.STRING('L', DBMS_RANDOM.VALUE(1,2));            
            insert into city VALUES(city_id, state_id, city_name, timezone);
        end LOOP;
    end LOOP;
	commit;
end fill_city;

--Заполнение справочника Street--
PROCEDURE fill_street
IS
    street_id 	number:=0;
    city_id 	number;
    street_name VARCHAR2(1000);
    city_count 	number;
    message 	VARCHAR2(1000);
begin
    select count(*) into city_count from city;
    for city_id in 1..city_count loop
        for i in 1..trunc(dbms_random.value(50,150)) loop
            street_id := street_id + 1;
            street_name := DBMS_RANDOM.STRING('U',1)||DBMS_RANDOM.STRING('L', DBMS_RANDOM.VALUE(1,6))
            ||' '||DBMS_RANDOM.STRING('U', DBMS_RANDOM.VALUE(1,2));
            insert into street values(street_id, city_id, street_name);
        end LOOP;
    end LOOP;
	commit;
end fill_street;
--Заполнение справочника Source--
PROCEDURE fill_source
IS
begin
    insert into source values(1,'MapQuest');
    insert into source values(2,'Bing');
    insert into source values(3,'Others');
	commit;
end fill_source;
--Заполнение справочника TMC--
PROCEDURE fill_tmc
IS
begin
    insert into tmc values(1,201.0);
    insert into tmc values(2,241.0);
    insert into tmc values(3,301.0);
    insert into tmc values(4,341.0);
    insert into tmc values(5,401.0);
    insert into tmc values(6,441.0);
	commit;
end fill_tmc;
--Процедура обновления записей таблицы accidents--
PROCEDURE update_record
IS  message 	varchar2(1000);
    cursor acc_cur is select * from accidents where state_id = 43 and city_id = 453 for update nowait;
begin
    update accidents set timezone = 'UTC-5' where current of acc_cur;
    commit;
    EXCEPTION WHEN others THEN
    message := TO_CHAR(sqlcode)||'-'||sqlerrm||'. '||dbms_utility.format_error_backtrace;
    write_log('ERROR', 'update_record', message);
end update_record; 
END FILL_ACC;
