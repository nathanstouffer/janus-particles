from sys import argv
import subprocess

script, dir_name = argv

config = open(dir_name + "/.config", 'r')
num_iter = int(config.readline().split('=')[1])
files = [ "init.csv" ]
for i in range(1, 11):
    files.append(str(int(i*0.02*num_iter)) + ".csv")
for i in range(3, 10):
    files.append(str(int(i*0.1*num_iter))  + ".csv")
files.append("final.csv")

i = 1
for file in files:
    subprocess.run(["python", "slide.py", dir_name + file, str(i)])
    i += 1
