import numpy as np

filename1 = "Gmatrix.txt"
filename2 = "data.txt"

gmatrix = np.loadtxt(filename1)
data = np.loadtxt(filename2)
gmatrixinv = np.linalg.pinv(gmatrix)
modelsolution = np.dot(gmatrixinv,data)

np.savetxt('modelsoln',modelsolution)

