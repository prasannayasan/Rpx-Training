# Apache Hadoop 
   Hadoop is a collection of open-source software utilities that facilitate using a network of many computers to solve problems involving massive amounts of data and computation.
### Installing Java
- To get started, we'll update our package list:
```
sudo apt-get update
```
- Next, we'll install OpenJDK, the default Java Development Kit on Ubuntu 16.04.
```
sudo apt-get install default-jdk
```
- Once the installation is complete, let's check the version.
```
java -version
```
### Installing Hadoop
```
wget https://dist.apache.org/repos/dist/release/hadoop/common/hadoop-2.7.3/hadoop-2.7.3.tar.gz.mds
```
Use tab-completion or substitute the correct version number in the command below:
```
tar -xzvf hadoop-2.7.3.tar.gz
```
Finally, we'll move the extracted files into /usr/local, the appropriate place for locally installed software. Change the version number, if needed, to match the version you downloaded.
```
sudo mv hadoop-2.7.3 /usr/local/hadoop
```
With the software in place, we're ready to configure its environment.

### Configuring Hadoop's Java Home
Hadoop requires that you set the path to Java, either as an environment variable or in the Hadoop configuration file.
To find the default Java path :
```
readlink -f /usr/bin/java | sed "s:bin/java::"
```
To begin, open hadoop-env.sh:
```
sudo nano /usr/local/hadoop/etc/hadoop/hadoop-env.sh
```
#### Running Hadoop
Now we should be able to run Hadoop:
```
/usr/local/hadoop/bin/hadoop
```
### Hadoop Operation Modes
Once you have downloaded Hadoop, you can operate your Hadoop cluster in one of the three supported modes :
- Local/Standalone Mode − After downloading Hadoop in your system, by default, it is configured in a standalone mode and can be run as a single java process.

- Pseudo Distributed Mode − It is a distributed simulation on single machine. Each Hadoop daemon such as hdfs, yarn, MapReduce etc., will run as a separate java process. This mode is useful for development.

- Fully Distributed Mode − This mode is fully distributed with minimum two or more machines as a cluster. We will come across this mode in detail in the coming chapters.

### Configration on xml:
##### Core-site.xml :-
<configuration>
<property>
<name>hadoop.tmp.dir</name>
  <value>/app/hadoop/tmp</value>
  <description>A base for other temporary directories.</description>
</property>
<property>
 <name>fs.default.name</name>
  <value>hdfs://localhost:54310</value>
   <description>The name of the default file system.  A URI whose scheme and authority determine the FileSystem implementation.  The uri’s scheme determines the config property (fs.SCHEME.impl) naming the FileSystem implementation class.  The uri’s authority is used to determine the host, port, etc. for a filesystem.</description>
</property>
</configuration>

##### Hdfs-site.xml:-
<configuration>
	<property>
      <name>dfs.replication</name>
      <value>1</value>
   </property>
   <property>
      <name>dfs.namenode.name.dir</name>
      <value>/home/hadoop/hadoopinfra/hdfs/namenode </value>
   </property>
   <property>
      <name>dfs.datanode.data.dir</name> 
      <value>/home/hadoop/hadoopinfra/hdfs/datanode </value> 
   </property>
</configuration>

##### mapred-site.xml:-
<configuration>
	<property> 
      <name>mapreduce.framework.name</name>
      <value>yarn</value>
   </property>
</configuration>

##### yarn-site.xml:-
<configuration>
	<property>
      <name>yarn.nodemanager.aux-services</name>
      <value>mapreduce_shuffle</value>
   </property>
</configuration>

##### hdfs-env.sh:-
- export HADOOP_OPTS="-Djava.net.preferIPv4Stack=true
- export HADOOP_OS_TYPE=${HADOOP_OS_TYPE:-$(uname -s)}

- export HADOOP_OPTS="--add-modules java.activation" -> paste inside namenodes tab.

##### .bashrc :-
- export HADOOP_HOME=/usr/local/hadoop
- export PATH=$PATH:$HADOOP_HOME/bin

- export HADOOP_MAPRED_HOME=$HADOOP_HOME
- export HADOOP_COMMON_HOME=$HADOOP_HOME
- export HADOOP_HDFS_HOME=$HADOOP_HOME
- export YARN_HOME=$HADOOP_HOME
- export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
- export HADOOP_INSTALL=$HADOOP_HOME
- export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib" 

#### Access commands :-
- When access id denied,to give permission : ```sudo chmod -R 777 /home/hadoop```
- To view alll ports : ```netstat```
- To view all operation : ``````ssh -vvv account@your-ip```
- To remove exixting key : ```rm -rf ~/.ssh```
- To generate ssh : ```ssh-keygen```
- Save the key : ```sudo cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys```
- To view status : ```ssh localhost```
- To display the running nodes : ```jps```

#### HDFS : 
		
- Create HDFS : hadoop fs -mkdir <paths>
- Display files : hadoop fs -ls <args>
- Upload hdfs :  hadoop fs -put <localsrc> ... <HDFS_dest_Path>
- Donload Hdfs :  hadoop fs -get <hdfs_src> <localdst>
- View content : hadoop fs -cat /user/saurzcode/dir1/abc.txt
- View last lines : hadoop fs -tail <path[filename]>
- Len of file :  hadoop fs -du <path>
- Remove file :  hadoop fs -rm <arg>
- Copy from source to destination : hadoop fs -cp /user/saurzcode/dir1/abc.txt /user/saurzcode/dir2
- Move from source to destination : hadoop fs -mv /user/saurzcode/dir1/abc.txt /user/saurzcode/dir2
- source to destination :  hadoop fs -mv <src> <dest>
- CopyFromLocal : hadoop fs -copyFromLocal /home/saurzcode/abc.txt  /user/saurzcode/abc.txt
- CopyToLocal :  hadoop fs -copyToLocal [-ignorecrc] [-crc] URI <localdst>
