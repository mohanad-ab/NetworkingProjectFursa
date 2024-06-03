#!/bin/bash

if [ -z "$1" ]; then
  echo "Please provide the private instance IP address"
  exit 1
fi

PRIVATE_INSTANCE_IP=$1
KEY_PATH=${KEY_PATH:-~/key.pem}
NEW_KEY=~/new_key
NEW_KEY_PUB=~/new_key.pub

# Generate new SSH key pair
ssh-keygen -t rsa -b 2048 -f "$NEW_KEY" -q -N ""

# Extract public key
EXTRACTED_PUB=$(cat "$NEW_KEY_PUB")

# Verify SSH connection to the private instance
echo "Verifying SSH connection to the private instance..."
if ! ssh -i "$KEY_PATH" ubuntu@"$PRIVATE_INSTANCE_IP" "echo SSH connection successful"; then
  echo "Failed to connect to the private instance"
  exit 1
fi

# Upload new public key to the private instance, ensuring to overwrite the existing authorized_keys file
echo "Uploading new public key to the private instance..."
if ! ssh -i "$KEY_PATH" ubuntu@"$PRIVATE_INSTANCE_IP" "echo $EXTRACTED_PUB > ~/.ssh/authorized_keys"; then
  echo "Failed to upload the new public key to the private instance"
  exit 1
fi

# Verify the new public key is in place
echo "Verifying the new public key on the private instance..."
if ! ssh -i "$KEY_PATH" ubuntu@"$PRIVATE_INSTANCE_IP" "grep $EXTRACTED_PUB ~/.ssh/authorized_keys"; then
  echo "Failed to verify the new public key on the private instance"
  exit 1
fi

# Backup old key
BACKUP_KEY_PATH="${KEY_PATH}.backup"
mv "$KEY_PATH" "$BACKUP_KEY_PATH"

# Move new private key to the key path and set permissions
mv "$NEW_KEY" "$KEY_PATH"
chmod 600 "$KEY_PATH"

# Clean up
rm "$NEW_KEY_PUB"

mv "$NEW_KEY" key.pem
rm "$NEW_KEY"

echo "New SSH key has been generated and deployed. Old key backed up to $BACKUP_KEY_PATH."

