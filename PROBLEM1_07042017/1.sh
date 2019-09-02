a1=0.4e-6
a2=2.5e-6
z1=30e3
z2=40e3
k=2.5
q=20e-3

echo "Enter the value of z (in meters): "
read z

t=`echo $a1 $a2 $z1 $z2 $k $q $z | awk '{print ((((-0.5*$1)/$5)*$7*$7)+(($6/$5)+(($2/$5)*($4-$3))+(($1*$3)/$5))*$7)}'`

echo "The value of T is $t degree celsius"
