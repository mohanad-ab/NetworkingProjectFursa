#!/bin/bash
SECOND_KEY="/home/ubuntu/key.pem"

# Check if KEY_PATH environment variable is set
if [ -z "$KEY_PATH" ]; then
    echo "KEY_PATH environment variable is expected"
    exit 5
fi

# Ensure the private key has the correct permissions
chmod 600 "$KEY_PATH"

# Check the number of arguments passed
if [ $# -lt 1 ]; then
    echo "Please provide bastion IP address"
    exit 5
fi

# Handle one argument (connect to the public instance)
if [ $# -eq 1 ]; then
    echo "Connecting directly to the public instance..."
    ssh -i "$KEY_PATH" ubuntu@"$1"
    exit $?
fi

if ! ssh -i "$KEY_PATH" ubuntu@"$1" "test -f $SECOND_KEY"; then
    echo "No key in public instance"
    exit 1
fi

# Handle two arguments (connect to the private instance through the public instance)
if [ $# -eq 2 ]; then


    echo "Connecting to the private instance through the public instance..."
    ssh -i "$KEY_PATH" ubuntu@"$1" "ssh -i $SECOND_KEY ubuntu@$2"
    exit $?
fi

# Handle three arguments (connect to the private instance through the public instance and execute a command)
if [ $# -eq 3 ]; then
    echo "Connecting to the private instance through the public instance and executing a command..."
    ssh -i "$KEY_PATH" ubuntu@"$1" "ssh -i $SECOND_KEY ubuntu@$2 $3"
    exit $?
fi

# If none of the conditions are met, exit with code 5
echo "Invalid number of arguments provided"
exit 5
