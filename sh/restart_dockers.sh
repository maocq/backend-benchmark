#!/bin/bash
set -e
source ./functions.sh

user=$(jq -r ".user" "config.json")
key=$(jq -r ".key" "config.json")


case=$1




echo "Restarting dockers ..."

instances=$(aws ec2 describe-instances --filters Name=tag:Name,Values="benchmark-$case*" Name=instance-state-name,Values=running --query Reservations[].Instances[].InstanceId --output text)

array=($instances)
for id in "${array[@]}"; do
	name=$(jq -r ".name" ".tmp/instances/$id.json")
	ip=$(jq -r ".ip" ".tmp/ip/$name.json")
	command="docker restart \$(docker ps -a -q)"
	_out=$(execute_remote_command "$command" "$ip" "$user" "$key")
done
