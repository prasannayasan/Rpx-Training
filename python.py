import sqlite3

connection = sqlite3.connect('resume.db')

cur = connection.cursor()

cur.execute("""CREATE TABLE resume(
            Name text,
            Age integer,
            DOB text,
            Qualification text,
            Phone integer
            )""")
cur.execute("INSERT INTO resume VALUES()")

connection.commit()
connection.close()


