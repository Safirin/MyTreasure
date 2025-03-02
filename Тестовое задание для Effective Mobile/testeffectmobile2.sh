#!/bin/bash

while true; do

PID_for_record="/home/rinat/Interview/PID_file" #Location of the PID id
monitoring_file="/home/rinat/Interview/monitoring.log" #Location of the monitring file
uri="http://kareliaminerhub.ru:80" #Uniform Resource Identifier 
date_of_event=$(date) #Time and Date of the process


current_PID=$(ps aux | grep '/bin/bash ./testeffectmobile1.sh' | grep -v grep | awk '{print $2}') #Finding the PID of the loop process
echo $current_PID "Current PID" #Observing the PID of the loop process
previous_PID=$(tail -1 $PID_for_record) #Previous PID process
echo $previous_PID "Previous PID" #Observing the previous PID of the loop process

#We need to rewrite the PID in case our process was reloaded

if [[ "$current_PID" != "$previous_PID" ]]; then

	echo $current_PID $date_of_event "The process was reloaded">>$monitoring_file
	echo $current_PID>$PID_for_record

fi

#If we do not have the active process in place, we do not need to send request to URI

if [ "$current_PID" = "" ]; then
    echo "The Test process was not found"

#If the process is active, we need to send the curl request to URI

else reply_from_uri=$(curl -o /dev/null -s -w "%{http_code}\n" $uri) #We are recording the reply from URI

fi

#Depending on the reply from URI, we are making different notes in the log file.

#The monitoring Server is not available

	if [ "$reply_from_uri" = "000" ]; then
 	echo $reply_from_uri $date_of_event "The monitoring Server is not available">>$monitoring_file

#The server was unable to locate or access the page or website. This issue originates from the site's end

 	elif echo "$reply_from_uri" | grep -q "4[0-9][0-9]"; then
 	echo $reply_from_uri $date_of_event "The server was unable to locate or access the page or website. This issue originates from the site's end">>$monitoring_file

#The client submitted a valid request, but the server was unable to fullfill it

 	elif echo "$reply_from_uri" | grep -q "5[0-9][0-9]"; then
 	echo $reply_from_uri $date_of_event "The client submitted a valid request, but the server was unable to fullfill it">>$monitoring_file

fi

sleep 60

done

