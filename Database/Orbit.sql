delimiter //
create procedure orbit ()
begin

	update epoch set epoch = epoch + 1;
	
	update Orbiter set  TimeToNext = 0  where NextEpoch = (select epoch from epoch);

end;
//

delimiter ;