#!/bin/bash

# Get the current username
current_username=$(whoami)

# Create a file and write the username within double quotes
echo "\"$current_username\"" > ./username.nix

# Display a message
echo "Username '$current_username' has been written to ./username.nix"