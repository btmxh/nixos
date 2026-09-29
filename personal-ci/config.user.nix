# CI stand-in for the machine config, passed to the flake as
# `--override-input personal path:./personal-ci` by .github/workflows/build.yml.
#
# It only supplies the values config.default.nix cannot know: a throwaway
# account name, a placeholder hostname, and dummy paths. The app toggles
# themselves stay in config.default.nix, so CI exercises the real ones instead
# of a stale copy of them.
{
  lib,
  pkgs,
  config,
  ...
}:
let
  name = config.mine.user.name;
in
{
  config = {
    home-manager.users.${name} = {
      nixpkgs.config = {
        allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "discord"
            "discord-unwrapped"
            "google-chrome"
          ];
      };
    };

    mine = {
      user = {
        enable = true;
        name = "ci";
        home-manager.enable = true;
        shell = {
          package = pkgs.bash;
          starship.enable = true;
        };
      };

      system.networking.networkmanager.hostname = "ci";

      apps = {
        # The only deliberate divergence from the machine config. mediawiki
        # downloads extension tarballs from extdist.wmflabs.org at build time,
        # and Scribunto-REL1_45-61207ea.tar.gz now 404s, so a cold-cache CI
        # runner cannot build it. Your machine keeps the wiki; only CI opts out.
        #
        # mkForce is required: config.default.nix already sets this flag, and
        # two plain definitions of the same option conflict.
        wiki.personal_mediawiki.enable = lib.mkForce false;

        wm.hyprland.wallpaper = {
          path = "/tmp/wallpaper.png";
          secondPath = "/tmp/wallpaper-2.png";
        };
        notification.mako.sound.path = "/tmp/notification.wav";
        dev.git = {
          userName = "ci";
          userEmail = "ci@example.com";
        };
        dev.docker.customPath.path = "/var/lib/docker";
        shell.bash.rebuild.nixosDir = "/tmp/nixos";
      };
    };
  };
}
