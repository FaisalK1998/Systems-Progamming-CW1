#! /bin/bash
#Faisal Khan
#Student Number: S1828698


trap trash_terminated EXIT 	#Runs function for trap when the user selects the exit option

trash_terminated(){ 		#Trap function

	echo " " #new line
	
	echo -n "Total number of files in you're TrashCan: "  #shows the total number of files in the trashCan directory

cd ~/.trashCan && ls -l | grep ^- | wc -l 	#Retrieves all files in the trashCan and displays number of items

if [ "$(ls -A ~/.trashCan)" ]; then 	#Checks if trashCan directory is not empty

	size=$(cd ~/.trashCan && find -type f -print0 | xargs -0 stat --print='%s\n' | awk '{total+=$1} END {print total}') 
	#Stores the size of the trashCan directory, finds all the files in trashCan and their sizes and adds them together
	
	echo "TrashCan is currently $size bytes"	#Displays the current size of trashCan

	size=$(( $size/1024 )) 		#Converts the size from bytes to Kilobytes

	if [ $size -gt 1 ] || [ $size -eq 1 ] ;then 	#Checks if the size of trashCan is greater than or equal to 1 Kilobyte

		printf "WARNING! Your trash directory exceeds 1 KBytes\nIt is recommended you empty trash or delete some files\n"
	fi
else
	printf "TrashCan is Empty\n"
fi

}



if [ -d ~/.trashCan ]; then	#Checks if the trashCan directory exists
	printf "Hello Faisal Khan. Student Number:S1828698 \n"
	printf "The folder trashCan already exists\nPlease select one of the following options:\n"
else
	mkdir  mkdir -m 777 ~/.trashCan		#Creates the trashCan directory if it doesn't exist
	printf "Successfully created trashCan folder\nPlease select one of the follwing options:\n"
fi



list(){		#List function to retrieve the contents of the trashCan directory with name, size and file type

if [ "$(ls -A ~/.trashCan)" ]; then	#Checks if the directory is not empty

	cd ~/.trashCan && stat -c "Name: "%n" ---Size: "%s" ---Type: "%F *	#Displays the contents of the directory
else
	printf "TrashCan Directory Is Empty\n"
fi

}



recover(){	#Recover function recovers the specified file from the trashCan directory and places it in the current directory

if [ "$(ls -A ~/.trashCan)" ]; then	#Checks if the trashCan directory is empty

	FILE=~/.trashCan/$fileToRecover	#Locates the specified file

 	if [ -f "$FILE" ] || [ -d "$FILE" ]; then	#Checks if the selected file exists
   			mv $FILE .		#Moves selected file to current directory

			printf "The file '$fileToRecover' has been successfully recovered\n"
		else
   			printf "The file '$fileToRecover' does not exist so can't be recovered\n"
		fi
		else
			printf "TrashCan directory is empty\nNo Files Available To Recover\n"
fi

}



delete(){	#Delete function removes the selected file from the trashCan directory

if [ "$(ls -A ~/.trashCan)" ]; then	#Checks if the trashCan directory is empty
	for fileName in ~/.trashCan/*; do	#The follwing case statement will be run for every file in trashCan

		read -n1 -p "Are you sure you want to DELETE $fileName? [Y/N]" input 	#Asks user for their option
		case $input in
			y|Y)	rm $fileName	#Deletes the selected file if the Y option is selected
				printf "\nFile Deleted Successfully\n";;
		
			n|N)	printf "\nDeletion Cancelled\n";;

			*)	printf "\nNot A Valid Choice. Please Choose Either Y/N\n";;
		esac

	done
else
	printf "TrashCan Directory Is Empty\nNo Files Available To Delete\n"
fi

}




total(){	#Total function display the total usage in bytes of the trashCan directory

total_usage=0
	
for user in /home/*	#Retrieves every user in the home directory
	do
		if [ -d $user/.trashCan ] && [ "$(ls -A $user/.trashCan)" ]; then		#Checks if the user has trashCan directory and if it is empty
		size="$(cd $user/.trashCan && find -type f -print0 | xargs -0 stat --print='%s\n' | awk '{total+=$1} END {print total}')" #Stores the size of the trashCan directory, 
																#finds all the files in trashCan and their sizes and adds them together

			echo "$user -> $size bytes"	#Displays the user and the size in bytes

			(( total_usage += $size )) 	#Adds all the files in trashCan directory
			printf "\n"

		fi

	done
	echo "total usage: $total_usage Bytes" 		#Displays the total usage of trash for all users added together

}




monitor(){	#Monitor function displays the creation, change and deletion of files in the trashCan directory

	xfce4-terminal -x ~/Desktop/monitor.sh &	#Opens the monitor script in a separate terminal window
}




kill(){		#Kill function exits the monitor script
	
	ps -ef | grep monitor | awk '{print $2}' | xargs kill -9	#Kills the monitor script when the process is found
	printf "Monitor Script Closed\n"

}


if [ "$1" == "file" ]; then 	#Checks for the 'file' command when run
	if [ ! -z $2 ]; then 		#Checks if the user entered more text for the file they want to move to trash
		if [ -f $2 ] || [ -d $2 ]; then		#Checks if the file exists and is not a directory
		       	mv $2 ~/.trashCan ; 	#Moves the file to trashCan directory if it exists
			printf "The File '$2' Has Been Moved To TrashCan Successfully"
     		else
       			printf "The File '$2' Does Not Exist So Can't Be Moved" 	
     		fi
   	else
    		printf "Please Enter The Name Of The File You Wish To Move"
  	fi
else

USAGE="usage: $0 [-l] [-r] [-d] [-t] [-m] [-k]" 
	 
while getopts :lr:dtmk args 	#Options
do
  case $args in		#Each case argument calls its own function
     l) list ;;
     r) recover ;;
     d) delete ;; 
     t) total ;; 
     m) monitor &;; 
     k) kill ;;     
     :) echo "data missing, option -$OPTARG";;
    \?) echo "unknown option: -$USAGE";;
  esac
done

fi

((pos = OPTIND - 1))
shift $pos

PS3='option> '

if (( $# == 0 ))
then if (( $OPTIND == 1 )) 
 then select menu_list in list recover delete total monitor kill exit	#Lists these in the menu as options
      do case $menu_list in
         "list") list ;;
         "recover")  if [ "$(ls -A ~/.trashCan)" ]; then
			echo -n "Enter File To Recover:"	#Asks the user to enter the file they want to recover
                            read fileToRecover 			#Takes in users input
                            FILE=~/.trashCan/$fileToRecover 	#Holds user's input
                          if [ -f "$FILE" ] || [ -d "$FILE" ]; 		#Checks if the file exists
                          then
                              mv $FILE .		#If the file exists it is moved to the current directory
			      printf "The file '$fileToRecover' has been successfully recovered\n"
			  else
                              printf "The file '$fileToRecover' does not exist so can't be recovered\n"
                          fi
		     else
			  printf "TrashCan directory is empty\n"
		     fi;;
         "delete") delete ;;
         "total") total ;;
         "monitor") monitor & ;;
         "kill") kill ;;
         "exit") exit 0;;
         *) echo "Unknown Option. Please select one of the valid options";;	#Displays if an invalid option is chosen
         esac
      done
 fi
else echo 1>&2; exit 1
fi




