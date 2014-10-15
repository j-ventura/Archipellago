create table system.objects
(
ObjectId int unsigned auto_increment primary key,
ParentId int unsigned,
TypeId smallint unsigned,
OwnerId smallint unsigned,
Orbiting bool
);