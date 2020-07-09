# file to run the simulation multiple times
# a file name containg a bunch of configurations is expected as a command line argument
# this file should be of the form
# header line: max_iter,state,log,graphics,initial_state,pos_stdv,ang_stdv,num_agents,alpha,perceived_weight,threshold,velocity
# <config 1>
# <config 2>
#   :
#   :
# <config k>

import simulator            # import class containing config file
import datetime             # import class with date
import math                 # import math library
import sys
from sys import argv        # import library for checking command line stuff
import subprocess

# function to return output directory name
def outDir(flag, input_file):
    # begin output directory name
    name = "../data/"
    # check if this run is a temporary run
    if ("t" in flag):
        subprocess.run(["mkdir", "../data/tmp/"])
        name += "tmp/"
        print("Output going to temporary directory", flush=True)
    # add batch file name
    name += input_file.split("/")[-1][:-4] + "/"
    subprocess.run(["mkdir", name])
    # compute date and time
    now = datetime.datetime.now().strftime("d-%m.%d.%Y_t-%H.%M.%S")
    # construct directory name
    name += "n-" + str(num_agents)            + "_"
    name += "a-" + str(alpha)[0:5]            + "_"
    name += "p-" + str(perceived_weight)[0:5] + "_"
    name += "t-" + str(threshold)             + "_"
    name += "v-" + str(velocity)              + "_"
    name += now
    # return directory name
    return name


# set pi variable
pi = math.pi

# configuration variables (null until lines are read from file)
# ----------------------------------------
max_iter         = " "
state            = " "
log              = " "
graphics         = " "
initial_state    = " "
pos_stdv         = " "
ang_stdv         = " "
num_agents       = " "
alpha            = " "
perceived_weight = " "
threshold        = " "
velocity         = " "
# ----------------------------------------

# check command line inputs
script, flag, input_file = argv
# check that flag is valid
if ("t" not in flag and "p" not in flag):
    print("invalid flag for output mode (must be '-t' or '-p')")
    sys.exit(1)
display_graphics = ("g" in flag)

# open input file
fin = open(input_file, "r")
fin.readline()

for line in fin:
    # split the line
    split = line.rstrip().split(",")
    # configuration variables
    # ----------------------------------------
    max_iter         = split[0]
    state            = split[1]
    log              = split[2]
    graphics         = split[3]
    initial_state    = split[4]
    pos_stdv         = split[5]
    ang_stdv         = split[6]
    num_agents       = split[7]
    alpha            = split[8]
    perceived_weight = split[9]
    threshold        = split[10]
    velocity         = split[11]
    # ----------------------------------------
    # compute output directory
    out_dir = outDir(flag, input_file)
    # create config object
    sim = simulator.Simulator(max_iter, state, log, graphics, initial_state, pos_stdv, ang_stdv,
                                    num_agents, alpha, perceived_weight, threshold, velocity, out_dir)
    # write the configuation file
    sim.writeConfigFile()
    # run simulate
    sim.runSimulation(display_graphics)

fin.close()
