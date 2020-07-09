# script to plot and save state to a file
# the directory containing state files should be provided as a command line argument

from sys import argv
import matplotlib.pyplot as plt
import matplotlib.animation
import numpy as np
import subprocess
import state   # import state file

# methods
# ------------------------------------------------------------------------------

# method to get the step size and max_iter from .config file
def configInfo(dir):
    # open configuration file
    conf = open(dir + "/.config", "r")
    # read max iteration line
    max_iter = int(conf.readline().split("=")[1])
    # read step size line
    step = int(conf.readline().split("=")[1])
    # skip lines until num_agents
    conf.readline()
    conf.readline()
    conf.readline()
    conf.readline()
    conf.readline()
    num_agents = int(conf.readline().split("=")[1])
    # close config file
    conf.close()
    # return values
    return max_iter, step, num_agents

# method to process the input flags
def processFlags(flags):
    if ("s" in flags):
        return True
    else:
        return False

# method to process the states in the directory
def processDir(dir):
    # list to store the states
    states = []
    # get necessary config variables
    max_iter, step, num_agents = configInfo(dir)
    # set current iterations
    cur = step
    states.append(state.State(dir + "/init.csv", num_agents))
    # loop over states
    while (cur <= max_iter):
        states.append(state.State(dir + str(cur) + ".csv", num_agents))
        # update cur
        cur += step
    states.append(state.State(dir + "/final.csv", num_agents))
    # return states
    return states

# method to process states
def processStates(dir, states):
    for s in states:
        # plot points
        scat = plt.scatter(s.x, s.y, s=size, c=colormap[s.active])
        plt.title("Agent positions at " + str(s.iter) + " iterations")
        # save plot to file
        plt.savefig(dir + "/state-imgs/" + str(s.iter) + ".png")
        # remove points
        scat.remove()

# method to run the slide show
def showSlides(states):
    for s in states:
        slide = plt.scatter(s.x, s.y, s=size, c=colormap[s.active])
        plt.title("Agent positions at " + str(s.iter) + " iterations")
        plt.draw()
        plt.pause(0.5)
        slide.remove()
    plt.scatter(states[-1].x, states[-1].y, s=size, c=colormap[states[-1].active])
    plt.show()


# script code
# ------------------------------------------------------------------------------

# boolean to display slide show of state, assume to be false
slides = False
# colormap
colormap = np.array(['grey', 'blue'])
size = 3

# get command line arguments
for a in range(1, len(argv)):
    # check for flags
    if (argv[a][0] == "-"):
        # process input flags
        slides = processFlags(argv[a])
    else:
        # process the states in the output file
        dir = argv[a]
        # make output directory
        subprocess.run(["mkdir", dir + "/state-imgs/"])
        # get states from directory
        states = processDir(dir)
        # process states
        processStates(dir, states)
        # print output message
        if (dir[-1] == "/"):
            print("State files processed and images saved to " + argv[a] + "state-imgs/")
        else:
            print("State files processed and images saved to " + argv[a] + "/state-imgs/")
        # check if should display slide show
        if (slides):
            # run slide show
            showSlides(states)
