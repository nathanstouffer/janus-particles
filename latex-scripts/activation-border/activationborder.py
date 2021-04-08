import math

file_names = []
for i in range(1, 17):
    file_names.append("angle" + str(i) + ".txt")

for file_name in file_names:
    output  = "\\begin{tikzpicture}[scale=\\angleactivationscale]\n"
    output += "\\node[inner sep=0pt, anchor=south west] ("
    output += file_name[:-4] + ") at (0,0) "
    output += "{\\includegraphics[width=0.13\\textwidth]{\\angleimgdir/256res-" + file_name[:-4] +".png}};\n\n"

    output += "% begin scope environment so path scales with the image\n"
    output += "\\begin{scope}[x={(" + file_name[:-4] + ".south east)},"
    output +=                "y={(" + file_name[:-4] + ".north west)}]\n"

    fin = open("input/" + file_name, 'r')

    line = fin.readline().rstrip().split(",")
    com_x = float(line[0])
    com_y = float(line[1])
    output += "\n% center of mass of the entire end state\n"
    output += "\\draw (" + str(com_x) + "," + str(com_y) + ") node[cross=1.4pt] {};\n"

    line = fin.readline().rstrip().split(",")
    com_ang_x = float(line[0])
    com_ang_y = float(line[1])
    output += "\n% center of mass of this angle\n"
    output += "\\draw [black, fill=black] (" + str(com_ang_x) + "," + str(com_ang_y) + ") circle (0.01);\n"

    line = fin.readline().rstrip()
    theta = float(line.split(",")[0])
    alpha = float(line.split(",")[1])
    dot_x = 0.725
    dot_y = 0.9
    ray_scale = 0.1
    l_pt_x = dot_x-0.0015*math.cos(theta)+(ray_scale*math.cos(theta+alpha))
    l_pt_y = dot_y-0.0015*math.sin(theta)+(ray_scale*math.sin(theta+alpha))
    r_pt_x = dot_x-0.0015*math.cos(theta)+(ray_scale*math.cos(theta-alpha))
    r_pt_y = dot_y-0.0015*math.sin(theta)+(ray_scale*math.sin(theta-alpha))
    p_rad = 0.02
    output += "\n% drawing reference particle\n"
    output += "\\fill [white] (" + str(dot_x) + "," + str(dot_y) + ") "
    output += "circle (" + str(p_rad) + ");\n"
    output += "\\fill [black] (" + str(dot_x+p_rad*math.cos(theta+alpha))
    output +=                "," + str(dot_y+p_rad*math.sin(theta+alpha)) + ") "
    output += "arc (" + str((theta+alpha)*180/math.pi)
    output += ":" + str((2*math.pi+(theta-alpha))*180/math.pi) + ":" + str(p_rad) + ");\n"
    output += "\\draw [black] (" + str(dot_x) + "," + str(dot_y) + ") "
    output += "circle (" + str(p_rad) + ");\n"
    output += "% vision cone\n"
    output += "\\draw [black] (" + str(l_pt_x) + "," + str(l_pt_y) + ")"
    output +=            " -- (" + str(r_pt_x) + "," + str(r_pt_y) + ");\n"
    output += "% showing particle orientation\n"
    output += "\\draw [thin, -{Stealth[round,scale=0.4]}] ("
    output += str(dot_x+p_rad*math.cos(theta)) + "," + str(dot_y+p_rad*math.sin(theta)) + ") -- ("
    output += str(dot_x+4*p_rad*math.cos(theta)) + "," + str(dot_y+4*p_rad*math.sin(theta)) + ");\n"

    output += "\n% activation border"
    line = fin.readline().rstrip()
    init_x = float(line.split(",")[0])
    init_y = float(line.split(",")[1])
    prev_x = init_x
    prev_y = init_y
    for line in fin:
        line = line.rstrip().split(",")
        x = float(line[0])
        y = float(line[1])
        output += "\n\\draw [black] (" + str(prev_x) + "," + str(prev_y) + ") -- (" + str(x) + "," + str(y) + ");"
        prev_x = x
        prev_y = y

    fin.close()

    output += "\n\n\\end{scope}\n"
    output += "\n\\end{tikzpicture}"

    fout = open("output/256res-" + file_name[:-4] + ".tex", 'w')
    fout.write(output)
    fout.close()
