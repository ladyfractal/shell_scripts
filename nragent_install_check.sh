#!/bin/sh

#nragent_install_check
#Adrienne J Davis
#adavis@newrelic.com
#V 1.0
#10 June 2014
#This script tests for certain conditions that are required for the New Relic Java agent #to function.
#Specifically, it prompts the user to input the installation directory for Tomcat
#then makes certain that catalina.sh contains two variables required by the Java agent.

#Prompt the user for the directory that contains Tomcat

printf "%s\n" "Please enter a filename and hit [Enter]."

read _catalina

#Test to make certain that the Tomcat directory is correct

if [ -d $_catalina ] ; then
	printf "%s\n" "Tomcat located at $_catalina"
	start_catalina=$_catalina/bin/catalina.sh ##Set the tomcat directory and path to
											  ##catalina.sh 
		else
	printf "%s\n" "No Tomcat found at designated location"
	exit 1
	
fi

#Test to see if there is a newrelic directory and if that directory contains a newrelic.jar
if [ -d $_catalina/newrelic ]; then
		if [ -f $_catalina/newrelic/newrelic.jar ]; then
		printf "%s\n" "newrelic.jar file found in $_catalina/newrelic/newrelic.jar" 	
			else 
			printf "%s\n" "No newrelic.jar found in $_catalina/newrelic/newrelic.jar." 
			exit 1
		fi
	else
	printf "%s\n" "No newrelic directory found in $_catalina." 
	exit 1
fi

#Test for newrelic.jar pointer in catalina.sh
if [ -f $start_catalina ]; then
	grep -q newrelic.jar $start_catalina
	echo $? 2&>1
		if [ $? = 0 ]; then
		grep -q newrelic.jar $start_catalina
		echo $? 2&>1
			if [ $? = 0 ]; then
					printf "%s\n" "Variables set correctly in $start_catalina." 
						else "%s\n" "The JAVA_OPTS variable is not set. Please set it." 					
				fi
			else printf "%s\n" "NR_JAR variabe not correctly set. Please set it." 
			fi
	else printf "%s\n" "Variables not set correctly in $start_catalina"
	
fi

exit 0




