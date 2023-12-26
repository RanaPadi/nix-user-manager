{ config, pkgs, ... }:

let
  username = import ./username.nix;
in

{
  home.username = "ranapadi";
  home.homeDirectory = "/home/ranapadi";
  home.stateVersion = "24.05";
  imports = [
    ./apps/neofetch.nix
    ./apps/git.nix
    ./apps/zsh.nix
    ./apps/python.nix
    ./apps/docker.nix
  ];
  programs.home-manager.enable = true;
}