#!/bin/bash

# Get the current username
current_username=$(whoami)

# Create a file and write the username within double quotes
echo "\"$current_username\"" > ./username.nix

# Display a message
echo "Username '$current_username' has been written to ./username.nix"

# Get the current user's home directory
current_userdir=$(eval echo "~$current_username")

# Create a file and write the user's home directory within double quotes
echo "\"$current_userdir\"" > ./userdir.nix

# Display a message
echo "User directory '$current_userdir' has been written to ./userdir.nix"