This directory contains the following files:

* **plot-states.py** - Script to plot the states of a given directory (given as a command line argument). Use flag *-s* to immediately show a slide show of the states. Eg. *python plot-states.py \<DIRNAME\>* or *python plot-states.py -s \<DIRNAME\>*. The state plots are generated and placed in */\<DIRNAME\>/state-imgs/.*
* **clean-state-imgs.py** - Script to delete all */state-imgs/* directories.
* **clean-tmp.py** - Script to delete all files in *../tmp/.* This just makes cleaning up the *../tmp/* directory quick and easy.
* **state.py** - Don't run this one; it is used by the other .py files internally
