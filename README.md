# Lg Q Attenuation Tomography

Peform attenuation tomography studies using Xie and Mitchell back-projection equation and plots least square criteria under over determined case inverse porblem.

i) First run 1Make-matrix.sh. It requires input file Input.txt in the specifired format as in the code. The code is now generalised for all latitudes and longitudes(both positive and negative). Also you can use any grid size of your choice individually for latitudes and longitudes. If you want grids only around any one of latitude or longitude, simply increase the other gridsize more than the difference of the maximum and minimum of it and then it becomes irrelevent. The code will generate Gmatrix.txt, data.txt, model.txt and matrix_eqsn.txt.

ii) Then run 2Model_eval.sh. Remember, this code within it runs python code 3inverse.py. The Python code will only run if numpy package of python is installed. The python code basically does pseudoinverse for the given non square matrix "Gmatrix.txt". This code will generate final solutions of the models in "Modelsoln.txt". 

iii) Installing Numpy,Scipy
To install the dependencies in all currently supported versions of Ubuntu open the terminal and type the following commands:

sudo apt update  
sudo apt install --no-install-recommends python2.7-minimal python2.7  
sudo apt install python-numpy python-scipy

For Python 3.x

sudo apt update  
sudo apt install --no-install-recommends python3-minimal python3  
sudo apt install python3-numpy python3-scipy
