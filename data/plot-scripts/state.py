# file to read and store a single state file in memory

import numpy as np

class State:

    # constructor
    def __init__(self, file_name, num_agents):
        # set class variables
        self.iter = file_name.split("/")[-1][:-4]
        self.num_agents = num_agents
        # numpy arrays for agent positions
        self.x = np.zeros(num_agents)
        self.y = np.zeros(num_agents)
        self.active = np.zeros(num_agents, dtype=int)
        self.readState(file_name)

    # method to read the state from the file
    def readState(self, file_name):
        # open file
        fin = open(file_name, "r")
        line = fin.readline()
        # iterate over agents in file
        for l in range(0, self.num_agents):
            line = fin.readline().split(",")
            self.x[l] = float(line[1])
            self.y[l] = float(line[2])
            if (line[4].rstrip() == "true"):
                self.active[l] = 1
            else:
                self.active[l] = 0
        # close file
        fin.close()

    # string method
    def __str__(self):
        out = "\niterations: " + str(self.iter)
        out += "\nnum_agents: " + str(self.num_agents)
        out += "\nx: " + str(self.x)
        out += "\ny: " + str(self.y)
        out += "\na: " + str(self.active)

        # return output string
        return out
