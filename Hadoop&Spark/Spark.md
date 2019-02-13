# Apache Spark 
    Apache Spark is an open-source distributed general-purpose cluster-computing framework.
### Installing Apache Spark on Ubuntu :
##### Java check:
- Check Java Version : ```java -version```
- If not available install Java.

##### Install Scala:
- Run to install : ```sudo apt-get install scala```
- Type scala into your terminal : ```Scala```
- You can then quit the Scala REPL with :  ```:q``` or ```ctrl + z```

##### Install Spark:
- To install Spark, we need git for it : ```sudo apt-get install git```
- Download Spark and untar it : 
 ```sudo tar xvf spark-2.3.1-bin-hadoop2.7.tgz -C /usr/local/spark```
- Add Spark path to bash file : ```nano ~/.bashrc```

##### Config Spark:
- Add below code snippet to the bash file
 ```SPARK_HOME=/usr/local/spark``` & ```export PATH=$SPARK_HOME/bin:$PATH```
- Execute below command after editing the bashsrc : ```source ~/.bashrc```
- Go to the Bin Directory and execute the spark shell : ```./spark-shell```
- To Start both master and slave node execute below command : ```./Start-all.sh```
- The web ui will be available at 8080 port.