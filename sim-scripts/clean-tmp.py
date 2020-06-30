import subprocess       # import library to run command line stuff

# remove everything from ../data/tmp/
subprocess.run(["rm", "-rf", "../data/tmp/*"])
