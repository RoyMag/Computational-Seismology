rm sent.txt
echo ".NAME Subhadeep Roy\n.INST Indian Institute of Science Education and Research Kolkata\n.MAIL Department of Earth Sciences, IISER Kolkata, Nadia-741246, India\n.EMAIL subhadeeproy29@gmail.com\n.PHONE +91-9167676174\n.MEDIA FTP\n.ALTERNATE MEDIA EXABYTE - 2 gigabyte\n.ALTERNATE MEDIA EXABYTE - 5 gigabyte\n.LABEL Y2_WT02_2007_2011\n.END\n" > sent.txt


l=`cat 1.txt |  wc -l | awk '{print $1-1}'`
for i in `seq 1 1 $l`
do
date=`cat 1.txt | tail -n +2 | awk -v j=$i -F"," 'NR==j {print $3}' | awk -F"-" '{print $1"\t"$2"\t"$3}'`
time=`cat 1.txt | tail -n +2 | awk -v j=$i -F"," 'NR==j {print $4}' | awk -F":" '{print $1"\t"$2"\t"$3}' | awk -F"." '{print $1}'`

year=`echo $date | awk '{print $1}'`
month=`echo $date | awk '{print $2}'`
day=`echo $date | awk '{print $3}'`

hr=`echo $time | awk '{print $1}'`
min=`echo $time | awk '{print $2}'`
sec=`echo $time | awk '{print $3}'`

n=`echo $year | awk '{if($1%400 == 0) print 1 ; else if($1%100 == 0) print 0 ; else if($1%4 == 0) print 1 ; else print 0 }'`
if [ $n -eq 0 ]
then

	jd=`cat years.txt | awk -v k=$month -v d=$day 'BEGIN{
	}

	NR<=k  {
	l[NR]=$2
	sum+=l[NR]
	}

	END {
	s=sum+d
	print s
	
	}'`
	hr1=`echo $hr | awk '{if($1==23) print "00" ; else print $1+1}' | awk '{if($1<=9 && $1>0) print "0"$1 ; else print $1}'`
	jd1=`echo $jd $hr | awk '{if($2==23) print $1+1 ; else print $1}'`
	
	new=`cat years.txt | awk -v j=$jd1 -v yer=$year  'BEGIN{
	}
	NR>0 && NR<=13{
	l[NR]=$2
	sum+=l[NR]
	summ[NR]=sum
	}
	END{
		if(j<366)
			for(i=1;i<=12;i++)
				if(summ[i]<j && summ[i+1]>=j)
					print yer,i,j-summ[i]
		else if(j==366)
			print yer+1,1,1
	}'`


elif [ $n -eq 1 ]
then

	jd=`cat years.txt | awk -v k=$month -v d=$day 'BEGIN{
	}

	NR<=k  {
	l[NR]=$3
	sum+=l[NR]
	}

	END {
	s=sum+d
	print s
	
	}'`
	hr1=`echo $hr | awk '{if($1==23) print "00" ; else print $1+1}' | awk '{if($1<=9 && $1>0) print "0"$1 ; else print $1}'`
	jd1=`echo $jd $hr | awk '{if($2==23) print $1+1 ; else print $1}'`
	
	new=`cat years.txt | awk -v j=$jd1 -v yer=$year  'BEGIN{
	}
	NR>0 && NR<=13{
	l[NR]=$3
	sum+=l[NR]
	summ[NR]=sum
	}
	END{
		if(j<367)
			for(i=1;i<=12;i++)
				if(summ[i]<j && summ[i+1]>=j)
					print yer,i,j-summ[i]
		else if(j==367)
			print yer+1,1,1
	}'`

	
fi
year1=`echo $new | awk '{print $1}'`
month1=`echo $new | awk '{print $2}' | awk '{if($1<=9) print "0"$1 ; else print $1}'`
day1=`echo $new | awk '{print $3}' | awk '{if($1<=9) print "0"$1 ; else print $1}'`
min1=$min
sec1=$sec
echo "WT02" "Y2" $year $month $day $hr $min $sec $year1 $month1 $day1 $hr1 $min1 $sec1 "3" "HHE" "HHN" "HHZ"  >> sent.txt
#only above line needs to be changed i.e station code and network code
done
