#!/bin/bash

#set -x

# Condition to check whether 'curl' is installed or not
if command -v curl &> /dev/null; then
  echo "----------------------------------------------------------------------------------------------------"
  echo "curl is installed on your system."
else
  echo "----------------------------------------------------------------------------------------------------"
  echo "Error: curl is not installed on your system. Please install curl and try again."
  exit 1  # Exit with failure status
fi

# Function to check and create a directory
check_and_create_directory() {
  local directory_path="$1"

  # Check if the directory exists
  if [ -d "$directory_path" ]; then
  echo "----------------------------------------------------------------------------------------------------"
    echo "Directory '$directory_path' already exists."
  else
    # Create the directory
    mkdir -pm 755 "$directory_path"

    # Check if the directory creation was successful
    if [ $? -eq 0 ]; then
    echo "----------------------------------------------------------------------------------------------------"
      echo "Directory '$directory_path' created successfully."
    else
      echo "----------------------------------------------------------------------------------------------------"
      echo "Error: Failed to create directory '$directory_path'. Creating the directory manually and try again."
      exit 1  # Exit with failure status
    fi
  fi
}

# Function to check and create a file
check_and_create_file() {
  local file_path="$1"

  # Check if the file exists
  if [ -e "$file_path" ]; then
    echo "----------------------------------------------------------------------------------------------------"
    echo "File '$file_path' already exists."
    echo "----------------------------------------------------------------------------------------------------"
    echo "All the prerequistes to install and run Nix are already installed on your system."
    echo "----------------------------------------------------------------------------------------------------"
    echo "Use the following command to install Nix on your system:"
    echo "----------------------------------------------------------------------------------------------------"
    echo "sh <(curl -L https://nixos.org/nix/install) --daemon"
    echo "----------------------------------------------------------------------------------------------------"
    echo "Caution: Before running the command make sure user has sudo privileges."
    echo "----------------------------------------------------------------------------------------------------"
    exit 1  # Exit status to not overwrite the file
  else
    # Create the file with 755 permissions
    touch "$file_path" && chmod 755 "$file_path"

    # Check if the file creation was successful
    if [ $? -eq 0 ]; then
      echo "File '$file_path' created successfully with 755 permissions."
    else
      echo "Error: Failed to create file '$file_path'."
      exit 1  # Exit with failure status
    fi
  fi
}

# Function to add lines to a file
add_lines_to_file() {
  local file_path="$1"

  # Check if the file exists
  if [ -e "$file_path" ]; then
    # Add lines to the file using cat << EOF
    cat << EOF > "$file_path"
extra-experimental-features = flakes nix-command
build-users-group = nixbld
EOF
    echo "Lines added to file '$file_path'."
  else
    echo "Error: File '$file_path' does not exist."
    exit 1  # Exit with failure status
  fi
}


# Calling the functions to check and create the directories
check_and_create_directory ~/.local/state/nix/profiles
check_and_create_directory ~/.config/nix

# Calling the functions to check and create the file
check_and_create_file ~/.config/nix/nix.conf && add_lines_to_file ~/.config/nix/nix.conf

#set +x
