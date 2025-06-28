import requests

headers = {'Accept': 'application/json'}

r = requests.get('http://timeleakinspector.ru/upload/command.json', headers=headers)

com  = r.json()

print(com["work_time"])