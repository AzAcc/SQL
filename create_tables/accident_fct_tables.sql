
--Создание таблицы фактов--
create table accidents(
	id 				number PRIMARY KEY, 
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
	state_id 		number, 
	city_id 		number, 
	street_id 		number, 
	side 			varchar2(1 CHAR),
	timezone		varchar2(30 BYTE));