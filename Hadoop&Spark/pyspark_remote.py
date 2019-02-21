import pyspark
from pyspark.sql import SparkSession
from pyspark.sql import SQLContext

spark = SparkSession .builder .appName("Python Spark SQL basic example") .config("spark.some.config.option", "some-value") .getOrCreate()
df_load = sparkSession.read.csv("hdfs://localhost:54310/hdfs/demolarge4.csv")

df_load.show(29693, False)
csvFile = spark.read.csv('hdfs://172.17.2.109:54310/hdfs/company.csv')
csvFile.printSchema()

csvFile.createOrReplaceTempView("company")

<<<<<<< HEAD:Hadoop&Spark/pyspark_remote.py
value = spark.sql("SELECT * FROM demolarge4 limit 50")
=======
value = spark.sql("SELECT * FROM demolarge4 limit 5")
>>>>>>> ad8e370151f7fe9ea97138c5194ab507b89fd5bd:Hadoop&Spark/pyspark_hdfs.py
value.show()
