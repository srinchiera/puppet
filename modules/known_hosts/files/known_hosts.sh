#!/bin/bash
array=( 'github.com' )
for h in "${array[@]}"
do
    #echo $h
    ip=$(dig +short $h)
    ssh-keygen -R $h
    ssh-keygen -R $ip
    ssh-keyscan -H $ip >> /home/ubuntu/.ssh/known_hosts
    ssh-keyscan -H $h >> /home/ubuntu/.ssh/known_hosts
 done
