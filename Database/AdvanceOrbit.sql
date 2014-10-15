drop TRIGGER AdvanceOrbit ;

delimiter //
CREATE TRIGGER AdvanceOrbit 
BEFORE UPDATE 
ON Orbiter
FOR EACH ROW
begin
	declare pos double;
	declare multiplyer int default 10;

	set pos = pow( old.x*old.x + old.y*old.y + old.z*old.z , 1.5);

	set new.x = old.x + old.vx * old.TimeToNext * multiplyer;
	set new.y = old.y + old.vy * old.TimeToNext * multiplyer;
	set new.z = old.z + old.vz * old.TimeToNext * multiplyer;

	set new.vx = old.vx + (-1.32712440018e20) * old.x * old.TimeToNext * multiplyer / pos;
	set new.vy = old.vy + (-1.32712440018e20) * old.y * old.TimeToNext * multiplyer / pos;
	set new.vz = old.vz + (-1.32712440018e20) * old.z * old.TimeToNext * multiplyer / pos;

	set new.TimeToNext = 3000000 / (pow( new.vx * new.vx + new.vy * new.vy + new.vz * new.vz , 0.5) * multiplyer);
	set new.NextEpoch = old.NextEpoch + new.TimeToNext;

	set new.SolarPower =  1361 * pow(1.4960e11 / pos,2);
	
end//

delimiter ;
