#!/bin/bash

# Created by Tanner Cude
# This script allows you to easily invoke a command on a Minecraft instance running within docker using rcon-cli
# Here is the Docker image I am using: https://github.com/itzg/docker-minecraft-server

echo "###################################"
echo "MINECRAFT DOCKER COMMAND SCRIPT"
echo -e "################################### \n"

# Get the container ID of the Minecraft server container
container_id=$(docker ps --format '{{.ID}}' --filter 'ancestor=itzg/minecraft-server' --quiet)

if [ -z "$container_id" ]; then
    echo "No Minecraft server container found. Make sure it is running."
    exit 1
fi

echo "Container ID for the Minecraft server: $container_id"

# Check if a command was provided as an argument
if [ $# -eq 0 ]; then
    echo "Please provide a command as an argument."
    exit 1
fi

server_command="$1"

echo "Command to be issued: $server_command"
echo -e "       \n"
docker exec -i $container_id rcon-cli $server_command
exit 0
