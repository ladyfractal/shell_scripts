#!/bin/bash 
#-----------------------------------------------------------------
#       Name:        Agent Sanity Checker                         
#   Function:  Checks NR Java agent install                       
#   Language: Bourne Shell (sh)                                   
#    Author:  Adrienne Davis (adavis@newrelic.com)                                                                                                         
#      usage: agent_sanity_chk.sh 
# Version 2.0                      
#-----------------------------------------------------------------

#Setup the banner
banner=*****
banner_short=$banner
banner_long=$banner$banner$banner$banner

#To be safe, going to write to the pwd 

current_dir=`pwd`

#Explanation of the script

printf "%s\n" "$banner_long$banner_long"
printf "%s\n"
printf "%s\n" "Welcome to the New Relic Java Agent Install Sanity Check!"
printf "%s\n" "This script will do a ps to get information about your dispatcher. It will then write the user, PID, the java command, the location of Tomcat, the location of the Java agent itself, and the location of the dispatcher's temp directory. It will write this into a file and put it in a directory which you will provide the name for by providing your ticket number. This directory will be written to your current working directory.  The script will take a copy of the Java agent's log file and put it in the directory.  It will then tar and gzip the directory so that you can attach it to the ticket for the support engineer working with you to review."
printf "%s\n"
printf "%s\n" "$banner_long$banner_long"
printf "%s\n"
printf  "%s" "$banner_short"  "Please enter your ticket number to get started." 
printf "%s\n"

#Get the ticket number and validate that it has between 5 and 8 numerical characters
read ticketnum

[[ "$ticketnum" =~  [[:num:]]{5,8} ]] && echo "You entered $ticketnum."

#Make a directory to contain files that will be zipped  up 

if [ -d "$current_dir/$ticketnum" ];
	then printf "%s\n" "Using directory $current_dir/$ticketnum"
		else printf "%s\n" "Creating directory $current_dir/$ticketnum"
		mkdir "$current_dir/$ticketnum"
fi

#Determine the OS as this will determines syntax of ps

baseOS=$( uname -a | awk '{ print $1 }' ) #Check to see if Linux or OS X	

if [  $baseOS = "Darwin" ] ; then
	opsys="Darwin"
		else
			linux_distro=$( lsb_release -d | awk '{ print $2 }' )
			opsys=$linux_distro
fi

#setup a temp directory
tmp_dir=`mktemp -d 2>/dev/null || mktemp -d -t 'tmp_dir'`

#Functions

#Set up printing report 

report()

{

printf "%s\n" "Here is the current state of your NR Java Agent install" 
printf "%s\n" "Tomcat started by $cat_user"
printf "%s\n" "Tomcat's PID is $cat_PID"
printf "%s\n" "The New Relic Java Agent is located in $agent_jar"
printf "%s\n" "CATALINA_BASE is currently set to $cat_base"
printf "%s\n" "CATALINA_HOME is currently set to $cat_home"
printf "%s\n" "Catalina is using $cat_temp as the temporary file location."
printf "%s\n" "The agent log files are being written to $agent_log."

}

report_generic()

{

printf "%s\n" "Here is what we know:" "${cat_startup[*]}"

}

psOSX()

{

cat_startup=( $( ps -ef -o user,pid,command,args | grep -i Bootstrap | grep -v grep))

cat_user=${cat_startup[8]}   #user that started dispatcher
cat_PID=${cat_startup[9]}    #PID of dispatcher
agent_jar=$( cut -c 12- <<< ${cat_startup[14]} ) #Location of NR Java agent jar file
cat_base=$( cut -c 17- <<< ${cat_startup[19]} ) #Directory of $CATALINA_BASE
cat_home=$( cut -c 17- <<< ${cat_startup[20]} ) #Directory of $CATALINA_HOME
cat_temp=$( cut -c 18- <<< ${cat_startup[21]} ) #Temp DirectoryService
agent_log=$( cut -c 17- <<< ${cat_startup[20]} )/newrelic/logs

report | tee  $tmp_dir/$ticketnum-report.txt
cp $tmp_dir/$ticketnum-report.txt  $current_dir/$ticketnum


}

psUbuntu()

{

cat_startup=( $( ps -ef --sort user,pid,command,args | grep -i Bootstrap | grep -v \ grep)) 

cat_user=${cat_startup[0]}   #user that started dispatcher
cat_PID=${cat_startup[1]}    #PID of dispatcher
agent_jar=$( cut -c 12- <<< ${cat_startup[13]} ) #Location of NR Java agent jar file
cat_base=$( cut -c 17- <<< ${cat_startup[18]} ) #Directory of $CATALINA_BASE
cat_home=$( cut -c 17- <<< ${cat_startup[19]} ) #Directory of $CATALINA_HOME
cat_temp=$( cut -c 18- <<< ${cat_startup[20]} ) #Temp DirectoryService
agent_log=$( cut -c 17- <<< ${cat_startup[19]} )/newrelic/logs

report | tee  $tmp_dir/$ticketnum-report.txt
cp $tmp_dir/$ticketnum-report.txt  $current_dir/$ticketnum

}

psSuSE()

{


cat_startup=( $( ps -ef --sort user,pid,command,args | grep -i Bootstrap | grep -v \ grep)) 

cat_user=${cat_startup[0]}   #user that started dispatcher
cat_PID=${cat_startup[1]}    #PID of dispatcher
agent_jar=$( cut -c 12- <<< ${cat_startup[8]} ) #Location of NR Java agent jar file
cat_base=$( cut -c 17- <<< ${cat_startup[11]} ) #Directory of $CATALINA_BASE
cat_home=$( cut -c 17- <<< ${cat_startup[12]} ) #Directory of $CATALINA_HOME
cat_temp=$( cut -c 18- <<< ${cat_startup[14]} ) #Temp Directory
agent_log=$( cut -c 17- <<< ${cat_startup[12]} )/newrelic/logs

report | tee  $tmp_dir/$ticketnum-report.txt
cp $tmp_dir/$ticketnum-report.txt  $current_dir/$ticketnum

}

psCentOS()

{


cat_startup=( $( ps -eo user,pid,comm,args | grep -i Bootstrap | grep -v \ grep)) 

cat_user=${cat_startup[0]}   #user that started dispatcher
cat_PID=${cat_startup[1]}    #PID of dispatcher
agent_jar=$( cut -c 12- <<< ${cat_startup[6]} ) #Location of NR Java agent jar file
cat_base=$( cut -c 17- <<< ${cat_startup[10]} ) #Directory of $CATALINA_BASE
cat_home=$( cut -c 18- <<< ${cat_startup[11]} ) #Directory of $CATALINA_HOME
cat_temp=$( cut -c 18- <<< ${cat_startup[12]} ) #Temp Directory
agent_log=$( cut -c 17- <<< ${cat_startup[10]} )/newrelic/logs

report | tee  $tmp_dir/$ticketnum-report.txt
cp $tmp_dir/$ticketnum-report.txt  $current_dir/$ticketnum

}

psDebian()

{

cat_startup=( $( ps -ef --sort user,pid,command,args | grep -i Bootstrap | grep -v \ grep)) 

cat_user=${cat_startup[0]}   #user that started dispatcher
cat_PID=${cat_startup[1]}    #PID of dispatcher
agent_jar=$( cut -c 12- <<< ${cat_startup[13]} ) #Location of NR Java agent jar file
cat_base=$( cut -c 17- <<< ${cat_startup[18]} ) #Directory of $CATALINA_BASE
cat_home=$( cut -c 17- <<< ${cat_startup[19]} ) #Directory of $CATALINA_HOME
cat_temp=$( cut -c 18- <<< ${cat_startup[20]} ) #Temp DirectoryService
agent_log=$( cut -c 17- <<< ${cat_startup[19]} )/newrelic/logs

report | tee  "$tmp_dir/report.txt"
mv $tmp_dir/report.txt ~

}

psFedora()

{

cat_startup=( $( ps -ef --sort user,pid,command,args | grep -i Bootstrap | grep -v \ grep)) 

cat_user=${cat_startup[0]}   #user that started dispatcher
cat_PID=${cat_startup[1]}    #PID of dispatcher
agent_jar=$( cut -c 12- <<< ${cat_startup[10]} ) #Location of NR Java agent jar file
cat_base=$( cut -c 17- <<< ${cat_startup[14]} ) #Directory of $CATALINA_BASE
cat_home=$( cut -c 17- <<< ${cat_startup[15]} ) #Directory of $CATALINA_HOME
cat_temp=$( cut -c 18- <<< ${cat_startup[16]} ) #Temp Directory
agent_log=$( cut -c 17- <<< ${cat_startup[14]} )/newrelic/logs

report | tee  $tmp_dir/$ticketnum-report.txt
cp $tmp_dir/$ticketnum-report.txt  $current_dir/$ticketnum

}

case "$opsys" in 
	"Darwin")
	printf "%s\n" "Detected OSX"
	psOSX
	;;
	"Ubuntu")
	printf "%s\n" "Detected Ubuntu"
	psUbuntu
	;;
	"openSUSE")
	printf "%s\n" "Detected SuSE"
	psSuSE
	;;
	"CentOS")
	printf "%s\n" "Detected CentOS"
	psCentOS
	;;
	"Debian")
	printf "%s\n" "Detected Debian"
	psDebian
	;;
	"Fedora")
	printf "%s\n" "Detected Debian"
	psFedora
	;;
	*)echo  "Unable to determine specific Linux distribution. Falling back to unparsed ouput."
	cat_startup=( $( ps -ef --sort user,pid,command,args | grep -i Bootstrap | grep -v \ grep)) 
			
	report _generic | tee  $tmp_dir/$ticketnum-report.txt
	cp $tmp_dir/$ticketnum-report.txt  $current_dir/$ticketnum
	;;
esac

if [ -f $agent_log/newrelic_agent.log  ]; then
	cp $agent_log/newrelic_agent.log $current_dir/$ticketnum
	printf "%s\n" "Copying newrelic_agent.log file to $current_dir/$ticketnum"
fi

if [ -f $current_dir/$ticketnum/$ticketnum-report.txt  -a -f $current_dir/$ticketnum/newrelic_agent.log  ]; then
	tar cvfz $current_dir/$ticketnum.tar.gz $ticketnum/
fi

#Clean up after ourselves before quitting
cleanup="rm -rf $temp_dir"
trap "$cleanup" ABRT EXIT HUP INT QUIT

exit 0