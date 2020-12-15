# file to run a single simulation run with the given initial conditions

import simulator            # import class containing config file
import datetime             # import class with date
import math                 # import math library
import sys
from sys import argv        # import library for checking command line stuff
import subprocess
import time

# function to return output directory name
def outDir():
    # begin output directory name
    name = "../data/phase-portrait/sim/raw-output/"
    name += sim_start + "/"
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

def linspace(a, b, steps):
    list = [ a ]
    size = (b-a)/(steps-1)
    for i in range(0, steps-1):
        list.append(list[-1]+size)
    return list


# set pi variable
pi = math.pi

# configuration variables
# ----------------------------------------
max_iter         = 20000
state            = 5
log              = 5000
graphics         = 0
initial_state    = "r"
pos_stdv         = 0.0008
ang_stdv         = 0.1348
num_agents       = 75
alpha            = 0
perceived_weight = 2*pi
threshold        = 0#(2*alpha*num_agents)/(pi*pi)
velocity         = 0.0008
# ----------------------------------------

display_graphics = False

res = 32


# range of values for alpha and threshold
a_range = [pi/res, pi]
t_range = [1.2/res, 1.2]

sim_start = datetime.datetime.now().strftime("d-%m.%d.%Y_t-%H.%M.%S")
subprocess.run(["mkdir", "../data/phase-portrait/sim/raw-output/" + sim_start + "/"])

start = time.time()
# nested for loop to discretize the phase space
counter = 0
for a in linspace(a_range[0], a_range[1], res):
    for t in linspace(t_range[0], t_range[1], res):
        counter += 1
        # compute alpha and threshold
        alpha = a
        pcpi = (2*alpha*num_agents)/(pi*pi)
        threshold = t * pcpi

        cur = time.time()
        print("\nITERATION", counter, "      ", round(cur-start), "seconds elapsed (in total)\n", flush=True)

        # declare output directory
        out_dir = outDir()

        # create config object
        sim = simulator.Simulator(max_iter, state, log, graphics, initial_state, pos_stdv, ang_stdv,
                                        num_agents, alpha, perceived_weight, threshold, velocity, out_dir)
        # write the configuation file
        sim.writeConfigFile()
        # run simulate
        sim.runSimulation(display_graphics)
