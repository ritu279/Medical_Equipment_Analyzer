create database medical_equipment_db;
use medical_equipment_db;

select * from medical_device_data limit 10;

describe medical_device_data;

--- data cleaning

-- check for missing values
select 
	count(*) as total_rows,
	sum(Device_Type is null) as missing_devices,
    sum(Maintenance_cost is null) as missing_cost,
    sum(Downtime is null) as missing_downtime
from medical_device_data;

-- remove duplicate records
create table clean_medical_device_data as 
select distinct * from medical_device_data;
drop table medical_device_data;
alter table clean_medical_device_data rename to medical_device_data;

-- check wrong data types
alter table medical_device_Data
modify Maintenance_Cost Decimal(10,2),
modify Downtime Float,
modify Age INT;

-- check for negative or wrong values 
select* from medical_device_data
where Maintenance_Cost<0 or Downtime <0 or age<0;

delete from medical_device_data
where Maintenance_Cost<0 or Downtime<0 or Age<0;

-- standardize text values
update medical_device_Data
set Device_Type=upper(Device_Type);

-- final clean data check 
select 
	count(*) as total_records,
    avg(Maintenance_cost) as avg_cost,
    avg(Downtime) as avg_downtime
from medical_device_data;

-- analysis of the dataset 

-- total records and devices 
select 
	count(*) as total_recods,
    count(distinct Device_ID) as total_devices
from medical_device_data;

-- average maintenance cost by device type
select Device_Type,round(avg(Maintenance_cost),2) as avg_maintenance_cost from medical_device_data
group by Device_Type
order by avg_maintenance_cost desc;

-- device with highest failures
select Device_Type,sum(Failure_Event_Count) as total_failures from medical_device_data
group by Device_Type
order by total_failures desc;

-- downtime analysis
select Device_Type,round(avg(Downtime),2) as avg_downtime from medical_device_data
group by Device_Type
order by avg_downtime desc;


-- maintenance frequency vs failure
select Maintenance_Frequency,round(avg(Failure_Event_Count),2) as avg_failures from medical_device_data
group by Maintenance_Frequency
order by Maintenance_Frequency;

-- maintenance class impact
select Maintenance_Class,count(*) as total_records,round(avg(Downtime),2) as avg_downtime from medical_device_data
group by Maintenance_CLass;

-- highest cost devices
select Device_Type,round(max(Maintenance_cost),2) as max_cost from medical_device_data
group by Device_Type
order by max_cost desc;

-- cost vs age
select age,round(avg(Maintenance_Cost),2) as avg_cost from medical_device_data
group by age
order by age;

-- KPI summary Query
select
	count(distinct Device_ID) as total_devices,
    round(avg(Maintenance_Cost),2) as avg_cost,
    round(avg(Downtime),2) as avg_downtime,
    sum(Failure_Event_Count) as total_failures
from medical_device_data
