import pyspark
from pyspark.sql import SparkSession
from pyspark.sql import SQLContext

spark = SparkSession .builder .appName("Python Spark SQL basic example") \
.config("spark.some.config.option", "some-value").getOrCreate()

<<<<<<< HEAD
csvFile2 = spark.read.csv("hdfs://172.17.2.109:54310/demo/company.csv")
csvFile2.createOrReplaceTempView("company")

startTime = time.clock()
value2 = spark.sql("SELECT * FROM company limit 50")
value2.show(5000)
endTime = time.clock()
print(endTime-startTime)
=======
csvFile2 = spark.read.csv("hdfs://localhost:54310/hdfs/demolarge3.csv")
csvFile2.createOrReplaceTempView("demolarge3")

startTime = time.clock()
value2 = spark.sql("SELECT * FROM demolarge3 limit 5000")
value2.show(5000)
endTime = time.clock()
print(endTime-startTime)
>>>>>>> ad8e370151f7fe9ea97138c5194ab507b89fd5bd
