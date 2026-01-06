{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  inherit (config.mine) user;
  cfg = config.mine.apps.wm.hyprland;
  network = config.mine.system.networking.networkmanager;
in
{
  options.mine.apps.wm.hyprland = {
    enable = mkEnableOption "Enable Hyprland WM + related utilities";
    wallpaper = mkOption {
      type = types.submodule {
        options = {
          enable = mkEnableOption "wallpaper";

          path = mkOption {
            type = types.str;
            description = "Path to the wallpaper image";
          };
        };
      };

      default = {
        enable = false;
        path = "";
      };

      description = "Wallpaper configuration";
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.hyprpaper = mkIf cfg.wallpaper.enable {
        enable = true;
        settings = {
          preload = [
            cfg.wallpaper.path
          ];
          wallpaper = [
            ",${cfg.wallpaper.path}"
          ];
        };
      };

      programs.ghostty = {
        enable = true;
        settings.background-opacity = "0.8";
      };
      services.mako.enable = true;

      programs.rofi = {
        enable = true;
        theme = "Arc-Dark";
      };

      wayland.windowManager.hyprland = {
        enable = true;
        extraConfig = ''
          exec-once = hyprpaper
          exec-once = waybar
          exec-once = mako
          exec-once = discord

          monitor = eDP-1, 1920x1080@165, auto, 1
          monitor = HDMI-A-1, 1920x1080@75, auto-left, 1
        '';

        settings = {
          "$mainMod" = "SUPER";
          "$term" = "ghostty";
          "$fm" = "dolphin";
          "$dmenu" = "rofi -show drun";

          env = [
            "XCURSOR_SIZE,12"
            "HYPRCURSOR_SIZE,12"
          ];

          general = {
            layout = "dwindle";
            gaps_in = "2";
            gaps_out = "2";
          };

          dwindle = {
            preserve_split = true;
          };

          group = {
            "col.border_active" = "0xffffffff";
            "col.border_inactive" = "0xff000000";
            groupbar = {
              height = "14";
              font_size = "12";
              indicator_height = "2";
              text_color = "0xffffffff";
              "col.active" = "0xff88c0d0";
              "col.inactive" = "0xff4c566a";
            };
          };
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows, 1, 4, myBezier"
          ];

          decoration = {
            dim_inactive = true;
            dim_strength = 0.1;
            rounding = 2;
          };

          master = {
            new_status = true;
          };

          misc = {
            disable_hyprland_logo = true;
          };

          binds = {
            allow_workspace_cycles = true;
          };

          gestures = "3, horizontal, workspace";

          bind = [
            # Basic apps
            "$mainMod, RETURN, exec, $term"
            "$mainMod, F, fullscreen"
            "$mainMod, Q, killactive"
            "$mainMod, M, exit"
            "$mainMod, T, exec, $fm"
            "$mainMod, SPACE, togglefloating"
            "$mainMod, D, exec, $dmenu"
            "$mainMod, E, togglesplit"

            # Move focus
            "$mainMod, h, movefocus, l"
            "$mainMod, l, movefocus, r"
            "$mainMod, k, movefocus, u"
            "$mainMod, j, movefocus, d"

            "$mainMod SHIFT, h, movewindow, l"
            "$mainMod SHIFT, l, movewindow, r"
            "$mainMod SHIFT, k, movewindow, u"
            "$mainMod SHIFT, j, movewindow, d"

            # Workspace navigation
            "$mainMod, TAB, workspace, previous"

            "$mainMod, 1, workspace, 1"
            "$mainMod, 2, workspace, 2"
            "$mainMod, 3, workspace, 3"
            "$mainMod, 4, workspace, 4"
            "$mainMod, 5, workspace, 5"
            "$mainMod, 6, workspace, 6"
            "$mainMod, 7, workspace, 7"
            "$mainMod, 8, workspace, 8"
            "$mainMod, 9, workspace, 9"
            "$mainMod, 0, workspace, 10"

            # Move window to workspace
            "$mainMod SHIFT, 1, movetoworkspace, 1"
            "$mainMod SHIFT, 2, movetoworkspace, 2"
            "$mainMod SHIFT, 3, movetoworkspace, 3"
            "$mainMod SHIFT, 4, movetoworkspace, 4"
            "$mainMod SHIFT, 5, movetoworkspace, 5"
            "$mainMod SHIFT, 6, movetoworkspace, 6"
            "$mainMod SHIFT, 7, movetoworkspace, 7"
            "$mainMod SHIFT, 8, movetoworkspace, 8"
            "$mainMod SHIFT, 9, movetoworkspace, 9"
            "$mainMod SHIFT, 0, movetoworkspace, 10"

            # Scroll workspaces
            "$mainMod, mouse_down, workspace, e+1"
            "$mainMod, mouse_up, workspace, e-1"
          ];

          bindm = [
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];

          bindel = [
            ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
            ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
            ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
            ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
            ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
          ];

          bindl = [
            ",XF86AudioNext, exec, playerctl next"
            ",XF86AudioPause, exec, playerctl play-pause"
            ",XF86AudioPlay, exec, playerctl play-pause"
            ",XF86AudioPrev, exec, playerctl previous"
          ];
        };
      };
    };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };

    hardware = {
      graphics.enable = true;
      nvidia = {
        modesetting.enable = true;
        open = true;
      };
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    environment.systemPackages = with pkgs; [
      libnotify
    ];

  };
}
