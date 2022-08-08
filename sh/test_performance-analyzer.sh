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


scenarios=(
    #"hello"
    #"case-one?latency=50"
    #"case-one?latency=200"
    #"case-one?latency=500"
    #"case-two?latency=50"
    #"case-two?latency=200"
    #"case-two?latency=500"
    #"case-three"
    "get-hello?latency=80"
    #"get-hello?latency=100"
    #"get-hello?latency=200"
    #"get-hello?latency=500"
    #"primes"
)


for scenario in "${scenarios[@]}"; do
    command="docker restart \$(docker ps -a -q)"
    execute_remote_command "$command" "$ip" "$user" "$key" > /dev/tty

    wait_http "http://$ip:8080/api/$scenario"

    cp "../performance-analyzer/performance.exs" ".tmp/work/performance-$case.exs"
    sed -i -e "s/_IP_/$ip/g" -e "s/_SCENARIO_/$scenario/g" ".tmp/work/performance-$case.exs"
    upload_file $tests_ip ".tmp/work/performance-$case.exs" "performance.exs" $user $key

    rm -f ".tmp/results/$scenario,$case.csv"
    out=$(execute_remote_command "rm -f result.csv" "$tests_ip" "$user" "$key")


    execute_remote_command "docker run --rm -v \$(pwd):/app/config bancolombia/distributed-performance-analyzer:0.3.0" "$tests_ip" "$user" "$key" > /dev/tty

    download_file $tests_ip "result.csv" ".tmp/results/$scenario,$case.csv" $user $key
    echo "$case $scenario" > /dev/tty
    echo "http://$ip:8080/api/$scenario" > /dev/tty
    cat ".tmp/results/$scenario,$case.csv" > /dev/tty
done

echo "#################"
echo "$case"
echo "#################"

