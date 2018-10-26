

/*** Populating data of dash_tech_bay*/

DELIMITER $$

DROP PROCEDURE IF EXISTS `TechDayUtil` $$


CREATE PROCEDURE `TechDayUtil`(
  IN startDate datetime,
  IN enddate datetime)
BEGIN
	

	DECLARE v_finished INTEGER DEFAULT 0;
	DECLARE technician_idd,tech_day_utill INTEGER DEFAULT 0;
	
   
   
    DEClARE tech_cursor CURSOR FOR 
   select technician_id,sum(TIMESTAMPDIFF(minute, technician_starttime, technician_endtime)) as  tech_day_util from autoscope.job_demandcodes where date(created_at) BETWEEN  startDate AND  endDate and technician_starttime is not null or technician_endtime is  not null  and job_demandcodes.repair_status = 'closed' group by job_demandcodes.technician_id;
    
	
    DECLARE CONTINUE HANDLER 
    FOR NOT FOUND SET v_finished = 1;
	
	OPEN tech_cursor;
 
    get_tech: LOOP
 
	FETCH tech_cursor INTO technician_idd,tech_day_utill;
             
	IF v_finished = 1 THEN 
	LEAVE get_tech;
	END IF;
 
	INSERT INTO dash_tech_bay (day,week,month,year,tech_id,tech_util_time,tech_availale_time,created_at ) VALUES (DAYOFMONTH(startDate),( WEEK(startDate)+1), MONTH(startDate), YEAR(startDate), technician_idd ,tech_day_utill,8,now());        
          
	END LOOP get_tech;
 
   CLOSE tech_cursor;
 
END $$
DELIMITER ;



/*** Populating data of dash_sa_jobs*/

DELIMITER $$

DROP PROCEDURE IF EXISTS `autoscope`.`DashSaJobProc` $$
CREATE PROCEDURE `autoscope`.`DashSaJobProc`(
  IN startDate datetime,
  IN endDate datetime
  )
BEGIN
  DECLARE finished INTEGER DEFAULT 0;
  DECLARE jobsCount INTEGER DEFAULT 0;
  DECLARE createdBy  INTEGER DEFAULT 0;
  DECLARE service INTEGER DEFAULT 0;
  DECLARE appointmentType text; 
DECLARE DashSaJobProc_cursor CURSOR FOR  select   count(*) as jobsCount,J.created_by  as createdBy, J.service_id as service,A.atype_desc as appointmentType
FROM autoscope.jobs J left outer join autoscope.appointment_types A on J.appoint_type_id =  A.atype_id   
where date(created_at) BETWEEN startDate AND endDate GROUP BY J.service_id , J.created_by , A.atype_id ;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

open  DashSaJobProc_cursor;

saJobs: LOOP
FETCH DashSaJobProc_cursor INTO jobsCount, createdBy, service,appointmentType;

IF finished = 1 THEN
LEAVE saJobs;
END IF;

insert into `autoscope`.`dash_sa_jobs` (day,week,month,year,j_count,sa_id,s_type_id,app_type_desc,created_at ) values (DAYOFMONTH(startDate),WEEK(startDate)+1, MONTH(startDate), YEAR(startDate),jobsCount,createdBy,service,appointmentType,now());  
END LOOP saJobs;

CLOSE DashSaJobProc_cursor;
END $$
DELIMITER $$;


/*** Populating data of dash_day_level */
DELIMITER $$

DROP PROCEDURE IF EXISTS `DailyDataForCron` $$
CREATE PROCEDURE `DailyDataForCron`(
  IN startDate datetime,
  IN endDate datetime,
  OUT carServiced INT,
  OUT sameDayDel INT,
  OUT vehBacklog INT,
  OUT deltimeVarSumMin INT,
  OUT deltimeVarCntMin INT,
  OUT deltimeVarSumDay INT,
  OUT idleLayOvertime INT,
  OUT actDelivery INT,
  OUT schDelivery INT,
  OUT deliverytimeVariance FLOAT,
  OUT day int,
  OUT week int,
  OUT month int,
  OUT year int
  )
BEGIN


 SELECT  count(job_id)
 INTO carServiced
 FROM autoscope.jobs   
 where date(created_at) BETWEEN startDate AND endDate;
 
 SELECT  count(job_id)
 INTO sameDayDel
 FROM autoscope.jobs   
 where date(actual_delivery) = date(expected_delivery) and
 date(created_at) BETWEEN startDate AND endDate;
  
 SELECT  count(job_id)
 INTO vehBacklog
 FROM autoscope.jobs 
 where date(expected_delivery) BETWEEN startDate AND endDate
 and status ='ONGOING';
 
 select sum(CASE WHEN (timestampdiff(MINUTE,expected_delivery,actual_delivery)>0) 
 THEN timestampdiff(MINUTE,expected_delivery,actual_delivery) ELSE 0 end )
 INTO deltimeVarSumMin
 FROM autoscope.jobs
 where date(actual_delivery) BETWEEN startDate AND endDate;
 
 select count(timestampdiff(MINUTE,expected_delivery,actual_delivery)>0)  
 INTO deltimeVarCntMin
 FROM autoscope.jobs
 where date(actual_delivery) BETWEEN startDate AND endDate;
 
 select sum(CASE WHEN (timestampdiff(DAY,expected_delivery,actual_delivery)>0) 
 THEN timestampdiff(DAY,expected_delivery,actual_delivery) ELSE 0 end)
 INTO deltimeVarSumDay
 FROM autoscope.jobs
 where date(actual_delivery) BETWEEN startDate AND endDate;
 
 SELECT bmark_val 
 INTO idleLayOvertime
 FROM autoscope.benchmarks
 where bmark_name='DayLayOverIdleTime' and bmark_unit='Hours';
 
 SELECT count(job_id) 
 INTO actDelivery
 FROM autoscope.jobs  
 where date(actual_delivery) BETWEEN startDate AND endDate;
 
 select count(job_id) 
 INTO schDelivery
 FROM autoscope.jobs  
 where date(expected_delivery) BETWEEN startDate AND endDate;
 
 set deliverytimeVariance = schDelivery * deltimeVarSumDay * 60;
 set day = DAYOFMONTH(startDate);
 set week = WEEK(startDate)+1;
 set month = MONTH(startDate);
 set year = YEAR(startDate);

 insert into `dash_day_level` 
(day,week,month,year,same_day_delivery,car_serviced,vehicle_backlog,del_car_closed,del_time_variance,act_delivery,sch_delivery,created_at)
VALUES 
(@day,@week,@month,@year,IFNULL(@sameDayDel,0),@carServiced,@vehBacklog,@deltimeVarCntMin,@deliverytimeVariance,@actDelivery,@schDelivery,now());
 

END $$
DELIMITER ;

/*** Populating data of dash_bay_util*/

DELIMITER $$

DROP PROCEDURE IF EXISTS `DashBayUtil` $$


CREATE PROCEDURE `DashBayUtil`(
  IN startDate datetime,
  IN enddate datetime)
BEGIN
	

	DECLARE v_finished INTEGER DEFAULT 0;
	DECLARE v_bay_id,v_bayutil_sum INTEGER DEFAULT 0;
	DECLARE v_bay_type_id, v_bayProdQuery INTEGER DEFAULT 0;
   
   
    DEClARE bayUtil_cursor CURSOR FOR 
   select bay_id,sum(bayutil) from(select jq.bay_id , sum(case when jq.status ='Closed' and timestampdiff(MINUTE,picked_at,completed_at)>0  then (timestampdiff(MINUTE,picked_at,completed_at)) else 0 end ) + sum( case when jq.status ='InProgress' and timestampdiff(MINUTE,picked_at,CONCAT('2018-02-09',' ','18:00:00'))>0 then (timestampdiff(MINUTE,picked_at,CONCAT('2018-02-09',' ','18:00:00'))) else 0 end ) as bayutil from autoscope.job_queues jq,autoscope.bays B  where date(created_at) BETWEEN  '2018-02-09' AND '2018-04-09'  AND   B.bay_id = jq.bay_id AND B.bay_desc NOT LIKE '%Incoming' group by jq.bay_id union select jq.bay_id, sum(case when jq.status ='InProgress' and timestampdiff(MINUTE,picked_at,CONCAT('2018-02-09',' ','18:00:00'))>0  then (timestampdiff(MINUTE,picked_at,CONCAT('2018-02-09',' ','18:00:00'))) else 0 end ) + sum( case when jq.status ='Closed' and timestampdiff(MINUTE,CONCAT('2018-02-09',' ','18:00:00'),completed_at)>0  then (timestampdiff(MINUTE,CONCAT('2018-02-09',' ','18:00:00'),completed_at)) else 0 end ) as bayutil from autoscope.job_queues jq,autoscope.bays B  where date(created_at) <  '2018-02-09'  and B.bay_id = jq.bay_id AND B.bay_desc NOT LIKE '%Incoming' group by jq.bay_id)a group by bay_id ;
    
	
    DECLARE CONTINUE HANDLER 
    FOR NOT FOUND SET v_finished = 1;
	
	OPEN bayUtil_cursor;
    get_tech: LOOP
 
	FETCH bayUtil_cursor INTO v_bay_id,v_bayutil_sum;
             
	IF v_finished = 1 THEN 
	LEAVE get_tech;
	END IF;
 
	select bay_type_id into v_bay_type_id from autoscope.bays where bay_id=v_bay_id;
	select count(*) into v_bayProdQuery from autoscope.job_queues where status ='Closed' and date(completed_at) = endDate  and bay_id =v_bay_id;
	INSERT INTO dash_bay_util 
	(
	day,week,month,year,bay_id,btype_id,b_available_time,b_used_time,b_prod,created_at)
	VALUES 
	(DAYOFMONTH(startDate),( WEEK(startDate)+1), MONTH(startDate), YEAR(startDate),v_bay_id,v_bay_type_id,8,v_bayutil_sum,v_bayProdQuery,now());        
          
	END LOOP get_tech;
 
   CLOSE bayUtil_cursor;
 
END $$
DELIMITER ;


***********  Indu Gumber 07/05/18* ************



/*** Populating data of dash_pend_delv*/

USE `autoscope`;
DROP procedure IF EXISTS `DashPendDelv`;

DELIMITER $$
USE `autoscope`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `DashPendDelv`(
IN startDate datetime,
IN enddate datetime)
BEGIN
    DECLARE v_regd_no TEXT;
    DECLARE v_model_name TEXT;
   DECLARE v_car_in_time DATETIME;
   DECLARE v_owner_name TEXT;
   DECLARE v_s_type TEXT;
   DECLARE v_sa_name TEXT;
   DECLARE v_ow_phone BIGINT;
   
   
   DECLARE v_finished INTEGER DEFAULT 0;
   
   DEClARE tech_cursor CURSOR FOR
    SELECT  c.customer_name AS owner_name,c.phone AS customer_phone, CONCAT(u.first_name, ' ', u.last_name) AS service_adviser_name, ms.service_desc AS service_type, v.regd_no AS regd_no,vmv.model_desc AS model_name, j.created_at AS car_in_time FROM autoscope.jobs j JOIN autoscope.vehicles v ON j.vehicle_id = v.vehicle_id JOIN autoscope.model_services ms ON j.service_id = ms.service_id JOIN customers c ON c.customer_id = v.customer_id JOIN users u ON j.created_by = u.user_id JOIN vehicles_models_variants vmv ON v.variant_id = vmv.variant_id WHERE j.status != 'Closed' AND j.status !='Cancelled' AND DATE(j.expected_delivery) = startDate AND (DATE(j.actual_delivery) !=enddate OR DATE(j.actual_delivery) is null);    
   DECLARE CONTINUE HANDLER
   FOR NOT FOUND SET v_finished = 1;
   
   
   OPEN tech_cursor;
   get_tech : LOOP
   
   FETCH tech_cursor INTO v_owner_name,v_ow_phone,v_sa_name,v_s_type,v_regd_no,v_model_name,v_car_in_time;
   
   IF v_finished = 1 THEN
   LEAVE get_tech;
   END IF;
   
   INSERT INTO dash_pend_delv(regd_no, model_name, car_in_time, owner_name, s_type, sa_name, ow_phone, created_at)
   VALUES (v_regd_no,v_model_name,v_car_in_time,v_owner_name,v_s_type,v_sa_name,v_ow_phone,now());
   
   END LOOP get_tech;

 CLOSE tech_cursor;
   
END$$

DELIMITER ;

***********  Shreenidhi Shastry 15/05/18  ************