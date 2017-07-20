#!/bin/sh

#nragent_install_check
#Adrienne J Davis
#adavis@newrelic.com
#V 1.1
#Changelog added banner to tell the customer what the script will do
#12 June 2014
#This script tests for certain conditions that are required for the New Relic Java agent to function.
#Specifically, it prompts the user to input the installation directory for Tomcat
#then makes certain that catalina.sh contains two variables required by the Java agent.

#Print a header that says what the script is

printf "%s\n\n" "New Relic Java Agent Install Sanity Checker." 

#Create a banner

# Build long string of equals signs
divider=========================
divider=$divider$divider


# Width of divider
totalwidth=44

printf "%s\n\n" "$divider$divider$divider"

printf "%s\n\n" "This diagnostic script will ask you to input the location of Tomcat. It will then check following to see if Tomcat lives where you think it does, if the catalina.sh file exists in the tomcat/bin directory, if there is a newrelic directory immediately under tomcat, if that directory contains a newrelic.jar file and if the catalina.sh has a variable set called NR_JAR which points to the newrelic.jar file and if $NR_JAR is set correctly in JAVA_OPTS.  This will all be printed to STDOUT. You can then copy and paste the information into a ticket if you so desire."

printf "%s\n\n" "$divider$divider$divider"


#Prompt the user for the directory that contains Tomcat

printf "%s\n\n" "Please enter a directory name and hit [Enter]."

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
		printf "%s\n" "newrelic.jar file found in $_catalina/newrelic." 	
			else 
			printf "%s\n" "No newrelic.jar found in $_catalina/newrelic." 
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




