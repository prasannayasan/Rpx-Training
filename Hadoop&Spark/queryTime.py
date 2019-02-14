import pyspark
from pyspark.sql import SparkSession
from pyspark.sql import SQLContext

spark = SparkSession .builder .appName("Python Spark SQL basic example") \
.config("spark.some.config.option", "some-value").getOrCreate()

csvFile2 = spark.read.csv("hdfs://localhost:54310/hdfs/demolarge3.csv")
csvFile2.createOrReplaceTempView("demolarge3")

startTime = time.clock()
value2 = spark.sql("SELECT * FROM demolarge3 limit 5000")
value2.show(5000)
endTime = time.clock()
print(endTime-startTime)