--Журнал логов--
CREATE MATERIALIZED VIEW LOG ON accidents
   WITH ROWID, SEQUENCE (id, source_id, tmc_id, severety)
   INCLUDING NEW VALUES;
   
----
CREATE MATERIALIZED VIEW acc_mv
   BUILD IMMEDIATE
   REFRESH COMPLETE ON COMMIT
AS 
   SELECT id,source_id,tmc_id,
   DENSE_RANK() OVER(partition by severety ORDER BY tmc_id) rnk_dense 
   FROM accidents where severety < 4; 
select count(rnk_dense) from acc_mv group by tmc_id ;
