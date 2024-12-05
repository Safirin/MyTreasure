#!/bin/bash

#список серверов с которых снимается backup и информация
filename1=/home/rinat/snap/GitHubSafirin/File1-VMaddress.txt
#список файлов куда делается backup
filename2=/home/rinat/snap/GitHubSafirin/File2-FilestocopytoHost.txt

declare -a myArray1
declare -a myArray2

myArray1=(`cat "$filename1"`)
myArray2=(`cat "$filename2"`)


for (( i = 0 ; i < ${#myArray1[@]} ; i++))
do
  
  ssh -tt ${myArray1[i]} 'echo "Hello Rinat" > TestBash && \
  whoami >> TestBash && \
  date >> TestBash && \
  nproc >> TestBash && \
  df -h >> TestBash && \
  cat /proc/loadavg >> TestBash && \
  cat /proc/uptime >> TestBash && \
  cat /proc/net/dev >> TestBash && \
  ss -tulpn >> TestBash && \
  who >> TestBash && \
  w >> TestBash && \
  getent group sudo | awk -F: "{print \$4}" >> TestBash && \
  touch ~/"$(date -I)" && \
  cat ~/TestBash>> ~/"$(date -I)"'

  
done

for (( i = 0 ; i < ${#myArray2[@]} ; i++))
do

scp ${myArray1[i]}:~/"$(date -I)" ${myArray2[i]}


done
