{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.services.openssh;
in
{
  options.mine.services.openssh = {
    enable = mkEnableOption "Enable OpenSSH server";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "no";
      };
      openFirewall = true;
    };

    programs.ssh.startAgent = true;
  };
}
