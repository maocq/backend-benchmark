#!/bin/bash
set -e
source ./functions.sh


user=$(jq -r ".user" "config.json")
key=$(jq -r ".key" "config.json")


echo "Instances running ..."

instances=$(aws ec2 describe-instances --filters Name=tag:Name,Values="benchmark*" Name=instance-state-name,Values=running --query Reservations[].Instances[].InstanceId --output text)

array=($instances)
for id in "${array[@]}"; do  	
	name=$(jq -r ".name" ".tmp/instances/$id.json")
	ip=$(jq -r ".ip" ".tmp/ip/$name.json")

	echo $name > /dev/tty
	echo "ssh -i "$key" $user@$ip" > /dev/tty
	echo "http://$ip:8080/api/hello" > /dev/tty
done

