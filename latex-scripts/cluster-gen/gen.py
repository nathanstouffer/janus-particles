import random

num    = 60
radius = 1.5
xshift = 7.5
yshift = 7.5

output = ""

for i in range(0, num):
    output += "\draw [color=\inactivecolor,fill=\inactivecolor] ("
    output += str(round(radius*random.gauss(0,1) + xshift, 4)) + ","
    output += str(round(radius*random.gauss(0,1) + yshift, 4)) + ")"
    output += " circle (\inactivesize);\n"

fout = open('output.txt', 'w')
fout.write(output)
fout.close()
