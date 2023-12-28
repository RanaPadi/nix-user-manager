#!/bin/bash

#set -x

# Condition to check whether 'curl' is installed or not
if command -v curl &> /dev/null; then
  echo "------------------------------------------------------------------------------------------------------------"
  echo "curl is installed on your system."
else
  echo "------------------------------------------------------------------------------------------------------------"
  echo "Error: curl is not installed on your system. Please install curl and try again."
  exit 1  # Exit with failure status
fi

# Function to check and create a directory
check_and_create_directory() {
  local directory_path="$1"

  # Check if the directory exists
  if [ -d "$directory_path" ]; then
  echo "------------------------------------------------------------------------------------------------------------"
    echo "Directory '$directory_path' already exists."
  else
    # Create the directory
    mkdir -pm 755 "$directory_path"

    # Check if the directory creation was successful
    if [ $? -eq 0 ]; then
    echo "------------------------------------------------------------------------------------------------------------"
      echo "Directory '$directory_path' created successfully."
    else
      echo "------------------------------------------------------------------------------------------------------------"
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
    if [[ -n "grep -w 'extra-experimental-features' '$file_path'" && -n "grep -w 'flakes' '$file_path'" && -n "grep -w 'nix-command' '$file_path'" ]]; then
      echo "------------------------------------------------------------------------------------------------------------"
      echo "File '$file_path' already exists. And has extra-experimental-features like flakes and nix-command."
      echo "------------------------------------------------------------------------------------------------------------"
      echo "All the prerequistes to install and run Nix are already satisfied on your system."
      echo "------------------------------------------------------------------------------------------------------------"
      echo "Use the following command to install Nix on your system:"
      echo "------------------------------------------------------------------------------------------------------------"
      echo "sh <(curl -L https://nixos.org/nix/install) --daemon"
      echo "------------------------------------------------------------------------------------------------------------"
      echo "Caution: Before running the command make sure user has sudo privileges and give the password when prompted."
      echo "------------------------------------------------------------------------------------------------------------"
      exit 1  # Exit status to not overwrite the file
    fi
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
    echo "extra-experimental-features like flakes and nix-command were added to '$file_path'."
  else
    echo "Error: File '$file_path' does not exist."
    exit 1  # Exit with failure status
  fi
}
 
# Function to clean up old nix files
old_nix_files_cleanup() {

  # rm -rf ~/.nix-channels ~/.nix-defexpr ~/.nix-profile ~/.config/nix/
  # Ask for sudo permission
  echo "This script requires sudo permission for the next commands. Please enter your password."
  sudo -v
  if [ $? -ne 0 ]; then
    echo "Sorry, unable to get sudo permission. Exiting."
    exit 1
  fi

  # Cleaning up files using Sudo
  echo "Executing commands with sudo permission:"
  # Add your commands below this line
  # For example:
  sudo rm -f /etc/*.backup-before-nix /etc/*/*.backup-before-nix
  #sudo rm -rf /nix/ /etc/nix
  # End of commands

  echo "Script completed successfully."
}


# Calling the functions to check and create the directories
check_and_create_directory ~/.local/state/nix/profiles
check_and_create_directory ~/.config/nix

# Calling the functions to check and create the file
check_and_create_file ~/.config/nix/nix.conf && add_lines_to_file ~/.config/nix/nix.conf

#set +x
