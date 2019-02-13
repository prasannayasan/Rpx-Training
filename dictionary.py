import pyspark
from pyspark import SparkContext
sc = SparkContext()
temp = sc.textFile("/home/prasanna/gowri.txt")

prints = temp.flatMap(count)
prints.take(1000)

dic = {}
def wcount(prints):
    arrsize = len(prints)
    for count in range(arrsize):
        word = prints[count].lower()
        word = unicodedata.normalize('NFKD', word).encode('ascii','ignore')
        word = = re.sub(r'[)|?|.|,|!|:|(|;|#]',r'',word)
        if word in dic:
            dic[word] += 1
        else:
            dic[word] = 1
    return dic

printlist = prints.collect()

wcount(printlist)
for d in dic:
    print(d,dic[d])