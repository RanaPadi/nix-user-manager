#!/bin/bash
#set -x # Enable debugging

# Function to clean up old NIX folders/files
cleanup_old_nix_files() {
  # Array of folders/files to remove
  local items_to_remove=("$@")

  # Ask for sudo permission
  echo "This script requires sudo permission for the next commands. Please enter your password."
  sudo -v
  if [ $? -ne 0 ]; then
    echo "Sorry, unable to get sudo permission. Exiting."
    exit 1
  fi

  # Find folders/files matching the pattern
  local items=$(sudo find /etc -name "*.backup-before-nix")
  # Iterate over the items
  for item in $items; do
    # Delete the item
    sudo rm -rf "$item"
    echo "Deleted folder/file: $item"
  done

  # Iterate over the normal array
  for item in "${items_to_remove[@]}"; do
    # Expand the tilde to home directory
    item=$(eval echo "$item")
    # Check if the folder/file exists
    if [ -e "$item" ]; then
      echo "Removing folder/file: $item"
      # Remove the folder/file and its contents
      sudo rm -rf "$item"
      if [ $? -eq 0 ]; then
        echo "Successfully removed $item"
      else
        rm -rf "$item"
        if [ $? -eq 0 ]; then
          echo "Successfully removed $item"
        else
          echo "Failed to remove $item"
        fi
      fi
    else
      echo "Folder/file does not exist: $item"
    fi
  done
}

# Function to check and create NIX directories
check_and_create_nix_directories() {
  local directories_to_create=("$@")

  # Iterate over the array
  for directory_path in "${directories_to_create[@]}"; do
    # Check if the directory exists
    if [ -e "$directory_path" ]; then
      echo "Directory '$directory_path' already exists."
    else
      # Create the directory
      mkdir -p "$directory_path" && chmod 755 "$directory_path"
      # Check if the directory creation was successful
      if [ $? -eq 0 ]; then
        echo "Directory '$directory_path' created successfully."
      else 
        echo "Error: Failed to create directory '$directory_path'. Creating the directory manually and try again."
        exit 1  # Exit with failure status
      fi
    fi
  done
}


# Function to check and create NIX config file
check_and_create_nix_config_file() {
  local file_path="$1"

  # Check if the file exists
  if [ -e "$file_path" ]; then
    if [[ -n "$(grep -w 'extra-experimental-features' "$file_path")" && -n "$(grep -w 'flakes' "$file_path")" && -n "$(grep -w 'nix-command' "$file_path")" ]]; then      
      echo "File '$file_path' already exists. And has extra-experimental-features like flakes and nix-command."     
      echo "All the prerequistes to install and run Nix are already satisfied on your system."      
      echo "Using the following command to install Nix on your system:"      
      echo "sh <(curl -L https://nixos.org/nix/install) --daemon"      
      echo "Caution: Make sure user has sudo privileges and give the password when prompted."
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

# Function to add lines to NIX config file
append_nix_config_file() {
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

# Function to install Nix
install_nix() {
  # Check if Nix is already installed
  if command -v nix >/dev/null 2>&1; then
    echo "Nix is already installed."
  else
    # Condition to check whether 'curl' is installed or not
    if command -v curl &> /dev/null; then
      echo "curl is installed on your system."
    else
      echo "Error: curl is not installed on your system. Please install curl and try again."
      exit 1  # Exit with failure status
    fi
    echo "Nix is not installed. Installing now..."
    # Download and run the Nix installation script
    #curl -L https://nixos.org/nix/install | sh -s -- --daemon
    sh <(curl -L https://nixos.org/nix/install) --daemon
    echo "Nix installation completed."
  fi
}

manage_nix() {
  echo "Do you want to install or uninstall Nix? Enter '1' for install or '0' for uninstall':"
  read user_choice

  case $user_choice in
    1)
      echo "Cleaning up old NIX folders/files..."
      # Calling the function to clean up old NIX folders/files
      cleanup_old_nix_files "/nix/" "/etc/nix" "$HOME/.nix-channels" "$HOME/.nix-defexpr" "$HOME/.nix-profile" "$HOME/.local/state/nix" "$HOME/.config/nix/"
      
      echo "Checking and creating NIX directories..."
      # Calling the functions to check and create the directories for NIX
      check_and_create_nix_directories "$HOME/.local/state/nix/profiles" "$HOME/.config/nix"
      
      echo "Checking and creating NIX config file..."
      # Calling the functions to check and create the NIX config file
      check_and_create_nix_config_file "$HOME/.config/nix/nix.conf" && append_nix_config_file "$HOME/.config/nix/nix.conf"

      echo "Installing Nix..."
      # Calling the function to install Nix
      install_nix
      echo "Succesfully installed Nix."
      
      # calling the script to fetch username and user directory
      bash ./home-manager/fetch_username_userdir.sh

      # Wait for the script to finish execution
      wait $!

      # Execute NIX home manager setup command
      echo "***** Attention: Restart your PC *****"
      echo "After restart execute the following command from the root folder of the project to setup NIX home manager:"
      echo "nix run nixpkgs#home-manager -- switch --flake ./#\$USER"
      ;;
    0)
      echo "Uninstalling Nix..."
      # Calling the function to clean up old NIX folders/files
      cleanup_old_nix_files "/nix" "/etc/nix" "$HOME/.nix-channels" "$HOME/.nix-defexpr" "$HOME/.nix-profile" "$HOME/.local/state/nix" "$HOME/.config/nix/"
      echo "Succesfully uninstalled Nix."
      ;;
    *)
      echo "Invalid choice. Please enter '1' for install or '0' for uninstall."
      ;;
  esac
}

# Main execution starts here
manage_nix

#set +x # Disable debugging