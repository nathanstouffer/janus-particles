import matplotlib.pyplot as plt
import numpy as np

# original data
num_agents = [ 75, 100, 150, 200, 250, 300, 350, 400,  450,  500 ]
times      = [ 49,  76, 149, 235, 348, 524, 698, 835, 1094, 1385 ]

# we now fit a curve to the data
# parabola coefficients
a = 27.49
b = -0.05
c = 0.005

n  = np.linspace(0, 600)
eq = a + b*n + c*n*n

# set up plot
plt.title("Simulation time (to reach 100000 iterations) vs Number of Agents")
plt.xlabel("Number of agents")
plt.ylabel("Seconds to reach 100000 movement iterations")

# plot data
plt.scatter(num_agents, times)
# plot curve
plt.plot(n, eq)

plt.show()
