# nix-user-manager

## Disclaimer:
For now, the nix shell script and nix files work seamlessly on any non-Nix Linux OS. Plug-and-play functionality to work on Nix OS is in progress.

## Step-1: (NIX Install/Uninstall)
1. Go to the root directory of the current project and run the bash script **nix_setup.sh** using the  command: ``` ./nix_setup.sh ```.
    1. Type '1' at the script execution shell prompt to fresh install NIX configuration manager on your Linux system.
    2. Type '0' at the script execution shell prompt to uninstall NIX configuration manager and/or cleanup old NIX files on your Linux system.
2. Restart your Linux PC to activate the NIX daemon process.

## Step-2: (NIX Home Manager Setup)
1. Go to the root directory of the current project and run the bash script **fetch_username_userdir.sh** using the  command: ``` ./home-manager/fetch_username_userdir.sh ```.
2. Go to the root directory of the current project and set up the home configuration for the current user using the command: ```nix run nixpkgs#home-manager -- switch --flake ./#$USER```

## Troubleshooting Steps (Work In Progress)
