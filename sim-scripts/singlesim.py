# file to run a single simulation run with the given initial conditions

import simulator            # import class containing config file
import datetime             # import class with date
import math                 # import math library
from sys import argv        # import library for checking command line stuff

# function to return output directory name
def outDir(perm):
    # begin output directory name
    name = "../data/"
    # check if this run is a temporary run
    if (not perm):
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
max_iter         = 1000
state            = 250
log              = 250
graphics         = 1
initial_state    = "r"
pos_stdv         = 0.0025
ang_stdv         = 0.025
num_agents       = 1000
alpha            = pi / 4.0
perceived_weight = 1.0 / (2*pi)
threshold        = 5.0
velocity         = 0.0001
# ----------------------------------------

# check command line inputs
script, perm = argv
# compute output directory
out_dir = outDir(perm == "-p")
# create config object
sim = simulator.Simulator(max_iter, state, log, graphics, initial_state, pos_stdv, ang_stdv,
                                num_agents, alpha, perceived_weight, threshold, velocity, out_dir)
# write the configuation file
sim.writeConfigFile()
# run simulate
sim.runSimulation()
