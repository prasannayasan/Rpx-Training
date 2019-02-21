import pyspark
from pyspark.sql import SparkSession
from pyspark.sql import SQLContext

spark = SparkSession .builder .appName("Python Spark SQL basic example") .config("spark.some.config.option", "some-value") .getOrCreate()

sparkSession = SparkSession.builder.appName("example-pyspark-read-and-write").getOrCreate()
df_load = sparkSession.read.csv("hdfs://localhost:54310/hdfs/demolarge4.csv")

df_load.show(29693, False)
csvFile = spark.read.csv('hdfs://172.17.2.109:54310/hdfs/company.csv')
csvFile.printSchema()

csvFile.createOrReplaceTempView("company")

value = spark.sql("SELECT * FROM demolarge4 limit 50")
value.show()