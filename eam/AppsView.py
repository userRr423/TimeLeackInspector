import pygetwindow as gw
import json
import os
from tkinter.messagebox import showinfo

AppsView = {
"apps": "",
"count": 0,
"activeApp":""
}

def appsView(passwordFile):
    result = gw.getAllTitles()
    result = list(filter(None, result))
    count = 0
    AppsView["apps"] = ""
    AppsView["activeApp"] = ""

    for r in result:
        AppsView["apps"] += " " + r
        count = count + 1

    AppsView["count"] = count

    if gw.getActiveWindow() is not None:
        AppsView["activeApp"] = str(gw.getActiveWindow().title)
    
    json_string = json.dumps(AppsView, ensure_ascii=False)
    
    filename = "AppsView"+str(passwordFile)+".json"
    with open("AppsView"+str(passwordFile)+".json", "w", encoding='utf8') as json_file:
        json_file.write(json_string)
    
    if not os.path.exists(filename):
        showinfo(title='Файл', message='файл не был создан')







