drop table train;
create database railways;
use railways;
create table train(
id int,train_name varchar(20),train_type varchar(20),departure varchar(20),dept_time time);
select* from train;
insert into train  value
(1,'Rajdhani exp','premium','chennai central', '15:30:00'),
(2,'shatabdi exp','fast passenger','Bnglr central','14:30:00'),(3,'tiruchendur exp','Super fast','chennai egmore','18:00:00'),
(4,'vaigai exp','super fast','madurai','16:45:00'),(5,'duronto exp','non stop','new delhi','13:25:00');
delete from train where id=5;
describe train;
alter table train modify  dept_time  int ;
update  train set train_name='pandian exp', departure='tirunelveli'  where id=4;

