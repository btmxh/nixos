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

          secondPath = mkOption {
            type = types.str;
            description = "Path to the wallpaper image for the second monitor";
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
      services = {
        hyprpaper = mkIf cfg.wallpaper.enable {
          enable = true;
          settings = {
            splash = false;
            wallpaper = [
              {
                monitor = "eDP-1";
                inherit (cfg.wallpaper) path;
              }
              {
                monitor = "HDMI-A-1";
                path = cfg.wallpaper.secondPath or cfg.wallpaper.path;
              }
            ];
          };
        };
      };

      gtk.iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "adwaita-icon-theme";
      };

      home.sessionVariables = {
        WLR_NO_HARDWARE_CURSORS = "1";
        NIXOS_OZONE_WL = "1";
      };

      wayland.windowManager.hyprland = {
        enable = true;

        settings =
          let
            inherit (lib.generators) mkLuaInline;

            keyboardBinds = [
              # Basic apps
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + RETURN\"")
                  (mkLuaInline "hl.dsp.exec_cmd(term)")
                ];
              }
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + F\"")
                  (mkLuaInline "hl.dsp.window.fullscreen({ action = \"toggle\" })")
                ];
              }
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + Q\"")
                  (mkLuaInline "hl.dsp.window.close()")
                ];
              }
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + M\"")
                  (mkLuaInline "hl.dsp.exit()")
                ];
              }
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + T\"")
                  (mkLuaInline "hl.dsp.exec_cmd(fm)")
                ];
              }
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + SPACE\"")
                  (mkLuaInline "hl.dsp.window.float({ action = \"toggle\" })")
                ];
              }
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + P\"")
                  (mkLuaInline "hl.dsp.window.pin()")
                ];
              }
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + D\"")
                  (mkLuaInline "hl.dsp.exec_cmd(dmenu)")
                ];
              }
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + E\"")
                  (mkLuaInline "hl.dsp.layout(\"togglesplit\")")
                ];
              }
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + SHIFT + F\"")
                  (mkLuaInline "hl.dsp.exec_cmd(\"hyprlock\")")
                ];
              }

              # Move focus with vim keys
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + h\"")
                  (mkLuaInline "hl.dsp.focus({ direction = \"l\" })")
                ];
              }
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + l\"")
                  (mkLuaInline "hl.dsp.focus({ direction = \"r\" })")
                ];
              }
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + k\"")
                  (mkLuaInline "hl.dsp.focus({ direction = \"u\" })")
                ];
              }
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + j\"")
                  (mkLuaInline "hl.dsp.focus({ direction = \"d\" })")
                ];
              }

              # Move window in direction
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + SHIFT + h\"")
                  (mkLuaInline "hl.dsp.window.move({ direction = \"l\" })")
                ];
              }
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + SHIFT + l\"")
                  (mkLuaInline "hl.dsp.window.move({ direction = \"r\" })")
                ];
              }
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + SHIFT + k\"")
                  (mkLuaInline "hl.dsp.window.move({ direction = \"u\" })")
                ];
              }
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + SHIFT + j\"")
                  (mkLuaInline "hl.dsp.window.move({ direction = \"d\" })")
                ];
              }

              # Previous workspace
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + TAB\"")
                  (mkLuaInline "hl.dsp.focus({ workspace = \"previous\" })")
                ];
              }

              # Screenshots (grimblast)
              {
                _args = [
                  "Print"
                  (mkLuaInline "hl.dsp.exec_cmd(\"grimblast copy area\")")
                ];
              }
              {
                _args = [
                  "SHIFT + Print"
                  (mkLuaInline "hl.dsp.exec_cmd(\"grimblast edit area\")")
                ];
              }
              {
                _args = [
                  "CTRL + Print"
                  (mkLuaInline "hl.dsp.exec_cmd(\"grimblast copy screen\")")
                ];
              }
              {
                _args = [
                  "CTRL + SHIFT + Print"
                  (mkLuaInline "hl.dsp.exec_cmd(\"grimblast edit screen\")")
                ];
              }
              {
                _args = [
                  "SUPER + Print"
                  (mkLuaInline "hl.dsp.exec_cmd(\"grimblast copy active\")")
                ];
              }
              {
                _args = [
                  "SUPER + SHIFT + Print"
                  (mkLuaInline "hl.dsp.exec_cmd(\"grimblast edit active\")")
                ];
              }

              # Group operations
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + G\"")
                  (mkLuaInline "hl.dsp.group.toggle()")
                ];
              }
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + SHIFT + G\"")
                  (mkLuaInline "hl.dsp.window.move({ out_of_group = true })")
                ];
              }
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + CTRL + J\"")
                  (mkLuaInline "hl.dsp.group.next()")
                ];
              }
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + CTRL + K\"")
                  (mkLuaInline "hl.dsp.group.prev()")
                ];
              }

              # Scroll workspaces
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + mouse_down\"")
                  (mkLuaInline "hl.dsp.focus({ workspace = \"e+1\" })")
                ];
              }
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + mouse_up\"")
                  (mkLuaInline "hl.dsp.focus({ workspace = \"e-1\" })")
                ];
              }
            ]
            # Workspace switching: mainMod + [0-9]
            ++ builtins.genList (
              i:
              let
                ws = i + 1;
                key = if ws == 10 then "0" else toString ws;
              in
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + ${key}\"")
                  (mkLuaInline "hl.dsp.focus({ workspace = ${toString ws} })")
                ];
              }
            ) 10
            # Move window to workspace: mainMod + SHIFT + [0-9]
            ++ builtins.genList (
              i:
              let
                ws = i + 1;
                key = if ws == 10 then "0" else toString ws;
              in
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + SHIFT + ${key}\"")
                  (mkLuaInline "hl.dsp.window.move({ workspace = ${toString ws} })")
                ];
              }
            ) 10;

            mouseBinds = [
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + mouse:272\"")
                  (mkLuaInline "hl.dsp.window.drag()")
                  { mouse = true; }
                ];
              }
              {
                _args = [
                  (mkLuaInline "mainMod .. \" + mouse:273\"")
                  (mkLuaInline "hl.dsp.window.resize()")
                  { mouse = true; }
                ];
              }
            ];

            mediaBinds = [
              {
                _args = [
                  "XF86AudioRaiseVolume"
                  (mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+\")")
                  {
                    locked = true;
                    repeating = true;
                  }
                ];
              }
              {
                _args = [
                  "XF86AudioLowerVolume"
                  (mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-\")")
                  {
                    locked = true;
                    repeating = true;
                  }
                ];
              }
              {
                _args = [
                  "XF86AudioMute"
                  (mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle\")")
                  {
                    locked = true;
                    repeating = true;
                  }
                ];
              }
              {
                _args = [
                  "XF86AudioMicMute"
                  (mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle\")")
                  {
                    locked = true;
                    repeating = true;
                  }
                ];
              }
              {
                _args = [
                  "XF86MonBrightnessUp"
                  (mkLuaInline "hl.dsp.exec_cmd(\"brightnessctl -e4 -n2 set 5%+\")")
                  {
                    locked = true;
                    repeating = true;
                  }
                ];
              }
              {
                _args = [
                  "XF86MonBrightnessDown"
                  (mkLuaInline "hl.dsp.exec_cmd(\"brightnessctl -e4 -n2 set 5%-\")")
                  {
                    locked = true;
                    repeating = true;
                  }
                ];
              }
            ];

            playerctlBinds = [
              {
                _args = [
                  "XF86AudioNext"
                  (mkLuaInline "hl.dsp.exec_cmd(\"playerctl next\")")
                  { locked = true; }
                ];
              }
              {
                _args = [
                  "XF86AudioPause"
                  (mkLuaInline "hl.dsp.exec_cmd(\"playerctl play-pause\")")
                  { locked = true; }
                ];
              }
              {
                _args = [
                  "XF86AudioPlay"
                  (mkLuaInline "hl.dsp.exec_cmd(\"playerctl play-pause\")")
                  { locked = true; }
                ];
              }
              {
                _args = [
                  "XF86AudioPrev"
                  (mkLuaInline "hl.dsp.exec_cmd(\"playerctl previous\")")
                  { locked = true; }
                ];
              }
            ];

            allBinds = keyboardBinds ++ mouseBinds ++ mediaBinds ++ playerctlBinds;
          in
          {
            # Lua local variables
            mainMod = {
              _var = "SUPER";
            };
            term = {
              _var = "ghostty";
            };
            fm = {
              _var = "dolphin";
            };
            dmenu = {
              _var = "rofi -show drun";
            };

            # Autostart
            on = {
              _args = [
                "hyprland.start"
                (mkLuaInline ''
                  function()
                    hl.exec_cmd("hyprpaper")
                    hl.exec_cmd("waybar")
                    hl.exec_cmd("discord")
                  end
                '')
              ];
            };

            # Monitors
            monitor = [
              {
                output = "eDP-1";
                mode = "1920x1080@165";
                position = "0x0";
                scale = 1;
              }
              {
                output = "HDMI-A-1";
                mode = "1920x1080@75";
                position = "-1920x0";
                scale = 1;
              }
              {
                output = "DP-6";
                mode = "2560x1440@120";
                position = "0x-1440";
                scale = 1;
              }
              {
                output = "DP-5";
                mode = "2560x1440@120";
                position = "-2560x-1440";
                scale = 1;
              }
              {
                output = "";
                mode = "preferred";
                position = "auto";
                scale = "auto";
              }
            ];

            # Workspace-to-monitor mapping
            workspace_rule = [
              {
                workspace = "1";
                monitor = "DP-5";
                default = true;
              }
              {
                workspace = "5";
                monitor = "DP-6";
              }
              {
                workspace = "6";
                monitor = "eDP-1";
              }
              {
                workspace = "7";
                monitor = "eDP-1";
              }
              {
                workspace = "9";
                monitor = "HDMI-A-1";
                default = true;
              }
              {
                workspace = "10";
                monitor = "eDP-1";
              }
            ];

            # Environment variables
            env = [
              {
                _args = [
                  "XCURSOR_SIZE"
                  "12"
                ];
              }
              {
                _args = [
                  "HYPRCURSOR_SIZE"
                  "12"
                ];
              }
            ]
            ++ lib.optionals (config.mine.system.graphics.nvidia.enable or false) [
              {
                _args = [
                  "LIBVA_DRIVER_NAME"
                  "nvidia"
                ];
              }
              {
                _args = [
                  "__GLX_VENDOR_LIBRARY_NAME"
                  "nvidia"
                ];
              }
            ];

            # Main config groups
            config = {
              general = {
                layout = "dwindle";
                gaps_in = 2;
                gaps_out = 2;
              };
              dwindle = {
                preserve_split = true;
              };
              group = {
                col = {
                  border_active = "0xffffffff";
                  border_inactive = "0xff000000";
                };
                groupbar = {
                  height = 14;
                  font_size = 12;
                  indicator_height = 2;
                  gradients = true;
                  text_color = "0xff181825";
                  text_color_inactive = "0xffcdd6f4";
                  col = {
                    active = "0xffcdd6f4";
                    inactive = "0xff313244";
                  };
                };
              };
              decoration = {
                dim_inactive = true;
                dim_strength = 0.1;
                rounding = 2;
              };
              master = {
                new_status = "master";
              };
              misc = {
                disable_hyprland_logo = true;
              };
              binds = {
                allow_workspace_cycles = true;
              };
            };

            # Custom bezier curve
            curve = [
              {
                _args = [
                  "myBezier"
                  (mkLuaInline "{ type = \"bezier\", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } }")
                ];
              }
            ];

            # Animation
            animation = [
              {
                leaf = "windows";
                enabled = true;
                speed = 4;
                bezier = "myBezier";
              }
            ];

            # Window rule: discord on workspace 10
            window_rule = {
              match = {
                class = "discord";
              };
              workspace = 10;
            };

            # ── Binds ──
            bind = allBinds;
          };
      };
    };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    programs.hyprlock.enable = true;

    environment.systemPackages = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };
}
