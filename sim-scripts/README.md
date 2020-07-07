This directory contains a few things

* **jars/** - contains the jars to run the simulation (they take the same type of config file)
*  **single-sim.py** - Use this script to run a single instance of the agent simulation. Initial conditions are hardcoded in the file. An output mode flag must be provided directly after the script. Use *-p* to put output in *../data/* and *-t* to put output in *../data/tmp/.* (eg *python singlesim.py -p* or *python singlesim.py -t*).
* **batch-sim.py** - Use this script to run a batch of simulations. The initial conditions should be in a csv of the format shown below (including the header line). An output mode flag must be provided directly after the script. Use *-p* to put output in *../data/* and *-t* to put output in *../data/tmp/.* Provide the relative file path of the csv as the final argument (eg *python batchsim.py -p batch-files/\<FILENAME\>.csv* or *python batchsim.py -t batch-files/\<FILENAME\>.csv*).


        max_iter,state,log,graphics,initial_state,pos_stdv,ang_stdv,num_agents,alpha,perceived_weight,threshold,velocity
        <config 1>
        <config 2>
           :
           :
        <config k>

* **simulator.py** - Don't run this one; it is used by the other .py files internally
