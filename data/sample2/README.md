This README contains information for the simulation output in this directory.

There are few types of files in this directory.
 * **config** - File that the jar accessed to get simulation information (ie initial conditions). All information to run a simulation can be found there.
 * **log** - File logging the program status throughout the simulation.
 * **header** - File containing the initial conditions for the simulation.
 * **state** - File containing the state of the system at a number of iterations (file names are *init.csv, final.csv,* and *INTEGER.csv*). Each state file is of the form
        iterations,time
        1,x_1,y_1,theta_1,active_1
        2,x_2,y_2,theta_2,active_2
         :
         :
        n,x_n,y_n,theta_n,active_n

This table contains the initial conditions.

| Property     | Value     |
|--------------|-----------|
|NUM_AGENTS|10|
|ALPHA| 5.0|
|PERCEIVED_WEIGHT|0.78539816339|
|THRESHOLD|0.15915494309|
|VELOCITY|1.0E-4|