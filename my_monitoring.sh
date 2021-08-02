#!/bin/bash

arch=$(uname -a)
p_cpu=$(cat /proc/cpuinfo | grep 'cpu cores'| tr -d 'cpu cores: \t')
v_cpu=$(grep "^processor" /proc/cpuinfo | wc -l)
t_mem=$(free -m | grep Mem | awk '{print $2}')
used_mem=$(free -m | grep Mem | awk '{print $3}')
p_mem=$(awk "BEGIN {print ($used_mem/$t_mem)*100}")
t_space=$(df -h --total | grep total | awk '{print $2}')
u_space=$(df -h --total | grep total | awk '{print $3}')
p_space=$(df -h --total | grep total | awk '{print $5}')
u_cpu=$(top -bn1 | grep Cpu | awk '{print $2}')
l_b_date=$(who -b | awk '{print $3}')
l_b_time=$(who -b | awk '{print $4}')

nbr_lvm=$(cat /etc/fstab | grep /dev/mapper | wc -l)
# LVM starts with /dev/mapper
# if we have those meaning we are using LVM so it's active
if [[ $nbr_lvm -eq 0 ]]
then
	lvm='no'
else
	lvm='yes'
fi

nbr_tcp_co=$(w| grep " pts/" | awk '{print $3}' | wc -l) # check if this is correct
nbr_usr_co=$(w | head -n 1 |awk '{print $5}')
ip=$(ip addr | grep 'inet ' | tr -t / ' ' | awk '{print $2}' | grep -v 127 | head -n 1)
mac=$(ip addr | grep link/ether | awk '{print $2}' | head -n 1)
sudo_com=$(cat /var/log/sudo/sudo_logs | grep -i "command=" | wc -l)

wall << .
	#Architecture: $arch
	#CPU physical : $p_cpu
	#vCPU : $v_cpu
	#Memory Usage : $used_mem/$t_mem MB (${p_mem::4}%)
	#Disk Usage : $u_space/$t_space ($p_space)
	#CPU load : $u_cpu%
	#Last boot : $l_b_date $l_b_time
	#LVM use : $lvm
	#Connections TCP : $nbr_tcp_co ESTABLISHED
	#User log: $nbr_usr_co
	#Network : IP $ip ($mac)
	#Sudo :  $sudo_com cmd
.
