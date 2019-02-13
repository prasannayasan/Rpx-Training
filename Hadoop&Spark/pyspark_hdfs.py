import pyspark
from pyspark.sql import SparkSession
from pyspark.sql import SQLContext

spark = SparkSession .builder .appName("Python Spark SQL basic example") .config("spark.some.config.option", "some-value") .getOrCreate()
df_load = sparkSession.read.csv("hdfs://localhost:54310/hdfs/demolarge4.csv")

df_load.show(29693, False)
csvFile = spark.read.csv('hdfs://localhost:54310/hdfs/demolarge4.csv')
csvFile.printSchema()

csvFile.createOrReplaceTempView("demolarge4")

value = spark.sql("SELECT * FROM demolarge4 limit 5")
value.show()
