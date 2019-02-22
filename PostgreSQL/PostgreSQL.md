# PostgreSQL :
 Postgresql is an open source object-relational database management system with an emphasis on extensibility and standards compliance. It can handle workloads ranging from small single-machine applications to large Internet-facing applications with many concurrent users.
### Installation on Ubuntu 18.04 :
- Update the system : ```sudo apt update```
- Install Postgresql : ```sudo apt install postgresql postgresql-contrib```
### PostgreSQL Roles and Databases :
- Switching Over to the postgres Account : ```sudo -i -u postgres```
- Access Postgres prompt immediately by typing : ```psql```
- Exit PostgreSQL prompt by typing : ```\q```
This will bring you back to the postgres Linux command prompt.

##### Accessing a Postgres Prompt Without Switching Accounts
- Single command psql as postgres user with sudo : ```sudo -u postgres psql```
- Exit Postgres session by typing : ```\q```
### Creating a New Role :
- Logged in as the postgres : ```createuser --interactive```
- Instead, prefer to use sudo for each command : ```sudo -u postgres createuser --interactive```
##### Output :
- Enter name of role to add: ```prasanna```
- Shall the new role be a superuser? (y/n) ```y```
- Can get more control by passing some additional flags : ```man createuser```
### Creating a New Database
- Logged as postgres account, type something like : ```createdb sammy```
- Instead, prefer to use sudo for each command : ```sudo -u postgres createdb sammy```
### Creating Tables :
- CREATE TABLE playground(equip_id serial PRIMARY KEY, type varchar(50) NOT NULL, color varchar(25) NOT NULL,location varchar(5) check (location in ('north', 'south', 'west', 'east')));
- CREATE TABLE coach(equip_id int REFERENCES playground(equip_id) NOT NULL, Age int NOT NULL, Name varchar(25) NOT NULL, Country varchar(20) NOT NULL);
### Inserting data into Tables :
- INSERT INTO coach(equip_id, age, name, country) VALUES('1', '36', 'Ragul', 'India');
- INSERT INTO playground(type, color, location) VALUES('swing', 'yellow', 'north');
### Updating data on Tables :
- UPDATE playground SET colour = 'red' WHERE type = 'swing';
### Deleting Columns from Table :
- ALTER TABLE playground DROP Country;