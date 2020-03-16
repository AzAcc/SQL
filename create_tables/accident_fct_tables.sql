
--Создание таблицы фактов--
create table accidents(
	id 			varchar2 PRIMARY KEY, 
	source_id 		number, 
	tmc_id 			number,
	severety 		number, 
	start_time 		date, 
	end_time 		date, 
	start_lat 		number, 
	start_lng 		number,
	end_lat 		number, 
	end_lng 		number, 
	distance 		number, 
	country_id 		number, 
	city_id 		number, 
	street_id 		number, 
	side 			varchar2(1 CHAR));