{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.dev.llama-cpp;
in
{
  options.mine.apps.dev.llama-cpp = {
    enable = mkEnableOption "Enable llama.cpp";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      home.packages = with pkgs; [
        llama-cpp
      ];
    };
  };
}
