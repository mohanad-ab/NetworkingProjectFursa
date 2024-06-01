#!/bin/bash

if [ -z "$1" ]; then
echo "Please provide the private instance IP address"
exit 1
fi

PRIVATE_INSTANCE_IP=$1
KEY_PATH=${KEY_PATH:-~/key.pem}
NEW_KEY=~/new_key
NEW_KEY_PUB=~/new_key.pub

ssh-keygen -t rsa -b 2048 -f $NEW_KEY -q -N ""

EXTRACTED_PUB=$(cat $NEW_KEY_PUB)

ssh -i "$KEY_PATH" ubuntu@"$PRIVATE_INSTANCE_IP" "echo '$EXTRACTED_PUB' > ~/.ssh/authorized_keys"

mv $NEW_KEY $KEY_PATH
rm $NEW_KEY_PUB