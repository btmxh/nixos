# Portable configuration: the app toggles and settings that do not depend on
# who owns the machine or what hardware is inside it.
#
# Machine-specific values (identity, disks, GPU, file paths) live in
# config.user.nix, which is not tracked by git. CI substitutes config.ci.nix
# for it, so the toggles below are what CI actually builds.
{ lib, pkgs, ... }:
{
  config = {
    nixpkgs.config.allowUnfree = true;

    mine = {
      system = {
        bluetooth.enable = true;
        boot.systemd.enable = true;
        timezone.enable = true;
        networking.networkmanager = {
          enable = true;
          applet = true;
        };
        theme.dark.enable = true;
        udev.stlink.enable = true;
        tablet.otd.enable = true;
      };

      services = {
        audio.pipewire.enable = true;
        remap.interception-tools.enable = true;
        openssh.enable = true;
        angrr.enable = true;
      };

      # Toggle board. Paths and identities for individual apps are set in
      # config.user.nix.
      apps = {
        wm.hyprland = {
          enable = true;
          wallpaper.enable = true;
        };
        wm.waybar.enable = true;
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
          sound.enable = true;
        };
        clipboard.wl-clipboard.enable = true;
        graphics.inkscape.enable = true;
        browser = {
          firefox.enable = true;
          google-chrome.enable = true;
          zen = {
            enable = true;
            default = true;
          };
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
        dev = {
          claude-code.enable = true;
          codex.enable = true;
          opencode.enable = true;
          git = {
            enable = true;
            defaultBranch = "master";
          };
          docker = {
            enable = true;
            customPath.enable = true;
          };
        };
        download.qbittorrent.enable = true;
        cli.zoxide.enable = true;
        cli.comma.enable = true;
        i18n.fcitx5.enable = true;
        shell = {
          direnv.enable = true;
          bash.rebuild.enable = true;
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

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
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

    # Tailscale: private access to local services from phone etc.
    services.tailscale.enable = true;
    networking = {
      firewall = {
        interfaces.tailscale0.allowedTCPPorts = [
          4173 # wtm
        ];
        allowedTCPPorts = [
          1935 # RTMP
          2305 # Steam Remote Play
          5173 # Vite
          5174 # Vite
          8889 # WebRTC
        ];
        allowedUDPPorts = [
          8189 # WebRTC ICE/UDP
        ];
      };
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
    system.stateVersion = "26.05"; # Did you read the comment?
  };
}
