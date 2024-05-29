#!/bin/bash

# Check if KEY_PATH environmentariable is set
if [ -z "$KEY_PATH" ]; then
    echo "KEY_PATH env var is expected"
    exit 5
fi

# Check the number of arguments passed
if [ $# -lt 1 ]; then
    echo "Please provide bastion IP address"
    exit 5
fi



# If only one argument is  provided,connect to the public instance
if [ $# -eq 1 ]; then
    echo " i am in the one arguments case"
    ssh -i "$KEY_PATH" ubuntu@"$1"
    exit $?
fi

# If two arguments are provided, connect to the stanc through the public instance hello llllll
if [ $# -eq 2 ]; then

    ssh -i "$KEY_PATH" ubuntu@"$1" "ssh -i key.pem ubuntu@$2"
    exit $?
fi

KNOWN_HOSTS_FILE=$(mktemp)




# If three arguments are provided, connect to the private instance throughthe public instance and execute the command
if [ $# -eq 3 ]; then
  ssh -i "$KEY_PATH" ubuntu@"$1" "ssh -i key.pem ubuntu@$2 '$3'"
  exit $?
fi




# If none exit with code 5
exit 5