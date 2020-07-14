This directory contains the following things:

* Output directory - These directories are named by the initial conditions of the simulation that they were a part of. They contain the files listed below.
* Batch directory - Directory containing output directories from a batch. This directory is named by the batch file and a time stamp.
* *tmp/* - Directory containing output directories that are easily cleaned (with *rm -rf tmp/\** or something). This directory may not be in the remote repository but will be generated locally when a "-t" simulation script is ran.
* *plot-scripts.py* - Directory containing scripts to plot the data. Run this with the command *python plot-scripts.py \<DIRECTORY\>* (or *python plot-scripts.py -s \<DIRECTORY\>* to show a slideshow). The plots are saved to *\<DIRECTORY\>/state-imgs/.*

Each output directory contains the following files

 * **README.md** - File containing initial conditions in a readable format.
 * **.config** - File the jar accessed for simulation info (ie initial conditions).
 * **.log** - File logging the program status throughout the simulation.
 * **header.csv** - File containing the initial conditions for the simulation in csv format.
 * **state** (*init.csv, final.csv, \<integer\>.csv*) - File containing the system state at an iteration count. Each state file is of the form

        iterations,time
        1,x_1,y_1,theta_1,active_1
        2,x_2,y_2,theta_2,active_2
         :
         :
        n,x_n,y_n,theta_n,active_n
