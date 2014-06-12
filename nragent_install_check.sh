#!/bin/sh


#nragent_install_check
#Adrienne J Davis
#adavis@newrelic.com
#V 1.0
#10 June 2014
#This script tests for certain conditions that are required for the New Relic Java agent to function.
#Specifically, it prompts the user to input the installation directory for Tomcat
#then makes certain that catalina.sh contains two variables required by the Java agent.

#Prompt the user for the directory that contains Tomcat

printf "%s\n" "Please enter a filename and hit [Enter]."

read _catalina

#Test to make certain that the Tomcat directory is correct

if [ -d $_catalina ] ; then
	printf "%s\n" "Tomcat located at $_catalina."
	start_catalina=$_catalina/bin/catalina.sh ##Set the tomcat directory and path to
											  ##catalina.sh 
		else
	printf "%s\n" "No Tomcat found at designated location."
	exit 1
	
fi

#Test to see if there is a newrelic directory and if that directory contains a newrelic.jar
if [ -d $_catalina/newrelic ]; then
		if [ -f $_catalina/newrelic/newrelic.jar ]; then
		printf "%s\n" "newrelic.jar file found in $_catalina/newrelic/newrelic.jar." 	
			else 
			printf "%s\n" "No newrelic.jar found in $_catalina/newrelic/newrelic.jar." 
			exit 1
		fi
	else
	printf "%s\n" "No newrelic directory found in $_catalina." 
	exit 1
fi


#Test to see if the newrelic.jar variable is set in catalina.sh
grep -q newrelic.jar $start_catalina 
exitval=$?
echo $exitval 2&>1

if [ $exitval -eq 0 ]; then
	printf "%s\n" "newrelic.jar variable set correctly."
else
	printf "%s\n" "newrelic.jar variable not correctly set. Please set it."
fi

#Test to see if $NR_JAR set in JAVA_OPTS
grep -q $\NR_JAR $start_catalina
exitval2=$? 
echo $exitval2 2&>1
if [ $exitval2 -eq 0 ]; then
	printf "%s\n" "NR_JAR variable set correctly."
else
	printf "%s\n" "NR_JAR variable not set correctly. Please set it."

fi					

#Test to see if both variables are set correctly.
if [[ $exitval == $exitval2 && $exitval = 0 && $exitval2 = 0 ]]; then
	printf "%s\n" "Both variables set correctly. Everything looks ok."
else 
	printf "%s\n" "One or more of your variables not set correctly. Please see above for  which variable(s) to fix." 
fi

exit 0




