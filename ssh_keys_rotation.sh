#!/bin/bash

# Check if a private instance IP address is provided as an argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <private-instance-ip>"
    exit 1
fi

PRIVATE_INSTANCE_IP=$1

# Generate a new SSH key pair
ssh-keygen -t rsa -b 2048 -f ~/new_key -q -N ""

# Copy the public key to the private instance
scp -i ~/key.pem ~/new_key.pub ubuntu@$PRIVATE_INSTANCE_IP:~/

# Override the new public key to the authorized_keys file on the private instance
ssh -i ~/key.pem ubuntu@$PRIVATE_INSTANCE_IP "cat ~/new_key.pub > ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"

# Update the private key file on the local machine
cat ~/new_key > ~/key.pem

# Remove the temporary files
rm -f ~/new_key ~/new_key.pub

# Remove the new public key file from the public instance
ssh -i ~/key.pem ubuntu@$PRIVATE_INSTANCE_IP "rm -f ~/new_key.pub"

echo "SSH keys have been rotated successfully."
