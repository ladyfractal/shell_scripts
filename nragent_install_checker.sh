#!/bin/bash
#-----------------------------------------------------------------#
#       Name:  nragent_checker.sh                                 #
#   Function:  Checks NR Java agent install                       #
#   Language: Bourne Shell (sh)                                   #
#                                                                 #
# Parameters: ticket#                                                #
#      usage: nragent_checker.sh <ticket#>                                         #
#-----------------------------------------------------------------#

linux_distro=$( lsb_release -a | grep Description | awk '{ print $2 }' )

opsys=$linux_distro


#Declare functions


GetOS()

{
baseOS=$( uname -a | awk '{ print $1 }' ) #Check to see if Linux or OS X (will do checks for Solaris and HPUX later)

#Once we determine if it is Linux or OSX detemine the flavor of Linux

}

psOSX()

{
cat_startup=( $( ps -ef -o user,pid,command,args | grep -i Bootstrap | grep -v grep))

cat_user=${cat_startup[8]}   #user that started dispatcher
cat_PID=${cat_startup[9]}    #PID of dispatcher
agent_jar=$( cut -c 12- <<< ${cat_startup[14]} ) #Location of NR Java agent jar file
cat_base=$( cut -c 17- <<< ${cat_startup[19]} ) #Directory of $CATALINA_BASE
cat_home=$( cut -c 17- <<< ${cat_startup[20]} ) #Directory of $CATALINA_HOME
cat_temp=$( cut -c 17- <<< ${cat_startup[21]} ) #Temp DirectoryService
agent_log=$( cut -c 17- <<< ${cat_startup[20]} )/newrelic/logs

printf "%s\n" "Here is the current state of your NR Java Agent install" 
printf "%s\n" "Tomcat started by $cat_user"
printf "%s\n" "Tomcat's PID is $cat_PID"
printf "%s\n" "The New Relic Java Agent is located in $agent_jar"
printf "%s\n" "CATALINA_BASE is currently set to $cat_base"
printf "%s\n" "CATALINA_HOME is currently set to $cat_home"
printf "%s\n" "Catalina is using $cat_temp as the temporary file location."
printf "%s\n" "The agent log files are being written to $agent_log."

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

printf "%s\n" "Here is the current state of your NR Java Agent install" 
printf "%s\n" "Tomcat started by $cat_user"
printf "%s\n" "Tomcat's PID is $cat_PID"
printf "%s\n" "The New Relic Java Agent is located in $agent_jar"
printf "%s\n" "CATALINA_BASE is currently set to $cat_base"
printf "%s\n" "CATALINA_HOME is currently set to $cat_home"
printf "%s\n" "Catalina is using $cat_temp as the temporary file location."
printf "%s\n" "The agent log files are being written to $agent_log."

}

psSuSE()

{


cat_startup=( $( ps -ef --sort user,pid,command,args | grep -i Bootstrap | grep -v \ grep)) 

cat_user=${cat_startup[0]}   #user that started dispatcher
cat_PID=${cat_startup[1]}    #PID of dispatcher
agent_jar=$( cut -c 12- <<< ${cat_startup[8]} ) #Location of NR Java agent jar file
cat_base=$( cut -c 17- <<< ${cat_startup[11]} ) #Directory of $CATALINA_BASE
cat_home=$( cut -c 17- <<< ${cat_startup[12]} ) #Directory of $CATALINA_HOME
cat_temp=$( cut -c 17- <<< ${cat_startup[13]} ) #Temp Directory
agent_log=$( cut -c 17- <<< ${cat_startup[12]} )/newrelic/logs

printf "%s\n" "Here is the current state of your NR Java Agent install" 
printf "%s\n" "Tomcat started by $cat_user"
printf "%s\n" "Tomcat's PID is $cat_PID"
printf "%s\n" "The New Relic Java Agent is located in $agent_jar"
printf "%s\n" "CATALINA_BASE is currently set to $cat_base"
printf "%s\n" "CATALINA_HOME is currently set to $cat_home"
printf "%s\n" "Catalina is using $cat_temp as the temporary file location."
printf "%s\n" "The agent log files are being written to $agent_log."

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
	*)echo  "OS Not Detected"
	;;
esac
