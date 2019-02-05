#!/bin/bash
#Faisal Khan
#Student Number: S1828698

printf "Hello Faisal Khan. Student Number:S1828698 \n"
echo "MONITOR SCRIPT RUNNING"

sleep 5		#Waits for 5 seconds before running the watch statement

watch -n 15 ls ~/.trashCan/	#Displays the files in the trashCan directory and updates every 15 seconds

