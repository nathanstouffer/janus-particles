# File containing a configuration for a simulation run

import subprocess       # import library to run command line stuff

class Simulator:

    # constructor
    def __init__(self, max_iter, state, log, graphics, initial_state, pos_stdv, ang_stdv,
                            num_agents, alpha, perceived_weight, threshold, velocity, out_dir):
        # initialize class variables
        # ------------------------------------------
        self.max_iter         = max_iter
        self.state            = state
        self.log              = log
        self.graphics         = graphics
        self.initial_state    = initial_state
        self.pos_stdv         = pos_stdv
        self.ang_stdv         = ang_stdv
        self.num_agents       = num_agents
        self.alpha            = alpha
        self.perceived_weight = perceived_weight
        self.threshold        = threshold
        self.velocity         = velocity
        self.out_dir          = out_dir
        # ------------------------------------------
        # make output directory
        subprocess.run(["mkdir", self.out_dir])

    # method to run the simulation
    def runSimulation(self, display_graphics):
        # construct command
        com  = "java"
        # assume no graphics
        args = [ "-jar", "jars/AgentSimulator.jar",  self.out_dir ]
        # test for graphics
        if (display_graphics):
            args[1] = "jars/AgentSimulatorG.jar"
        # run command
        subprocess.run([com, args[0], args[1], args[2]])

    # method to write the configuration to a file
    def writeConfigFile(self):
        # construct output string
        # --------------------------------------------------------------
        output  = "MAX_ITER="           + str(self.max_iter)
        output += "\nSTATE="            + str(self.state)
        output += "\nLOG="              + str(self.log)
        output += "\nGRAPHICS="         + str(self.graphics)
        output += "\nINITIAL_STATE="    + str(self.initial_state)
        output += "\nPOS_STDV="         + str(self.pos_stdv)
        output += "\nANG_STDV="         + str(self.ang_stdv)
        output += "\nNUM_AGENTS="       + str(self.num_agents)
        output += "\nALPHA="            + str(self.alpha)
        output += "\nPERCEIVED_WEIGHT=" + str(self.perceived_weight)
        output += "\nTHRESHOLD="        + str(self.threshold)
        output += "\nVELOCITY="         + str(self.velocity)
        # --------------------------------------------------------------

        # output to file
        fout = open(self.out_dir + "/.config", "w")
        fout.write(output)
        fout.close()
