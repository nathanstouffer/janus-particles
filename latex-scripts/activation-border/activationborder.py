import math

scale = 8

file_names = []
for i in range(1, 16):
    file_names.append("angle" + str(i) + ".txt")

for file_name in file_names:
    output  = "\\begin{tikzpicture}[scale=\\particlemovietikzscale]\n"
    output += "\\node[inner sep=0pt, anchor=center] (angle) at (0,0) "
    output += "{\\includegraphics[width=0.13\\textwidth]{\\angleimgdir/256res-" + file_name[:-4] +".png}};\n"

    fin = open("input/" + file_name, 'r')

    line = fin.readline().rstrip().split(",")
    com_x = scale*float(line[0])
    com_y = scale*float(line[1])
    output += "\n% center of mass of the entire end state\n"
    output += "\\draw (" + str(com_x) + "," + str(com_y) + ") node[cross=1.4pt] {};\n"

    line = fin.readline().rstrip().split(",")
    com_ang_x = scale*float(line[0])
    com_ang_y = scale*float(line[1])
    output += "\n% center of mass of this angle\n"
    output += "\\draw [black, fill=black] (" + str(com_ang_x) + "," + str(com_ang_y) + ") circle (0.1);\n"

    line = fin.readline().rstrip()
    theta = float(line.split(",")[0])
    alpha = float(line.split(",")[1])
    dot_x = 0.75*0.5*scale
    dot_y = 0.80*0.5*scale
    l_pt_x = dot_x+(0.5*math.cos(theta+alpha))
    l_pt_y = dot_y+(0.5*math.sin(theta+alpha))
    r_pt_x = dot_x+(0.5*math.cos(theta-alpha))
    r_pt_y = dot_y+(0.5*math.sin(theta-alpha))
    output += "\n% vision cone\n"
    output += "\\draw [black, fill=black] (" + str(dot_x) + "," + str(dot_y) + ") circle (0.05);\n"
    output += "\\draw [black] (" + str(l_pt_x) + "," + str(l_pt_y) + ")"
    output +=            " -- (" + str(r_pt_x) + "," + str(r_pt_y) + ");\n"

    output += "\n% activation border"
    line = fin.readline().rstrip()
    init_x = scale*float(line.split(",")[0])
    init_y = scale*float(line.split(",")[1])
    prev_x = init_x
    prev_y = init_y
    for line in fin:
        line = line.rstrip().split(",")
        x = scale*float(line[0])
        y = scale*float(line[1])
        output += "\n\\draw [black] (" + str(prev_x) + "," + str(prev_y) + ") -- (" + str(x) + "," + str(y) + ");"
        prev_x = x
        prev_y = y

    fin.close()

    output += "\n\\end{tikzpicture}"

    fout = open("output/256res-" + file_name[:-4] + ".tex", 'w')
    fout.write(output)
    fout.close()
