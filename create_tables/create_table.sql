
--Создание таблицы фактов--
create table accidents(
	id 				varchar2, 
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
--Таблицы справочников--
create table country(
	country_id 		number, 
	country_name 	varchar2(100));
create table city(
	city_id 		number, 
	country_id 		number, 
	city_name 		varchar2(100), 
	timezone 		varchar2(100));
create table street(
	street_id 		number, 
	country_id 		number, 
	street_name 	varchar2(100));
create table source(
	source_id 		number, 
	source_name 	varchar(100));
create table tmc(
	tmc_id 			number, 
	tmc_value 		number);
--Таблицы Логов--
create table log_table(
	time_log 		date, 
	level_log 		varchar2(20), 
	procedure_name 	varchar2(50), 
	message 		varchar2(1000));
create table user_log(
	user_name 		varchar2(100));
