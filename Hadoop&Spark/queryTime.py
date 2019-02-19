import pyspark
from pyspark.sql import SparkSession
from pyspark.sql import SQLContext

spark = SparkSession .builder .appName("Python Spark SQL basic example") \
.config("spark.some.config.option", "some-value").getOrCreate()

csvFile2 = spark.read.csv("hdfs://172.17.2.109:54310/demo/company.csv")
csvFile2.createOrReplaceTempView("company")

startTime = time.clock()
value2 = spark.sql("SELECT * FROM company limit 50")
value2.show(5000)
endTime = time.clock()
print(endTime-startTime)
