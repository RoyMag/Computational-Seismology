
##------------Code for generating Data Kernal, model and data matrices (Gm=d) for inversion-------------------#

##---------------------------------Input file format (Input.txt)----------------------------------------------#

#                     INTSTNCODE STN1LON STN1LAT STN2LON STN2LAT DIST QVALUE
#                 eg. BB05-BB34 90.9108 30.3792 89.2517 29.1077 213.6454 74
#                     xx02-xx14 91.0000 31.0000 89.0000 29.0000 314.5060 60
#                                      .............
#-------------------------Removing files generated earlier----------------------------------------------------#

rm Gmatrix.txt model.txt data.txt matrix_eqns.txt

#-----------------------Input grid parameters and data accuracy parameters------------------------------------# 

latgrid=0.5						# enter your grid size in degrees
longrid=0.5						# enter your grid size in degrees
gvalue=0.0005						# in kms
latlon_accu=0.0001					# in degrees

#------------------------Generating Model, Data matrices and matrix equations---------------------------------#

cat Input.txt|while read line
do
lon1=`echo $line|awk '{print $2}'`
lat1=`echo $line|awk '{print $3}'`
lon2=`echo $line|awk '{print $4}'`
lat2=`echo $line|awk '{print $5}'`
latdif=`echo $lat1 $lat2|awk '{print (($2-$1)^2)^(0.5)}'`
londif=`echo $lon1 $lon2|awk '{print (($2-$1)^2)^(0.5)}'`

echo $line > out.txt
echo $line |awk '{print $1" ----> "$6"/"$7" = "}' > matrixtmp
echo $line |awk '{printf "%9.4f\n", $6/$7}' >> data.txt
echo "Creating Matrices------Current Station pair $line"

if [ 1 -eq "$(echo "$latdif > 0"|bc)" ] && [ 1 -eq "$(echo "$londif > 0"|bc)" ]; then

	if [ 1 -eq "$(echo "$lat1 > $lat2"|bc)" ]; then

		project -C$lon2/$lat2 -E$lon1/$lat1 -G$gvalue -Q|awk '{printf "%.5f %.5f %.4f\n", $1,$2,$3}' > grid.txt
		cat grid.txt|head -1 >> outtmp
		
		if [ 1 -eq "$(echo "$lat2 >= 0"|bc)" ]; then
			ilat=`echo $lat2 $latgrid|awk '{print ((int($1/$2))*$2)+$2}'|awk '{printf "%.5f\n", $1}'`
		elif [ 1 -eq "$(echo "$lat2 < 0"|bc)" ]; then
			ilat=`echo $lat2 $latgrid|awk '{print ((int($1/$2))*$2)}'|awk '{printf "%.5f\n", $1}'`
		fi

		while [ 1 -eq "$(echo "$ilat < $lat1"|bc)" ]
		do
			cat grid.txt|awk '{print $2,$1,$3}'|grep "^$ilat"|awk '{print $2,$1,$3}'|head -1 >> outtmp
			ilat=`echo $ilat $latgrid|awk '{printf "%.5f\n", $1+$2}'`
		done
		lat_accu=`echo $latlon_accu|awk '{print $1}'`

		if [ 1 -eq "$(echo "$lon1 > $lon2"|bc)" ]; then
		
			if [ 1 -eq "$(echo "$lon2 >= 0"|bc)" ]; then
				ilon=`echo $lon2 $longrid|awk '{print ((int($1/$2))*$2)+$2}'|awk '{printf "%.5f\n", $1}'`
			elif [ 1 -eq "$(echo "$lon2 < 0"|bc)" ]; then
				ilon=`echo $lon2 $longrid|awk '{print ((int($1/$2))*$2)}'|awk '{printf "%.5f\n", $1}'`
			fi

			while [ 1 -eq "$(echo "$ilon < $lon1"|bc)" ]
			do
				cat grid.txt|grep "^$ilon"|head -1 >> outtmp
				ilon=`echo $ilon $longrid|awk '{printf "%.5f\n", $1+$2}'`		
			done
			lon_accu=`echo $latlon_accu|awk '{print $1}'`

		elif [ 1 -eq "$(echo "$lon1 < $lon2"|bc)" ]; then

			if [ 1 -eq "$(echo "$lon1 >= 0"|bc)" ]; then
				ilon=`echo $lon1 $longrid|awk '{print ((int($1/$2))*$2)+$2}'|awk '{printf "%.5f\n", $1}'`
			elif [ 1 -eq "$(echo "$lon1 < 0"|bc)" ]; then
				ilon=`echo $lon1 $longrid|awk '{print ((int($1/$2))*$2)}'|awk '{printf "%.5f\n", $1}'`
			fi

			while [ 1 -eq "$(echo "$ilon < $lon2"|bc)" ]
			do
				cat grid.txt|grep "^$ilon"|head -1 >> outtmp
				ilon=`echo $ilon $longrid|awk '{printf "%.5f\n", $1+$2}'`
			done
			lon_accu=`echo $latlon_accu|awk '{print "-"$1}'`
		fi
		cat grid.txt|tail -1 >> outtmp

	elif [ 1 -eq "$(echo "$lat1 < $lat2"|bc)" ]; then

		project -C$lon1/$lat1 -E$lon2/$lat2 -G$gvalue -Q|awk '{printf "%.5f %.5f %.4f\n", $1,$2,$3}'>grid.txt
		cat grid.txt|head -1 >> outtmp

		if [ 1 -eq "$(echo "$lat1 >= 0"|bc)" ]; then
			ilat=`echo $lat1 $latgrid|awk '{print ((int($1/$2))*$2)+$2}'|awk '{printf "%.5f\n", $1}'`
		elif [ 1 -eq "$(echo "$lat1 < 0"|bc)" ]; then
			ilat=`echo $lat1 $latgrid|awk '{print ((int($1/$2))*$2)}'|awk '{printf "%.5f\n", $1}'`
		fi

		while [ 1 -eq "$(echo "$ilat < $lat2"|bc)" ]
		do
			cat grid.txt|awk '{print $2,$1,$3}'|grep "^$ilat"|awk '{print $2,$1,$3}'|head -1 >> outtmp
			ilat=`echo $ilat $latgrid|awk '{printf "%.5f\n", $1+$2}'`	
		done
		lat_accu=`echo $latlon_accu|awk '{print $1}'`

		if [ 1 -eq "$(echo "$lon1 > $lon2"|bc)" ]; then

			if [ 1 -eq "$(echo "$lon2 >= 0"|bc)" ]; then
				ilon=`echo $lon2 $longrid|awk '{print ((int($1/$2))*$2)+$2}'|awk '{printf "%.5f\n", $1}'`
			elif [ 1 -eq "$(echo "$lon2 < 0"|bc)" ]; then
				ilon=`echo $lon2 $longrid|awk '{print ((int($1/$2))*$2)}'|awk '{printf "%.5f\n", $1}'`
			fi

			while [ 1 -eq "$(echo "$ilon < $lon1"|bc)" ]
			do
				cat grid.txt|grep "^$ilon"|head -1 >> outtmp
				ilon=`echo $ilon $longrid|awk '{printf "%.5f\n", $1+$2}'`
			done
			lon_accu=`echo $latlon_accu|awk '{print "-"$1}'`

		elif [ 1 -eq "$(echo "$lon1 < $lon2"|bc)" ]; then
			
			if [ 1 -eq "$(echo "$lon1 >= 0"|bc)" ]; then
				ilon=`echo $lon1 $longrid|awk '{print ((int($1/$2))*$2)+$2}'|awk '{printf "%.5f\n", $1}'`
			elif [ 1 -eq "$(echo "$lon1 < 0"|bc)" ]; then
				ilon=`echo $lon1 $longrid|awk '{print ((int($1/$2))*$2)}'|awk '{printf "%.5f\n", $1}'`
			fi

			while [ 1 -eq "$(echo "$ilon < $lon2"|bc)" ]
			do
				cat grid.txt|grep "^$ilon"|head -1 >> outtmp
				ilon=`echo $ilon $longrid|awk '{printf "%.5f\n", $1+$2}'`
			done
			lon_accu=`echo $latlon_accu|awk '{print $1}'`
		fi
		cat grid.txt|tail -1 >> outtmp
	fi

elif [ $latdif -eq 0 ] || [ $londif -eq 0 ]; then

	if [ $latdif -eq 0 ]; then

		if [ 1 -eq "$(echo "$lat1 >= 0"|bc)" ]; then
			newlat=`expr $lat1+$latlon_accu|bc`
		elif [ 1 -eq "$(echo "$lat1 < 0"|bc)" ]; then
			newlat=`expr $lat1-$latlon_accu|bc`
		fi		
		project -C$lon1/$lat1 -E$lon2/$lat2 -G$gvalue -Q|awk -v k=$newlat '{printf "%.5f %.6f %.4f\n", $1,k,$3}'>grid.txt
		cat grid.txt|head -1 >> outtmp
		lat_accu=`echo $latlon_accu|awk '{print $1}'`

		if [ 1 -eq "$(echo "$lon1 > $lon2"|bc)" ]; then

			if [ 1 -eq "$(echo "$lon2 >= 0"|bc)" ]; then
				ilon=`echo $lon2 $longrid|awk '{print ((int($1/$2))*$2)+$2}'|awk '{printf "%.5f\n", $1}'`
			elif [ 1 -eq "$(echo "$lon2 < 0"|bc)" ]; then
				ilon=`echo $lon2 $longrid|awk '{print ((int($1/$2))*$2)}'|awk '{printf "%.5f\n", $1}'`
			fi

			while [ 1 -eq "$(echo "$ilon < $lon1"|bc)" ]
			do
				cat grid.txt|grep "^$ilon"|head -1 >> outtmp
				ilon=`echo $ilon $longrid|awk '{printf "%.5f\n", $1+$2}'`
			done
			lon_accu=`echo $latlon_accu|awk '{print "-"$1}'`

		elif [ 1 -eq "$(echo "$lon1 < $lon2"|bc)" ]; then

			if [ 1 -eq "$(echo "$lon1 >= 0"|bc)" ]; then
				ilon=`echo $lon1 $longrid|awk '{print ((int($1/$2))*$2)+$2}'|awk '{printf "%.5f\n", $1}'`
			elif [ 1 -eq "$(echo "$lon1 < 0"|bc)" ]; then
				ilon=`echo $lon1 $longrid|awk '{print ((int($1/$2))*$2)}'|awk '{printf "%.5f\n", $1}'`
			fi

			while [ 1 -eq "$(echo "$ilon < $lon2"|bc)" ]
			do
				cat grid.txt|grep "^$ilon"|head -1 >> outtmp
				ilon=`echo $ilon $longrid|awk '{printf "%.5f\n", $1+$2}'`
			done
			lon_accu=`echo $latlon_accu|awk '{print $1}'`

		elif [ $londif -eq 0 ]; then
			echo "SAME STATION"
		fi
		cat grid.txt|tail -1 >> outtmp

	elif [ $londif -eq 0 ]; then

		if [ 1 -eq "$(echo "$lon1 >= 0"|bc)" ]; then
			newlon=`expr $lon1+$latlon_accu|bc`
		elif [ 1 -eq "$(echo "$lon1 < 0"|bc)" ]; then
			newlon=`expr $lon1-$latlon_accu|bc`
		fi
		project -C$lon1/$lat1 -E$lon2/$lat2 -G$gvalue -Q|awk -v k=$newlon '{printf "%.6f %.5f %.4f\n", k,$2,$3}'>grid.txt
		cat grid.txt|head -1 >> outtmp
		lon_accu=`echo $latlon_accu|awk '{print $1}'`

		if [ 1 -eq "$(echo "$lat1 > $lat2"|bc)" ]; then
			
			if [ 1 -eq "$(echo "$lat2 >= 0"|bc)" ]; then
				ilat=`echo $lat2 $latgrid|awk '{print ((int($1/$2))*$2)+$2}'|awk '{printf "%.5f\n", $1}'`
			elif [ 1 -eq "$(echo "$lat2 < 0"|bc)" ]; then
				ilat=`echo $lat2 $latgrid|awk '{print ((int($1/$2))*$2)}'|awk '{printf "%.5f\n", $1}'`
			fi

			while [ 1 -eq "$(echo "$ilat < $lat1"|bc)" ]
			do
				cat grid.txt|awk '{print $2,$1,$3}'|grep "^$ilat"|awk '{print $2,$1,$3}'|head -1 >> outtmp
				ilat=`echo $ilat $latgrid|awk '{printf "%.5f\n", $1+$2}'`
			done
			lat_accu=`echo $latlon_accu|awk '{print "-"$1}'`

		elif [ 1 -eq "$(echo "$lat1 < $lat2"|bc)" ]; then

			if [ 1 -eq "$(echo "$lat1 >= 0"|bc)" ]; then
				ilat=`echo $lat1 $latgrid|awk '{print ((int($1/$2))*$2)+$2}'|awk '{printf "%.5f\n", $1}'`
			elif [ 1 -eq "$(echo "$lat1 < 0"|bc)" ]; then
				ilat=`echo $lat1 $latgrid|awk '{print ((int($1/$2))*$2)}'|awk '{printf "%.5f\n", $1}'`
			fi

			while [ 1 -eq "$(echo "$ilat < $lat2"|bc)" ]
			do
				cat grid.txt|awk '{print $2,$1,$3}'|grep "^$ilat"|awk '{print $2,$1,$3}'|head -1 >> outtmp
				ilat=`echo $ilat $latgrid|awk '{printf "%.5f\n", $1+$2}'`	
			done
			lat_accu=`echo $latlon_accu|awk '{print $1}'`			

		elif [ $latdif -eq 0 ]; then
			echo "SAME STATION"
		fi
		cat grid.txt|tail -1 >> outtmp
	fi

fi

cat outtmp|sort -n -k3|awk -F" " '!seen[$1, $2]++' >> out.txt ; rm outtmp

cat out.txt|tail -n +2|awk 'NR>1{print $1,$2,$3-i} {i=$3}'|while read line
do
lat=`echo $line|awk '{print $2}'` 
lon=`echo $line|awk '{print $1}'` 

		if [ 1 -eq "$(echo "$lat > 0"|bc)" ] || [ $latdif -eq 0 ]; then
			ilat_accu=`echo $lat_accu|awk '{print $1}'`
		elif [ 1 -eq "$(echo "$lat <= 0"|bc)" ] && [ $latdif -ne 0 ]; then
			ilat_accu=`expr $lat_accu+$latgrid|bc` 
		fi

		if [ 1 -eq "$(echo "$lon > 0"|bc)" ] || [ $londif -eq 0 ]; then
			ilon_accu=`echo $lon_accu|awk '{print $1}'` 
		elif [ 1 -eq "$(echo "$lon <= 0"|bc)" ] && [ $londif -ne 0 ]; then
			ilon_accu=`expr $lon_accu+$longrid|bc`
		fi

latid=`echo $lat $latgrid $ilat_accu|awk '{print (int(($1-$3)/$2))*$2}'|awk '{printf "%.2f\n", $1}'`
lonid=`echo $lon $longrid $ilon_accu|awk '{print (int(($1-$3)/$2))*$2}'|awk '{printf "%.2f\n", $1}'`
dist=`echo $line|awk '{print $3}'`
echo "$dist/q{$latid,$lonid} +" >> matrixtmp
echo "1/q{$latid,$lonid}" >> modeltmp
done

cat matrixtmp |paste -sd" "| rev | cut -c 2- | rev >> matrix_eqns.txt ; rm matrixtmp
done

cat modeltmp|sort|uniq > model.txt ; rm modeltmp grid.txt out.txt

#---------------------------------Generating Data Kernal matrix-----------------------------------------------#

cat matrix_eqns.txt|while read matrix
do
	cat model.txt|while read model
	do
		modelsearch=`echo $model|awk -F"/" '{print "/"$2" "}'`
		g=`echo "$matrix"|grep -F "$modelsearch"|awk -F"$modelsearch" '{print $1}'|awk '{print $NF}'`
		if [ -z "$g" ]; then
			echo 0|awk '{printf "%9.4f\n", $1}' >> gtmp
			else 
			echo $g|awk '{printf "%9.4f\n", $1}' >> gtmp
		fi
	done
	cat gtmp|paste -sd" " >> Gmatrix.txt ; rm gtmp
done

echo "OUTPUTs generated for 2D grid of size $latgrid by $longrid degree"

#-------------------------------------------------------------------------------------------------------------#

#echo "sh" "~/Thesis/tibet/INDEPTH_III/lgq/2Model_eval.sh" | sh

