delimiter //

drop procedure populate//

create procedure populate ()
begin
	declare working int default 0;
	declare epo int;
	declare x,y,z,vx,vy,vz double;
	declare eccentricity,semi_major_axis,inclination,longitude_asc_node,argument_perigee,mean_anomaly_0 double;
	declare n0,mu,eca,e1,ceca,seca,xw,yw,edot,xdw,ydw,cw,sw,co,so,ci,si,swci,cwci,px,py,pz,qx,qy,qz,m double;
	
	DECLARE done INT DEFAULT FALSE;
	DECLARE NewObjects CURSOR FOR SELECT ObjectId  FROM Objects where Orbiting is null;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	Open NewObjects;

	simple_loop: loop

		fetch NewObjects into working;

		if done = true then
			LEAVE simple_loop;
		end if;

		set eccentricity = rand()*0.5;
		set semi_major_axis = rand()*1.49e11*60+0.5e11;
		set inclination = rand()*pi()/16;
		set longitude_asc_node = rand()*2*pi();
		set argument_perigee = rand()*2*pi();
		set mean_anomaly_0 = 0;
		set epo =  (select epoch + 5 from epoch) ;

		begin
		   declare diff double default 10000;
		   declare eps double default 0.00001;
		   set mu = 1.32712440018e20;

		   set eca = mean_anomaly_0 + eccentricity/2;

		   while (diff > eps) do

			set e1 = eca-(eca-eccentricity*Sin(eca)-mean_anomaly_0)/(1-eccentricity*Cos(eca));

			set diff = abs(e1-eca);

			set eca = e1;

		   end while;

		   set ceca=Cos(eca);

		   set seca=Sin(eca);

		   set e1 = semi_major_axis*Sqrt(1-eccentricity*eccentricity);

		   set xw = semi_major_axis*(ceca-eccentricity);

		   set yw = e1*seca;

		   set edot = Sqrt(mu/semi_major_axis)/(semi_major_axis*(1-eccentricity*ceca));

		   set xdw = -semi_major_axis*edot*seca;

		   set ydw = e1*edot*ceca;

		   

		   set cw = Cos(argument_perigee); 

		   set sw = Sin(argument_perigee);

		   set co = Cos(longitude_asc_node);

		   set so = Sin(longitude_asc_node);

		   set ci = Cos(inclination); 

		   set si = Sin(inclination);

		   set swci = sw*ci;

		   set cwci = cw*ci;

		   set px = cw*co-so*swci;

		   set py = cw*so+co*swci;

		   set pz = sw*si;

		   set qx = -sw*co-so*cwci;

		   set qy = -sw*so+co*cwci;

		   set qz = cw*si;

		   

		   set x = xw*px + yw*qx;

		   set y = xw*py + yw*qy; 

		   set z = xw*pz + yw*qz;

		   set vx = xdw*px + ydw*qx;

		   set vy = xdw*py + ydw*qy; 

		   set vz = xdw*pz + ydw*qz;

		  end;

		insert into Orbiter values (working,x,y,z,vx,vz,vz,epo,0,1361 * pow(1.4960e11 / pow(x*x+y*y+z*z,0.5),2));
		Update Objects set orbiting = true where objectid = working;

		set working = working + 1;
	end loop simple_loop;

	Close NewObjects;
end;
//

delimiter ;