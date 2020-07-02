import subprocess       # import library to run command line stuff

# remove everything from ../*/state-img/ and ../tmp/*/state-img/
subprocess.run(["rm", "-rf", "../*/state-imgs/", "../tmp/*/state-imgs/"])
