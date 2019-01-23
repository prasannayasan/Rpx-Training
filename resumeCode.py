import sqlite3

file = open("Resume.txt", 'r')
resume = file.readlines()
file.close()

arr = []
column = []
for line in resume:
    line  = line.strip()
    value = line[(line.find(":")+1):len(line)]  
    arr.append(value)

Name = arr[0]
Age = arr[1]
DOB = arr[2]
Qualification = arr[3]
Phone = arr[4]

print("Printing values From Code "Name + " "+ Age +" "+ DOB +" "+ Qualification +" "+Phone)


connection = sqlite3.connect('resume.db')

cur = connection.cursor()


cur.execute("""CREATE TABLE resume(
            Name text,
            Age integer
            DOB text,
            Qualification text,
            Phone integer
            )""")

cur.execute("INSERT INTO resume(Name,Age,DOB,Qualification,Phone)VALUES('"+Name+"','"+Age+"','"+DOB+"','"+Qualification+"','"+Phone+"')")
print("one row/s affected")

cur.execute("SELECT * FROM resume")

print(cur.fetchone()) 

connection.commit()
connection.close()

