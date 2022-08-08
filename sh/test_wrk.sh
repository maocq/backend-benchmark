#!/bin/bash
set -e
source ./functions.sh

case=$1


user=$(jq -r ".user" "config.json")
key=$(jq -r ".key" "config.json")
key_name=$(jq -r ".key_name" "config.json")
instance_type=$(jq -r ".instance_type" "config.json")
security_group=$(jq -r ".security_group" "config.json")
image_id=$(jq -r ".image_id" "config.json")


ip=$(jq -r ".ip" ".tmp/ip/$case.json")

if [ ! -f ".tmp/ip/$case-tests.json" ]; then
	tests_ip=$(start_simple_instance "$case-tests" "$image_id" "$instance_type" "$user" "$key" "$key_name" "$security_group")
else
	tests_ip=$(jq -r ".ip" ".tmp/ip/$case-tests.json")	
fi

_out=$(execute_remote_command "sudo apt-get -y install wrk" "$tests_ip" "$user" "$key")



host="http://$ip:8080/api/"

scenarios=(
	#"hello"
	"case-one?latency=50"
	#"case-one?latency=200"
	#"case-one?latency=500"
	#"case-two?latency=50"
	#"case-two?latency=200"
	#"case-two?latency=500"
	#"case-three"
	#"get-hello?latency=50"
	#"get-hello?latency=100"
	#"get-hello?latency=200"
	#"get-hello?latency=500"
	#"primes"
)

for scenario in "${scenarios[@]}"; do
    command="docker restart \$(docker ps -a -q)"
    execute_remote_command "$command" "$ip" "$user" "$key" > /dev/tty

    url="$host$scenario"
    wait_http "$url"

	rm -f ".tmp/results/wrk-$scenario-$case.txt"
	execute_remote_command "wrk -t4 -c200 -d300s $url" "$tests_ip" "$user" "$key" | tee ".tmp/results/wrk-$scenario-$case.txt" > /dev/tty
done

echo "#################"
echo "$case"
echo "#################"