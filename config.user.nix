{ lib, pkgs, ... }:
{
  config = {
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
    home-manager.users.ayaneso = {
      nixpkgs.config = {
        allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "discord"
          ];
      };
    };

    mine = {
      user = {
        enable = true;
        name = "ayaneso";
        email = "ngoduyanh.chip@gmail.com";
        home-manager.enable = true;
        shell = {
          package = pkgs.bash;
          starship.enable = true;
        };
      };

      system = {
        boot.systemd.enable = true;
        timezone.enable = true;
        networking.networkmanager = {
          enable = true;
          hostname = "ep44";
          applet = true;
        };
        theme.dark.enable = true;
      };

      services = {
        audio.pipewire.enable = true;
        remap.interception-tools.enable = true;
      };

      apps = {
        wm.hyprland = {
          enable = true;
          wallpaper = {
            enable = true;
            path = "~/442.png";
          };
        };
        wm.waybar = {
          enable = true;
        };
        browser.firefox.enable = true;
        browser.zen.enable = true;
        chat.discord.enable = true;
        editor.nvim = {
          enable = true;
          default = true;
          lsp.skipInstallServers = true;
        };
        editor.helix.enable = true;
        filemanager.dolphin = {
          enable = true;
          udisk2 = true;
        };
        dev.git = {
          enable = true;
          userName = "btmxh";
          userEmail = "ngoduyanh.chip@gmail.com";
          defaultBranch = "master";
        };
        dev.docker = {
          enable = true;
          customPath = {
            enable = true;
            path = "/mnt/cocker/docker";
          };
        };
        cli.zoxide.enable = true;
        i18n.fcitx5.enable = true;
        shell = {
          direnv.enable = true;
          bash.rebuild = {
            enable = true;
            nixosDir = "$HOME/dev/nixos";
          };
        };
      };
    };

    # docker drive
    fileSystems."/mnt/cocker" = {
      device = "/dev/nvme0n1p4";
      fsType = "ext4";
    };

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "25.11"; # Did you read the comment?
  };
}
