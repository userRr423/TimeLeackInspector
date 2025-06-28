import requests
import json

url = 'http://localhost/upload.php'



# url =  'https://72b5-188-170-75-185.ngrok-free.app/upload.php'
file = {'filename': open('test.py',  'rb')}
r = requests.post(url,  files=file, verify=False)
print(r.text)
