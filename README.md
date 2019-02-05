# Systems-Progamming-CW1
safeDel – A bash Script Utility for better File Deletion

The following commands can be executed in the program:


-l output a list on screen of the contents of the trashCan directory; output should
		be properly formatted as “file name” (without path), “size” (in bytes) and “type”
    for each file ("safeDel.sh -l")
    
    
-r recover i.e. get a specified file from the trashCan directory and place it in the
    current directory  ("safeDel.sh -r file")
    
    
-d delete interactively the contents of the trashCan directory. This means that you
    ask the user if they want to delete each file in turn. ("safeDel.sh -d")
    
    
-t display total usage in bytes of the trashCan directory for the user of the trashcan
    ("safeDel.sh –t")
    
    
-m start monitor script process (see requirements below i.e. "safeDel.sh –w")


-k kill current user’s monitor script processes (i.e. "safeDel.sh –k")


The getopts statement is used to implement the command line argument parsing and the select 
statement is used to implement the menu.
