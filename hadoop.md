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
