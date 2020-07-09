import subprocess       # import library to run command line stuff

# remove everything from ../*/state-img/, ../*/*/state-imgs and ../tmp/*/state-img/
subprocess.run(["rm", "-rf", "../*/state-imgs/", "../*/*/state-imgs/", "../tmp/*/state-imgs/"])
