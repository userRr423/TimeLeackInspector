import os
import sqlite3
from datetime import datetime

con  = sqlite3.connect('C:/Users/ДНС/AppData/Local/Google/Chrome/User Data/Default/History')
cur = con.cursor()
#cur.execute("select url, title, visit_count, last_visit_time from urls")

cur.execute("""SELECT url, title, visit_count, last_visit_time, datetime(last_visit_time / 1000000 + (strftime('%s', '1601-01-01')), 'unixepoch', 'localtime') FROM urls ORDER BY last_visit_time DESC LIMIT 5""")

#datetime.datetime.fromtimestamp(ms/1000.0)

results = cur.fetchall()
for result in results:
    #datetime.fromtimestamp(int(results[3])).strftime("%A, %B %d, %Y %I:%M:%S")
    #print(result[3])
    print(result)