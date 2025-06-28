import tkinter as tk
from tkinter.messagebox import showinfo
from tkinter import *
from functools import partial
import requests
from requests.auth import HTTPBasicAuth
from pyquery import PyQuery as pq
from tkinter.messagebox import showinfo


#url = 'http://mvc/login.php'
url = ''

loc = ''

passwordFile = ""

headers = {}

exitApp = False


notShow = False

def check_response(response):
    if not response or not response.content or response.status_code >= 400:
        return False
    return True

def validateLogin(root, username, password, location):
    global exitApp
    global passwordFile
    global url
    global loc

    loc = location.get()

    url = location.get() + 'login.php'

    payload={'login': username.get(),
    'pass': password.get()}
    files=[
    ]

    try:
        resp = requests.get(url)
    except :
        showinfo(title='Ошибка входа', message='Не правильный url')
        exitApp = False
        return exitApp

    response = requests.request("POST", url, headers=headers, data=payload, files=files)

    

    #print (response.text)

    doc = pq(response.content)
    print(doc("span").text())
    checkAnser = doc("span").text()

    print("username entered :", type(username.get()))
    print("password entered :", type(password.get()))

    if checkAnser == "1":
       passwordFile = password.get()
       print("Yess")
       exitApp = True
       root.destroy()
       return exitApp
    else:
        showinfo(title='Ошибка входа', message='Не правильный логин или пароль')
        exitApp = False
    

    return exitApp

class App(tk.Tk):
  
  

  def __init__(self):
    super().__init__()

    # configure the root window
    self.title('eam')
    self.geometry('400x150')

    self.usernameLabel = tk.Label(self, text="Логин").grid(row=0, column=0)
    self.username = tk.StringVar()
    self.usernameEntry = tk.Entry(self, textvariable=self.username).grid(row=0, column=1)  

#password label and password entry box
    self.passwordLabel = tk.Label(self,text="Пароль").grid(row=1, column=0)  
    self.password = tk.StringVar()
    self.passwordEntry = tk.Entry(self, textvariable=self.password, show='*').grid(row=1, column=1)  

    self.urlLabel = tk.Label(self, text="url").grid(row=2, column=0)
    self.urlname = tk.StringVar()
    self.urlnameEntry = tk.Entry(self, textvariable=self.urlname).grid(row=2, column=1)  

    self.validateLogin = partial(validateLogin, self, self.username, self.password, self.urlname)

#login button
    self.loginButton = tk.Button(self, text="Войти", command=self.validateLogin).grid(row=4, column=0)

  



    
    



