#! /bin/bash
#Faisal Khan
#Student Number: S1828698


trap trash_terminated EXIT 

trash_terminated(){

	echo " " 
	echo -n "Total number of files in you're TrashCan: "  

cd ~/.trashCan && ls -l | grep ^- | wc -l 

if [ "$(ls -A ~/.trashCan)" ]; then 

	size=$(cd ~/.trashCan && find -type f -print0 | xargs -0 stat --print='%s\n' | awk '{total+=$1} END {print total}') 
	
	
	echo "TrashCan is currently $size bytes"	

	size=$(( $size/1024 )) 

	if [ $size -gt 1 ] || [ $size -eq 1 ] ;then 

		printf "WARNING! Your trash directory exceeds 1 KBytes\nIt is recommended you empty trash or delete some files\n"s
	fi
else
	printf "TrashCan Is Empty\n"
fi

}


if [ -d ~/.trashCan ]; then
	printf "Hello Faisal Khan. Student Number:S1828698 \n"
	printf "The folder trashCan already exists\n"
	printf "\n"
else
	mkdir -m 777 ~/.trashCan 
	printf "Successfully created trashCan folder\nPlease select one of the follwing options:\n"
fi



list(){

if [ "$(ls -A ~/.trashCan)" ]; then
	cd ~/.trashCan && stat -c "Name: "%n" ---Size: "%s" Bytes ---Type: "%F *
else
	printf "TrashCan Directory Is Empty\n"
fi

}



recover(){

if [ "$(ls -A ~/.trashCan)" ]; then
	echo -n "Enter File To Recover:"
        read fileToRecover 

	FILE=~/.trashCan/$fileToRecover

 	if [ -f "$FILE" ] || [ -d "$FILE" ]; then
   		mv $FILE .
		printf "The file '$fileToRecover' has been successfully recovered\n"
	else
   		printf "The file '$fileToRecover' does not exist so can't be recovered\n"
	fi

	else
		printf "TrashCan directory is empty\nNo Files Available To Recover\n"
fi

}



delete(){

if [ "$(ls -A ~/.trashCan)" ]; then
	for fileName in ~/.trashCan/*; do

		read -n1 -p "Are you sure you want to DELETE $fileName? [Y/N]" input 
		case $input in
			y|Y)	rm $fileName
				printf "\nFile Deleted Successfully\n";;
		
			n|N)	printf "\nDeletion Cancelled\n";;

			*)	printf "\nNot A Valid Choice. Please Choose Either Y/N\n";;
		esac

	done
else
	printf "TrashCan Directory Is Empty\nNo Files Available To Delete\n"
fi

}




total(){

total_usage=0
	
for user in /home/*
	do
		if [ -d $user/.trashCan ] && [ "$(ls -A $user/.trashCan)" ]; then
		size="$(cd $user/.trashCan && find -type f -print0 | xargs -0 stat --print='%s\n' | awk '{total+=$1} END {print total}')"

			echo "$user -> $size bytes"

			(( total_usage += $size )) 
			printf "\n"

		fi

	done
	echo "total usage: $total_usage Bytes"

}




monitor(){

	xfce4-terminal -x ~/Desktop/monitor.sh &
	printf "Monitor Script Running\n"
}




kill(){
	
	ps -ef | grep monitor | awk '{print $2}' | xargs kill -9
	printf "Monitor Script Closed\n"

}

if [ "$1" == "file" ]; then 	
	if [ ! -z $2 ]; then 	
		if [ -f $2 ] || [ -d $2 ]; then
		       	mv $2 ~/.trashCan ;
			printf "The File '$2' Has Been Moved To TrashCan Successfully"
     		else
       			printf "The File '$2' Does Not Exist So Can't Be Moved" 
     		fi
   	else
    		printf "Please Enter The Name Of The File You Wish To Move" 
  	fi
else

USAGE="usage: $0 [-l] [-r] [-d] [-t] [-m] [-k]" 
	 
while getopts :lr:dtmk args 	
do
  case $args in
     l) list ;;
     r) recover ;;
     d) delete ;; 
     t) total ;; 
     m) monitor &;; 
     k) kill ;;     
     :) echo "Data Missing, option -$OPTARG";;
    \?) echo "Unknown Option: -$USAGE";;
  esac
done

fi

((pos = OPTIND - 1))
shift $pos

PS3='option> '

if (( $# == 0 ))
then if (( $OPTIND == 1 )) 
 then select menu_list in list recover delete total monitor kill exit
      do case $menu_list in
         "list") list ;;
         "recover") if [ "$(ls -A ~/.trashCan)" ]; then
			echo -n "Enter File To Recover:"
                            read fileToRecover 
                            FILE=~/.trashCan/$fileToRecover 
                          if [ -f "$FILE" ] || [ -d "$FILE" ]; 
                          then
                              mv $FILE .
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
         *) echo "Unknown Option. Please select one of the valid options";;
         esac
      done
 fi
else echo 1>&2; exit 1  
fi




