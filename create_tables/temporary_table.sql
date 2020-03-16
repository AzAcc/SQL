--Создание таблицы коордитан аварий в штате 1--
CREATE GLOBAL TEMPORARY 
TABLE coor_state_1   
ON COMMIT PRESERVE ROWS    
AS SELECT ID,start_lat,end_lat,start_lng, end_lng FROM accidents WHERE state_id = 1;