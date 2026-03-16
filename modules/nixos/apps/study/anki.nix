{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.study.anki;
in
{
  options.mine.apps.study.anki = {
    enable = mkEnableOption "Enable Anki";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.anki = {
        enable = true;
        profiles."User 1".sync = {
          autoSync = true;
          syncMedia = true;
          keyFile = "/home/${user.name}/.anki/sync_key.txt";
          usernameFile = "/home/${user.name}/.anki/username.txt";
        };
        uiScale = 1.0;
        answerKeys = [
          {
            ease = 1;
            key = "j";
          }
          {
            ease = 2;
            key = "k";
          }
          {
            ease = 3;
            key = "l";
          }
          {
            ease = 4;
            key = ";";
          }
        ];
        theme = "dark";
        addons = [
          pkgs.ankiAddons.anki-connect
          (pkgs.anki-utils.buildAnkiAddon (finalAttrs: {
            pname = "speed-focus-mode";
            version = "1.0.0";
            src = pkgs.fetchFromGitHub {
              owner = "glutanimate";
              repo = "speed-focus-mode";
              rev = "f9f409ce151a629d6395d7cf2572935e587d6c16";
              sparseCheckout = [ "src/speed_focus_mode" ];
              sha256 = "sha256-AHPkaXv0RnTJYpMFSn1dnRCjWZEehi9Ip5hxyhQ5hmI=";
            };
            sourceRoot = "source/src/speed_focus_mode";
          }))
        ];
      };
    };
  };
}
