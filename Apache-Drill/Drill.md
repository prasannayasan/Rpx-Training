# APACHE DRILL
### INSTALLATION :

Complete the following steps to install Drill:
- In a terminal window, change to the directory where you want to install Drill.
Download the latest version of Apache Drill here or from the Apache Drill mirror site with the command appropriate for your system:
```
wget http://apache.mirrors.hoobly.com/drill/drill-1.15.0/apache-drill-1.15.0.tar.gz
curl -o apache-drill-1.15.0.tar.gz
```
- Extract the contents of the Drill .tar.gz file. Use sudo if necessary:
```
tar -xvzf <.tar.gz file name>
```
- The extraction process creates an installation directory containing the Drill software.
- At this point, you can start Drill.
```
cd apache-drill-<version>
```
- Issue the following command to launch Drill in embedded mode:
```
bin/drill-embedded
```
- The message of the day followed by the 0: jdbc:drill:zk=local> prompt appears.

### Drill Config :
- Enter into localhost:8047
- Click on storage plugin and change the below information.
  { "connection": "hdfs://<IP_Addr>:<port>/" }
      
### OPERATIONS IN DRILL :
- And :
      SELECT name FROM dfs.`/home/prasanna/prasanna/Python-workspace/html.json` where mark1=70 and mark2=80 ;
- Select for 1st table : 
     SELECT * FROM dfs.`/home/prasanna/prasanna/Python-workspace/html.json`;
- Select for 2st table : 
     SELECT * FROM dfs.`/home/prasanna/prasanna/Python-workspace/css.json`;
- < > : 
     SELECT name FROM dfs.`/home/prasanna/prasanna/Python-workspace/html.json` where mark1=70 and mark2>60 ;	
     SELECT name,ID,addr FROM dfs.`/home/prasanna/prasanna/Python-workspace/html.json` where mark1<90 and mark2>50 ;
- || (concat) :   
     SELECT name,ID,addr||pincode FROM dfs.`/home/prasanna/prasanna/Python-workspace/html.json` where mark1<90 and mark2>50;
- Between : 
     SELECT name,ID,addr FROM dfs.`/home/prasanna/prasanna/Python-workspace/html.json` where mark1 between 50 and 100 ;
- Join : 
     SELECT tbl1.id, tbl1.name, tbl2.father, tbl2.mother FROM dfs.`/home/prasanna/prasanna/Python-workspace/html.json` as tbl1 join dfs.`/home/prasanna/prasanna/Python-workspace/css.json` as tbl2 on tbl1.id = tbl2.id;
- OR -  QUERY :
      Select * from  dfs.`/home/prasanna/prasanna/Python-workspace/html.json` where mark1=60 or mark2=60 or mark3=60;
- LIKE : QUERY :
      Select * from  dfs.`/home/prasanna/prasanna/Python-workspace/html.json` where  addr like '2%';
- ORDER BY - QUERY :
      Select * from  dfs.`/home/prasanna/prasanna/Python-workspace/html.json` orderby  mark3; (ERROR - give space)
- SUM - QUERY :
      Select sum(mark1) from  dfs.`/home/prasanna/prasanna/Python-workspace/html.json`;
- COUNT - QUERY ;
      Select count(mark1) from  dfs.`/home/prasanna/prasanna/Python-workspace/html.json` where mark1>60;
