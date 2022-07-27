#!/bin/bash
project=$1
docker stop "$(docker ps -q)"
cd backend-benchmark/$project
docker build -t "$project" .
docker rm -f "$project"

touch /tmp/env.list
docker run --env-file /tmp/env.list --name "$project" -d -p 8080:8080 -p 5432:5432 "$project"
