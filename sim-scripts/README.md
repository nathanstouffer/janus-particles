This directory contains a few executable python files

*  **single-sim.py** - Use this script to run a single instance of the agent simulation. Initial conditions are hardcoded in the file. An output mode flag must be provided directly after the script. Use *-p* to put output in *../data/* and *-t* to put output in *../data/tmp/.* (eg *python singlesim.py -p* or *python singlesim.py -t*).
* **batch-sim.py** - Use this script to run a batch of simulations. The initial conditions should be in a csv of the format shown below. An output mode flag must be provided directly after the script. Use *-p* to put output in *../data/* and *-t* to put output in *../data/tmp/.* Provide the relative file path of the csv as the final argument (eg *python batchsim.py -p batch-files/<filename>.csv* or *python batchsim.py -t batch-files/<filename>.csv*).
* **clean-tmp.py** - Use this script to delete all files in *../data/tmp/.* This just makes cleaning up the *tmp* folder really quick and easy.
* **simulator.py** - Don't run this one; it is used by the other .py files internally

        max_iter,state,log,graphics,initial_state,pos_stdv,ang_stdv,num_agents,alpha,perceived_weight,threshold,velocity
        <config 1>
        <config 2>
           :
           :
        <config k>
