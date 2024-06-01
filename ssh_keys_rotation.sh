#!/bin/bash

# Check if a private instance IP address is provided as an argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <private-instance-ip>"
    exit 1
fi

PRIVATE_INSTANCE_IP=$1

# Generate a new SSH key pair
ssh-keygen -t rsa -b 2048 -f ~/new_key -q -N ""



# Override the new public key to the authozed_keys file on the private instance
ssh -i ~/key.pem ubuntu@$PRIVATE_INSTANCE_IP "cat ~/new_key.pub > ~/.ssh/authorized_keys"

cat ~/new_key > ~/key.pem



rm ~/new_key

rm ~/new_key.pub

# Remove the new public key file from the public instance

