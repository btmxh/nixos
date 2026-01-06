{ pkgs, config, ... }:
let
  inherit (config.mine) user;
in
{
  config = {
    home-manager.users.${user.name} = {
      fonts.fontconfig.enable = true;
      home.packages = with pkgs; [
        nerd-fonts.noto
        nerd-fonts.jetbrains-mono
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        font-awesome
      ];

      fonts.fontconfig.defaultFonts = {
        sansSerif = [ "Noto Sans" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
        serif = [ "Noto Serif" ];
      };
    };
  };
}
