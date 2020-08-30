# file to run a single simulation run with the given initial conditions

import simulator            # import class containing config file
import datetime             # import class with date
import math                 # import math library
import sys
from sys import argv        # import library for checking command line stuff
import subprocess

# function to return output directory name
def outDir(flag):
    # begin output directory name
    name = "../data/"
    # check if this run is a temporary run
    if ("t" in flag):
        subprocess.run(["mkdir", "../data/tmp/"])
        name += "tmp/"
        print("Output going to temporary directory", flush=True)
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

# configuration variables
# ----------------------------------------
max_iter         = 200000
state            = 25000
log              = 25000
graphics         = 1 
initial_state    = "r"
pos_stdv         = 0.0005
ang_stdv         = 0.2
num_agents       = 100
alpha            = pi / 4.0
perceived_weight = 4.375 
threshold        = 10
velocity         = 0.00025
# ----------------------------------------


# check command line inputs
if (len(argv) != 2):
    print("command should be of the form \"python sim-single.py -<flag>\"")
    sys.exit(1)
script, flag = argv
# check that flag is valid
if ("t" not in flag and "p" not in flag):
    print("invalid flag for output mode (must include 't' or 'p')")
    sys.exit(1)
display_graphics = ("g" in flag)
# declare output directory, assume the run is temporary
out_dir = outDir(flag)

# create config object
sim = simulator.Simulator(max_iter, state, log, graphics, initial_state, pos_stdv, ang_stdv,
                                num_agents, alpha, perceived_weight, threshold, velocity, out_dir)
# write the configuation file
sim.writeConfigFile()
# run simulate
sim.runSimulation(display_graphics)
