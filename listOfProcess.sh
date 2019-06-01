#!/bin/bash
echo "List of processes" >/tmp/summary.txt
echo " " >>/tmp/summary.txt
ps -eo pid,comm,%mem,%cpu --sort=-%cpu | head
ps -eo pid,comm,%mem,%cpu --sort=-%cpu | head >>/tmp/summary.txt
BEFORE=$(mpstat | awk 'FNR==4 {print $4}')
FILE=/tmp/summary.txt
read -p "Do u want to modify(y/n)?: " fchoice
if [ $fchoice = "y" ]||[ $fchoice = "Y" ];then
	read -p "Which process do u wish to modify: " proId
	read -p "What should be the cpu usage limit for this process: " limit
	read -p "process $proId would only be allowed $limit % of CPU usage.Are you sure (y/n)?": choice
	if [ $choice = "y" ]||[ $choice = "Y" ];then
		echo "">>/tmp/summary.txt
		echo "You added a CPU usage limit of $limit % on the process $proId">>/tmp/summary.txt 
		echo "">>/tmp/summary.txt
		echo "Before" >>/tmp/summary.txt
		ps -p $proId -o pid,comm,%mem,%cpu --sort=-%cpu >>/tmp/summary.txt
		sudo cpulimit --pid $proId --limit $limit -b
		sleep 4s
		AFTER=$(mpstat | awk 'FNR==4 {print $4}')
		echo "CPU usage limit added . PLease check your email for details about changes made."
		CHANGE=$(echo "($BEFORE-$AFTER)"| bc -l)
		notify-send -i /home/kkekre/Downloads/warning.png "High CPU Usage" "Please check your email"
		echo " " >>/tmp/summary.txt
		echo "After">>/tmp/summary.txt
		ps -p $proId -o pid,comm,%mem,%cpu --sort=-%cpu >>/tmp/summary.txt
		echo "" >>/tmp/summary.txt		
		echo "Change in user CPU usage (in %) = $CHANGE" >>/tmp/summary.txt	
		mpack -s "CPU usage limitation summary" "$FILE" kkekre90@gmail.com	
		exit 0
	elif [ $choice = "n" ]||[ $choice = "N" ];then

		echo "No modifications done"

	else
		echo "Invalid choice"
		sleep 1
		echo "PLease try again"
		echo ""
		echo ""
		/home/kkekre/Desktop/listOfProcess.sh
	
	fi	
	exit 0 
elif [ $fchoice = "n" ]||[ $fchoice = "N" ];then
	echo "Exiting"
	exit 0
else 
	echo "Invalid choice"
	sleep 1
	echo "PLease try again"
	echo ""
	echo ""
	
	/home/kkekre/Desktop/listOfProcess.sh
	exit 0
	
fi
