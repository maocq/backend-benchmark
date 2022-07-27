#!/bin/bash
set -e

echo "Clean instances ..."
aws ec2 terminate-instances --instance-ids `aws ec2 describe-instances --filters Name=tag:Name,Values="benchmark*" --query Reservations[].Instances[].InstanceId --output text`

rm -rf .tmp
