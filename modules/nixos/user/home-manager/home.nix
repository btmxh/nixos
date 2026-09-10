{ user, inputs, ... }:
{
  imports = [
    # inputs.sops-nix.homeManagerModules.sops
  ];

  config = {
    programs.home-manager.enable = true;

    home = {
      username = "${user.name}";
      stateVersion = "26.05";
      # homeDirectory = "${user.homeDir}";
    };
  };
}
