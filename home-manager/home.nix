{ config, pkgs, ... }:

let
  username = import ./username.nix;
  userdir = import ./userdir.nix;
in

{
  home.username = "${username}";
  home.homeDirectory = "${userdir}";
  home.stateVersion = "24.05";

  imports = [
    ./apps/python.nix
    ./apps/neofetch.nix
    ./apps/docker.nix
    ./apps/zsh.nix
  ];

  programs.home-manager.enable = true;
}