{
  lib,
  config,
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
        sync = {
          autoSync = true;
          syncMedia = true;
        };
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
      };
    };
  };
}
