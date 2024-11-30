#!/bin/bash

echo "Dear fello coworker. Please select the following options:

1 - User
2 - Host
3 - Help"

read class

case $class in

1)  
    type="Host"
    cores=$(nproc)
    #Amount of RAM in the system
    memtotal=$(free -h | awk ' /'Mem'/ {print $1, $2}')
    total=$(free -h | awk ' /total/ {print $1}' )
    #Amount of RAM used
    memused=$(free -h | awk ' /'Mem'/ {print $1, $3}')
    used=$(free -h | awk ' /total/ {print $2}' )
    #disk usage
    diskusage=$(df -h)
    #load average
    loadverage=$(cat /proc/loadavg)
    #system update
    systemupdate=$(cat /proc/uptime)
    #time in the system
    date=$(date)
    #uptime
    uptime=$(cat /proc/uptime)
    #network interfaces
    networkinterfaces=$(ifconfig)
    #netstat
    netstat=$(cat /proc/net/dev)
    #ports
    ports=$(ss -tulpn)
  
echo "
    
You chosen the User option 
     
- Number of Cores = $cores
- RAM:
  RAM total = ${memtotal} ${total}
  RAM used = ${memused} ${used}
- Disk usage:

$diskusage
- Load average = $loadverage
- System update time = $systemupdate
- System time = $date
- Uptime = $uptime
- Network Interfaces:

$networkinterfaces

- Ports = $ports

"
;;

2)  type="User"
    usersinthesystem=$(who)
    rootusers=$(getent group sudo | awk -F: '{print $4}')
    loggedinusers=$(w)

echo "

You chosen the Host option

- Users in the system:

$usersinthesystem

- Lists of thr root-users in the system = $rootusers
- Logged in Users:

$loggedinusers

"

;;

3)  type="Help"

echo "

You chosen the Help option

Please find the following list of parameters that this script supports:

type="User" provides information on the User side 
type="Host" provides information on the Host side 
type="Help" provides information on the Help side 

User Parameters:
cores=(nproc) shows the number of CPU cores;
memtotal=(free -h | awk ' /'Mem'/ {print $ 1, $ 2}') - The amount of RAM in the system
diskusage=(df -h) - The disk usage
loadverage=(cat /proc/loadavg) - Average load
systemupdate=(cat /proc/uptime) - System update
date=(date) - Time in the system
uptime=(cat /proc/uptime) - System Uptime
networkinterfaces=(ifconfig) - Network Interfaces
cports=(ss -tulpn) - Ports

Host Parameters:
usersinthesystem=(who) - List of users in the system
rootusers=(getent group sudo | awk -F: '{print $ 4}') - List of root userscle
loggedinusers - Logged in users in the system

"
    
;;

esac