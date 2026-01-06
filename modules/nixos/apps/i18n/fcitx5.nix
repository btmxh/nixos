{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.i18n.fcitx5;
in
{
  options.mine.apps.i18n.fcitx5 = {
    enable = mkEnableOption "Enable i18n via Fcitx5";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5.addons = with pkgs; [
          fcitx5-bamboo
          fcitx5-mozc
        ];

        fcitx5.settings = {
          inputMethod = {
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "us";
              DefaultIM = "keyboard-us";
            };
            "Groups/0/Items/0".Name = "keyboard-us";
            "Groups/0/Items/1".Name = "bamboo";
            "Groups/0/Items/2".Name = "mozc";
            GroupOrder."0" = "Default";
          };

          globalOptions = {
            Hotkey = {
              EnumerateWithTriggerKeys = true;
              EnumerateForwardKeys = "";
              EnumerateBackwardKeys = "";
              EnumerateSkipFirst = false;
              ModifierOnlyKeyTimeout = 250;
            };

            "Hotkey/TriggerKeys" = {
              "0" = "Control+Shift+space";
              "1" = "Zenkaku_Hankaku";
              "2" = "Hangul";
            };

            "Hotkey/ActivateKeys" = {
              "0" = "Hangul_Hanja";
            };

            "Hotkey/DeactivateKeys" = {
              "0" = "Hangul_Romaja";
            };

            "Hotkey/AltTriggerKeys" = {
              "0" = "Shift_L";
            };

            "Hotkey/EnumerateGroupForwardKeys" = {
              "0" = "Super+space";
            };

            "Hotkey/EnumerateGroupBackwardKeys" = {
              "0" = "Shift+Super+space";
            };

            "Hotkey/PrevPage" = {
              "0" = "Up";
            };

            "Hotkey/NextPage" = {
              "0" = "Down";
            };

            "Hotkey/PrevCandidate" = {
              "0" = "Shift+Tab";
            };

            "Hotkey/NextCandidate" = {
              "0" = "Tab";
            };

            "Hotkey/TogglePreedit" = {
              "0" = "Control+Alt+P";
            };

            Behavior = {
              ActiveByDefault = false;
              resetStateWhenFocusIn = "No";
              ShareInputState = "No";
              PreeditEnabledByDefault = true;
              ShowInputMethodInformation = true;
              showInputMethodInformationWhenFocusIn = false;
              CompactInputMethodInformation = true;
              ShowFirstInputMethodInformation = true;
              DefaultPageSize = 5;
              OverrideXkbOption = false;
              CustomXkbOption = "";
              EnabledAddons = "";
              DisabledAddons = "";
              PreloadInputMethod = true;
              AllowInputMethodForPassword = false;
              ShowPreeditForPassword = false;
              AutoSavePeriod = 30;
            };
          };
        };
      };

    };
  };
}
