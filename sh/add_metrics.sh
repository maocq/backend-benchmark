#!/bin/bash
set -e
source ./functions.sh

case=$1

url_reposity=$(jq -r ".url_reposity" "config.json")
user=$(jq -r ".user" "config.json")
key=$(jq -r ".key" "config.json")
key_name=$(jq -r ".key_name" "config.json")
instance_type=$(jq -r ".instance_type" "config.json")
security_group=$(jq -r ".security_group" "config.json")
image_id=$(jq -r ".image_id" "config.json")


ip=$(jq -r ".ip" ".tmp/ip/$case.json")
instance_id=$(jq -r ".instanceId" ".tmp/ip/$case.json")


repository=$(basename "$url_reposity")
directory=${repository%.*}

aws ec2 associate-iam-instance-profile --iam-instance-profile Name=ec2-full-access-cloudwatch --instance-id "$instance_id" > /dev/tty
execute_remote_command "bash $directory/metrics/metrics.sh" "$ip" "$user" "$key" > /dev/tty

