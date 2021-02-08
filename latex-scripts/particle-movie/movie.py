from sys import argv
import subprocess

script, dir_name = argv

config = open(dir_name + "/.config", 'r')
num_iter = int(config.readline().split('=')[1])
files = [ "init.csv" ]
for i in range(1, 4):
    files.append(str(int(i*num_iter/4)) + ".csv")
files.append("final.csv")

for file in files:
    subprocess.run(["python", "slide.py", dir_name + file])
