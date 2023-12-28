{ config, pkgs, ... }:

let
  username = import ./username.nix;
in

{
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.05";
  home.packages = with pkgs; [
    python3
    python311Packages.pip
    docker
    neofetch
    ];
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "docker-compose" "docker" ];
      theme = "dst";
    };
    initExtra = ''
      bindkey '^f' autosuggest-accept
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.home-manager.enable = true;
}