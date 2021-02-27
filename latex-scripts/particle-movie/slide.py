from sys import argv

script, file_name, time_step = argv

l = 7
edge = 0.5

output  = "\\begin{tikzpicture}[scale=\\tikzscale]\n% bounding rectangle"
output += "\n\\draw [very thick] (0,0) rectangle (" +str(l+2*edge) + "," + str(l+2*edge) + ");"
output += "\n% agents"

fin = open(file_name, 'r')
fin.readline()
for line in fin:
    line = line.split(",")
    x = float(line[1])
    y = float(line[2])
    output += "\n\\draw [color=black, fill=black] (" + str(x*l+edge) + "," + str(y*l+edge) + ") circle (\circsize);"

fin.close()

output += "\n\\end{tikzpicture}"

fout = open("output/particlemovie-t" + str(time_step) + ".tex", 'w')
fout.write(output)
fout.close()
