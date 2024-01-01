#!/bin/bash

# Get the current username
current_username=$(whoami)

# Get the current path of this script
current_path=$(dirname "$(readlink -f "$0")")

# Create a file and write the username within double quotes
echo "\"$current_username\"" > "$current_path"/username.nix

# Display a message
echo "Username '$current_username' has been written to '$current_path'/username.nix"

# Get the current user's home directory
current_userdir=$(eval echo "~$current_username")

# Create a file and write the user's home directory within double quotes
echo "\"$current_userdir\"" > "$current_path"/userdir.nix

# Display a message
echo "User directory '$current_userdir' has been written to '$current_path'/userdir.nix"