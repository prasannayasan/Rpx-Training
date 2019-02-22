# PostgreSQL Query :
### Student table (Demo):
CREATE TABLE students(sId int not null, name varchar(20), dept varchar(15) not null);

INSERT INTO students(sId, name, dept) VALUES('101', 'Rakesh', 'CSE');

INSERT INTO students(sId, name, dept) VALUES('102', 'Amit', 'CSE');

INSERT INTO students(sId, name, dept) VALUES('102', 'Khan', 'Civil');

INSERT INTO students(sId, name, dept) VALUES('102', 'Rahul', 'Civil');

INSERT INTO students(sId, name, dept) VALUES('102', 'Bala', 'Civil');

INSERT INTO students(sId, name, dept) VALUES('103', 'Siva', 'Mech');

INSERT INTO students(sId, name, dept) VALUES('103', 'Parthi', 'Mech');

INSERT INTO students(sId, name, dept) VALUES('104', 'Prabu', 'IT');

INSERT INTO students(sId, name, dept) VALUES('104', 'Sangee', 'IT');
#### Output :
postgres=# select * from playground;
 equip_id |  type  | color | location 
----------+--------+-------+----------
        1 | slide  | blue  | south
        3 | circle | green | east
        2 | swing  | red   | north
        5 | square | black | west
(4 rows)

### Playground Table (Primary key, default value, check):

CREATE TABLE playground(equip_id serial PRIMARY KEY, type varchar(50) NOT NULL, color varchar(25) NOT NULL,location varchar(5) check (location in ('north', 'south', 'west', 'east')));

INSERT INTO playground(type, color, location) VALUES('slide', 'blue', 'south');

INSERT INTO playground(type, color, location) VALUES('swing', 'yellow', 'north');

INSERT INTO playground(type, color, location) VALUES('square', 'black', 'west');
#### Output :
postgres=# select * from coach;
 equip_id | age |   name   | country 
----------+-----+----------+---------
        1 |  36 | Ragul    | India
        2 |  45 | ShinChan | Korea
        2 |  45 | Jachie   | china
        3 |  29 | Obama    | America
        3 |  51 | Jackson  | America
(5 rows)
### Couch Table(Foriegn key) :

CREATE TABLE coach(equip_id int REFERENCES playground(equip_id) NOT NULL, Age int NOT NULL, Name varchar(25) NOT NULL, Country varchar(20) NOT NULL);

INSERT INTO coach(equip_id, age, name, country) VALUES('1', '36', 'Ragul', 'India');

INSERT INTO coach(equip_id, age, name, country) VALUES('2', '45', 'ShinChan', 'Korea');

INSERT INTO coach(equip_id, age, name, country) VALUES('2', '45', 'Jachie', 'china');

INSERT INTO coach(equip_id, age, name, country) VALUES('3', '29', 'Obama', 'America');

INSERT INTO coach(equip_id, age, name, country) VALUES('3', '51', 'Jackson', 'America');

UPDATE playground SET colour = 'red' WHERE type = 'swing';

### History Table (Storing trigger info) :
CREATE TABLE history(Sno serial not null, TriggerInfo varchar(50) not null, TimeOfChange timestamp default current_timestamp);
#### Output :
 postgres=# select * from history;
 sno |     triggerinfo     |        timeofchange        
-----+---------------------+----------------------------
   2 | Update on the Table | 2019-02-22 20:44:14.883917
   3 | Update on the Table | 2019-02-22 20:52:30.663056
   4 | insert on the Table   | 2019-02-22 20:54:19.604195
   5 | Update on the Table | 2019-02-22 20:57:09.866425
   6 | Update on the Table | 2019-02-22 20:58:32.918595
   7 | Update on the Table | 2019-02-22 21:01:52.844197
   8 | insert on the Table    | 2019-02-22 21:03:07.233256
(7 rows)
### Trigger :
##### Update trigger :
CREATE TRIGGER update_table 
	BEFORE UPDATE ON playground
	FOR EACH ROW
	EXECUTE EXECUTE PROCEDURE when_update();
##### Update Function :
CREATE OR REPLACE  FUNCTION  when_update() 
	RETURNS trigger AS
	$BODY$   
	BEGIN
	INSERT INTO history(triggerinfo) VALUES('Update on the Table');
	RETURN NEW; END;
	$BODY$
	LANGUAGE plpgsql;

##### Insert Trigger :
 CREATE TRIGGER insert_table 
	BEFORE INSERT ON playground
	FOR EACH ROW
	EXECUTE EXECUTE PROCEDURE when_insert();
##### Insert Function :
CREATE OR REPLACE  FUNCTION  when_insert() 
	RETURNS trigger AS
	$BODY$   
	BEGIN
	INSERT INTO history(triggerinfo) VALUES('insert on the Table');
	RETURN NEW; END;
	$BODY$
	LANGUAGE plpgsql;

##### Delete Trigger :
 CREATE TRIGGER delete_table 
	BEFORE INSERT ON playground
	FOR EACH ROW
	EXECUTE EXECUTE PROCEDURE when_delete();
##### Delete Function :
CREATE OR REPLACE  FUNCTION  when_delete() 
	RETURNS trigger AS
	$BODY$   
	BEGIN
	INSERT INTO history(triggerinfo) VALUES('delete on the Table');
	RETURN NEW; END;
	$BODY$
	LANGUAGE plpgsql;
