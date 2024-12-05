#!/bin/bash


filename1=/home/rinat/snap/GitHubSafirin/File1-VMaddress.txt
filename2=/home/rinat/snap/GitHubSafirin/File2-FilestocopytoHost.txt

declare -a myArray1
declare -a myArray2

myArray1=(`cat "$filename1"`)
myArray2=(`cat "$filename2"`)


for (( i = 0 ; i < ${#myArray1[@]} ; i++))
do
  
  ssh -tt ${myArray1[i]} 'echo "Hello Rinat" > Test2 && \
  whoami >> Test2 && \
  date >> Test2 && nproc >> Test2 && \
  df -h >> Test2 && \
  cat /proc/loadavg >> Test2 & cat /proc/uptime >> Test2 && \
  cat /proc/net/dev >> Test2 && \
  ss -tulpn >> Test2 && \
  who >> Test2 && w >> Test2 && \
  getent group sudo | awk -F: "{print \$4}" >> Test2 && \
  touch ~/"$(date -I)" && \
  cat ~/Test2 >> ~/"$(date -I)"'

  
done

for (( i = 0 ; i < ${#myArray2[@]} ; i++))
do

scp ${myArray1[i]}:~/"$(date -I)" ${myArray2[i]}


done

#touch /home/rinat/Test/"$(date) $(whoami)"