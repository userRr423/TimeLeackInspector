import time
import copy
import math

t = time.perf_counter()

print("Пароль взломан!")

for x in range(1, 100000):
    print(x)

print(int(time.perf_counter() - t))

s = int(time.perf_counter() - t)
m = float(s) / 60
h = float(m) / 60
print("Часов " + str(round(h, 2)) + " Минут " + str(round(m,2)) + " Секунд " + str(s))
