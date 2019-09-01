##---------------------------Model values evaluation----------------------------------#

#-----------------Gmatrix is Pseudoinverted using Python(numpy package)---------------#
python 3inverse.py

#----------------------------Generating Modelsoln.txt---------------------------------#

cat model.txt |awk -F"/" '{print $2" = "}' > modeltmp1
cat modelsoln |awk  '{printf "%d\n", 1/$1}' > modeltmp2
paste modeltmp1 modeltmp2 > Modelsoln1.txt

minQ=`more Input.txt | awk '{print $7}' | sort -g | head -1`
cat Modelsoln1.txt | awk -v a=${minQ} '{if($3>=a) print $0}' > Modelsoln.txt

rm modelsoln modeltmp1 modeltmp2

#-------------------------------------------------------------------------------------#

