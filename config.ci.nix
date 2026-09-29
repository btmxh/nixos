# Stand-in for the untracked config.user.nix, used by CI (.github/workflows/build.yml).
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
        name = "ci";
        email = "ci@example.com";
        home-manager.enable = true;
        shell = {
          package = pkgs.bash;
          starship.enable = true;
        };
      };

      system.networking.networkmanager.hostname = "ci";

      apps = {
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
