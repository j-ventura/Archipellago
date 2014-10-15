drop table if exists  Orbiter;
create table Orbiter (ObjectId int unsigned,
					  x double,
					  y double,
					  z double,
					  vx double,
					  vy double,
					  vz double,
					  NextEpoch int,
					  TimeToNext int,
					  SolarPower float,
					  primary key (ObjectId ));