--Журнал логов над таблицей городов--
CREATE MATERIALIZED VIEW LOG ON CITY
   WITH ROWID, SEQUENCE (CITY_ID, STATE_ID)
   INCLUDING NEW VALUES;
   
--Диапазон id городов для каждого штата--
CREATE MATERIALIZED VIEW city_mv
   BUILD IMMEDIATE
   REFRESH COMPLETE ON COMMIT
AS 
   SELECT state_id ,min(city_id) min, max(city_id) max FROM CITY group by state_id;


-Журнал логов над таблицей улиц--
CREATE MATERIALIZED VIEW LOG ON street
   WITH ROWID, SEQUENCE (STREET_ID, CITY_ID)
   INCLUDING NEW VALUES;
   
--Диапазон id улиц для каждого города--
CREATE MATERIALIZED VIEW street_mv
   BUILD IMMEDIATE
   REFRESH COMPLETE ON COMMIT
AS 
   SELECT city_id , min(street_id) min, max(street_id) max FROM street group by city_id;