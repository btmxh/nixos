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
            "discord-unwrapped"
            "google-chrome"
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

      agentUser = {
        enable = true;
        name = "aiagent";
        email = "agent@ai.com";
        shell.package = pkgs.bash;
      };

      system = {
        bluetooth.enable = true;
        boot.systemd.enable = true;
        timezone.enable = true;
        networking.networkmanager = {
          enable = true;
          hostname = "ep44";
          applet = true;
        };
        theme.dark.enable = true;
        graphics.nvidia.enable = true;
        udev = {
          stlink.enable = true;
        };
        tablet.otd.enable = true;
      };

      services = {
        audio.pipewire.enable = true;
        remap.interception-tools.enable = true;
        openssh.enable = true;
        angrr.enable = true;
      };

      apps = {
        wm.hyprland = {
          enable = true;
          wallpaper = {
            enable = true;
            path = "~/msobiggestenemy.png";
            secondPath = "~/msosecondbiggestenemy.png";
          };
        };
        wm.waybar = {
          enable = true;
        };
        terminal.ghostty.enable = true;
        launcher.rofi.enable = true;
        screenshot = {
          grimblast.enable = true;
          obs.enable = true;
        };
        cli = {
          brightness.enable = true;
          media.enable = true;
          yt-dlp.enable = true;
        };
        notification.mako = {
          enable = true;
          sound = {
            enable = true;
            path = "/home/ayaneso/Downloads/mixkit-correct-answer-tone-2870.wav";
          };
        };
        clipboard.wl-clipboard.enable = true;
        graphics.inkscape.enable = true;
        browser.firefox.enable = true;
        browser.google-chrome.enable = true;
        browser.zen = {
          enable = true;
          default = true;
        };

        chat.discord.enable = true;
        games = {
          prism.enable = true;
          osu_lazer.enable = true;
        };
        study.anki.enable = true;
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
        dev.claude-code.enable = true;
        dev.codex.enable = true;
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
        download.qbittorrent.enable = true;
        cli.zoxide.enable = true;
        cli.comma.enable = true;
        i18n.fcitx5.enable = true;
        shell = {
          direnv.enable = true;
          bash.rebuild = {
            enable = true;
            nixosDir = "$HOME/dev/nixos";
          };
        };
        wiki.personal_mediawiki.enable = true;
        viewer = {
          foliate.enable = true;

          mpv = {
            enable = true;
            default = true;
            bluray.enableAACS = true;
          };

          spotify.enable = true;

          imv = {
            enable = true;
            default = true;
          };

          sioyek = {
            enable = true;
            default = true;
          };
        };
      };
    };

    # docker drive
    fileSystems."/mnt/cocker" = {
      device = "/dev/nvme0n1p4";
      fsType = "ext4";
    };

    # swap file
    swapDevices = [
      {
        device = "/swapfile";
        size = 32 * 1024; # 32 GiB
      }
    ];

    # hibernation
    powerManagement.enable = true;
    boot = {
      # run: sudo filefrag -v /swapfile | head
      kernelParams = [ "resume_offset=34277376" ];
      # run: lsblk -f
      resumeDevice = "/dev/disk/by-uuid/673b9226-52bc-4638-be21-a14ffccfc5f0";
    };

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    users.users.ayaneso = {
      extraGroups = [ "dialout" ];
    };

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        linuxPackages.nvidia_x11
        libxcb
        libGL
        libGLU
        glib
        libxcb
        libX11
        libXext
        libXrender
        libXi
        libICE
        libSM
      ];
    };

    services.mediamtx = {
      enable = true;

      settings = {
        # RTMP ingest
        rtmp = true;
        rtmpAddress = ":1935";

        # WebRTC playback
        webrtc = true;
        webrtcAddress = ":8889";
        webrtcAdditionalHosts = [ "192.168.0.104" ];

        # Optional HLS
        hls = false;

        paths = {
          all = {
            source = "publisher";
          };
        };
      };
    };

    networking.firewall.allowedTCPPorts = [
      1935 # RTMP
      2305 # Steam Remote Play
      5173 # Vite
      5174 # Vite
      8889 # WebRTC
    ];

    networking.firewall.allowedUDPPorts = [
      8189 # WebRTC ICE/UDP
    ];

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "26.05"; # Did you read the comment?
  };
}
