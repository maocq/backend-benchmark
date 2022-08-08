#######################################
# ARGUMENTS: (name, image_id, instance_type, key_name)
# OUTPUTS: instance_id
# RETURN: 0, Non-zero on error.
#######################################
start_instance() {
	local name=$1
	local image_id=$2
	local instance_type=$3
	local key_name=$4
	local security_group=$5


	if [ ! -f ".tmp/$name.json" ]; then
		local out=$(create_instace $name $image_id $instance_type $key_name $security_group)
		echo $out;
		return 0;
	fi

  local instance_id=$(jq -r '.Instances[].InstanceId' ".tmp/$name.json")
	local instance_state=$(aws ec2 describe-instances --instance-ids "$instance_id" | jq -r '.Reservations[].Instances[].State.Name')

	if [ "$instance_state" != "running" ]; then
		local out=$(create_instace $name $image_id $instance_type $key_name $security_group)
		echo $out;
		return 0;
	fi

	echo $instance_id;
	return 0;
}

#######################################
# ARGUMENTS: (name, image_id, instance_type, key_name)
# OUTPUTS: instance_id
# RETURN: 0, Non-zero on error.
#######################################
create_instace() {
	local name=$1
	local image_id=$2
	local instance_type=$3
	local key_name=$4
	local security_group=$5


	echo "Creating a new instance $name" > /dev/tty
	aws ec2 run-instances \
 	--tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=benchmark-$name}]" \
    --image-id "$image_id" \
    --instance-type "$instance_type" \
    --key-name "$key_name" \
    --security-group-ids "$security_group" \
    --user-data file://install_docker.sh \
    > ".tmp/$name.json"

	local instance_id=$(jq -r '.Instances[].InstanceId' ".tmp/$name.json")
	jq --null-input --arg name "$name" '{"name": $name}' > ".tmp/instances/$instance_id.json"

	wait_instance_running $instance_id

	echo $instance_id;
	return 0;
}

#######################################
# ARGUMENTS: (instance_id)
# OUTPUTS:
# RETURN: 0, Non-zero on error.
#######################################
wait_instance_running() {
	local instance_id=$1

	echo "Waiting instance $instance_id ..." > /dev/tty
	aws ec2 wait instance-running --instance-ids $instance_id
	sleep 5
	return 0;
}

#######################################
# ARGUMENTS: (instance_ip, user, key)
# OUTPUTS:
# RETURN: 0, Non-zero on error.
#######################################
wait_initialized() {
  local instance_ip=$1
  local user=$2
  local key=$3

  while [[ $(execute_remote_command "echo 'OK'" "$instance_ip" "$user" "$key") != *"OK"* ]]; do
	  echo "... Waiting ssh $instance_ip" > /dev/tty
	done

  echo "Waiting for initialization $instance_id ..." > /dev/tty
  local cmd="until [ -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting...'; sleep 2; done"

  execute_remote_command "$cmd" "$instance_ip" "$user" "$key" > /dev/tty

  echo "Instance $instance_ip OK!" > /dev/tty
  return 0;
}

#######################################
# ARGUMENTS: (url)
# OUTPUTS:
# RETURN: 0, Non-zero on error.
#######################################
wait_http() {
  local url=$1

  echo "Waiting for http $url ..." > /dev/tty

	while [[ $(curl -is $url | head -n 1) != *"200"* ]]; do
	  echo "Waiting for $url, state: $(curl -is $url | head -n 1)" > /dev/tty
	done
	sleep 3

  echo "OK! $url" > /dev/tty
  return 0;
}

#######################################
# ARGUMENTS: (instance_id, name)
# OUTPUTS: instance_ip
# RETURN: 0, Non-zero on error.
#######################################
get_and_save_instance_ip() {
	local instance_id=$1
	local name=$2

	instance_ip=$(aws ec2 describe-instances --instance-ids "$instance_id" | jq -r '.Reservations[].Instances[].PublicIpAddress')
	jq --null-input --arg ip "$instance_ip" --arg id "$instance_id" '{"ip": $ip, "instanceId": $id}' > ".tmp/ip/$name.json"

	echo $instance_ip;
	return 0;
}

#######################################
# ARGUMENTS: (command, instance_ip, user, key)
# OUTPUTS: command output
# RETURN: 0, Non-zero on error.
#######################################
execute_remote_command() {
  local command=$1
  local ip=$2
  local user=$3
  local key=$4

  echo "Executing command $command on $ip" > /dev/tty
  ssh -o "StrictHostKeyChecking no" -i "$key" "$user@$ip" "$command"

  return 0
}

#######################################
# ARGUMENTS: (instance_ip, url_reposity, user, key)
# OUTPUTS:
# RETURN: 0, Non-zero on error.
#######################################
clone_repository() {
  local instance_ip=$1
  local url_reposity=$2
  local user=$3
  local key=$4

  local repository=$(basename "$url_reposity")
  local directory=${repository%.*}
  local cmd="if [ ! -d $directory ]; then git clone $url_reposity; else cd $directory; git checkout . && git pull; fi"

  local out=$(execute_remote_command "$cmd" "$instance_ip" $user $key)
  return 0;
}

#######################################
# ARGUMENTS: (folder, url_reposity, instance_ip, user, key)
# OUTPUTS:
# RETURN: 0, Non-zero on error.
#######################################
start_docker_image() {
	local folder=$1
	local url_reposity=$2
	local instance_ip=$3
	local user=$4
	local key=$5

	local repository=$(basename "$url_reposity")
  local directory=${repository%.*}

	echo "Starting docker $name on $instance_ip" > /dev/tty

	while [[ $(execute_remote_command "docker --version" "$instance_ip" "$user" "$key") != *"Docker version"* ]]; do
	  echo "... Waiting docker $instance_ip" > /dev/tty
	done

	execute_remote_command "bash $directory/start_docker_image.sh $folder" "$instance_ip" "$user" "$key" > /dev/tty
	return 0;
}

#######################################
# ARGUMENTS: (instance_ip, origin, destination, user, key)
# OUTPUTS:
# RETURN: 0, Non-zero on error.
#######################################
download_file() {
  local intance_ip=$1
  local origin=$2
  local destination=$3
  local user=$4
  local key=$5

  echo "Downloading $origin to $destination on $intance_ip" > /dev/tty;
  local out=$(scp -o "StrictHostKeyChecking no" -i "$key" "$user@$intance_ip:$origin" "$destination")
  echo "$out" > /dev/tty
  return 0
}

#######################################
# ARGUMENTS: (instance_ip, origin, destination, user, key)
# OUTPUTS:
# RETURN: 0, Non-zero on error.
#######################################
upload_file() {
  local intance_ip=$1
  local origin=$2
  local destination=$3
  local user=$4
  local key=$5

  echo "Uploading $destination from $origin on $intance_ip" > /dev/tty;
  local out=$(scp -o "StrictHostKeyChecking no" -i "$key" "$origin" "$user@$intance_ip:$destination")
  echo "$out" > /dev/tty
  return 0
}

#######################################
# ARGUMENTS: (name, folder, image_id, instance_type, user, key, key_name, configuration (optional))
# OUTPUTS: instance_ip
# RETURN: 0, Non-zero on error.
#######################################
start() {
	local name=$1
	local folder=$2
	local image_id=$3
	local instance_type=$4
	local user=$5
	local key=$6
	local key_name=$7
	local security_group=$8
	local configuration=$9

	instance_id=$(start_instance $name $image_id $instance_type $key_name $security_group)
	instance_ip=$(get_and_save_instance_ip $instance_id $name)
	wait_initialized $instance_ip $user $key
	clone_repository $instance_ip $url_reposity $user $key

	if [ ! -z "$configuration" ]; then _out=$(execute_remote_command "$configuration" "$instance_ip" "$user" "$key"); fi
	start_docker_image $folder $url_reposity $instance_ip $user $key

	printf "\n START: $name \n" > /dev/tty
	echo $instance_ip

	return 0;
}

#######################################
# ARGUMENTS: (name, image_id, instance_type, user, key, key_name)
# OUTPUTS: instance_ip
# RETURN: 0, Non-zero on error.
#######################################
start_simple_instance() {
	local name=$1
	local image_id=$2
	local instance_type=$3
	local user=$4
	local key=$5
	local key_name=$6
	local security_group=$7

	instance_id=$(start_instance $name $image_id $instance_type $key_name $security_group)
	instance_ip=$(get_and_save_instance_ip $instance_id $name)
	wait_initialized $instance_ip $user $key

	printf "\n START (simple instance): $name \n" > /dev/tty
	echo $instance_ip

	return 0;
}
