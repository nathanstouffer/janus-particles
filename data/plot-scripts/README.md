This directory contains the following files:

* **plot-states.py** - Script to plot the states of a given directory (given as a command line argument). Use flag *-s* to immediately show a slide show of the states. Eg. *python plot-states.py \<DIRNAME\>* or *python plot-states.py -s \<DIRNAME\>*. The state plots are generated and placed in */\<DIRNAME\>/state-imgs/.*
* **clean-state-imgs.py** - Script to remove all state images from the output directories. This script may not work on linux
* **state.py** - Don't run this one; it is used by the other *plot-states.py* internally
