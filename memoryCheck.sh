#!/bin/bash

#for CPU usage
USED=$(mpstat | awk 'FNR==4 {print $4}')
#user defined limit
max=2
echo ${USED%.*} $max
#checking
if [[ ${USED%.*} -gt $max ]]; then
	#open process list in new terminal if condition met
	DISPLAY=:0 konsole --noclose -e bash -c "/home/kkekre/Desktop/listOfProcess.sh" &
else
	exit 0
fi
