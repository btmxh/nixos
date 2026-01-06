{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    git-hooks.url = "github:cachix/git-hooks.nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      systems,
      nixpkgs,
      ...
    }@inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      nixosConfigurations.mine = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          inputs.home-manager.nixosModules.default
          ./hardware-configuration.nix
          ./config.user.nix
          ./modules/nixos/system/boot/systemd.nix
          ./modules/nixos/system/locale/default.nix
          ./modules/nixos/system/networking/networkmanager.nix

          ./modules/nixos/system/theme/dark.nix

          ./modules/nixos/fonts/default.nix

          ./modules/nixos/services/audio/pipewire.nix
          ./modules/nixos/services/remap/interception-tools.nix

          ./modules/nixos/user/default.nix
          ./modules/nixos/user/home-manager/default.nix
          ./modules/nixos/user/starship/default.nix

          ./modules/nixos/apps/shell/bash.nix
          ./modules/nixos/apps/cli/essential.nix
          ./modules/nixos/apps/i18n/fcitx5.nix

          ./modules/nixos/apps/browser/chromium.nix
          ./modules/nixos/apps/browser/firefox.nix
          ./modules/nixos/apps/browser/zen.nix

          ./modules/nixos/apps/chat/discord.nix

          ./modules/nixos/apps/dev/git.nix

          ./modules/nixos/apps/editor/nvim.nix
          ./modules/nixos/apps/editor/helix.nix

          ./modules/nixos/apps/filemanager/dolphin.nix

          ./modules/nixos/apps/wm/hyprland.nix
          ./modules/nixos/apps/wm/waybar/default.nix
        ];
      };

      # Run the hooks with `nix fmt`.
      formatter = forEachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          inherit (self.checks.${system}.pre-commit-check) config;
          inherit (config) package configFile;
          script = ''
            ${pkgs.lib.getExe package} run --all-files --config ${configFile}
          '';
        in
        pkgs.writeShellScriptBin "pre-commit-run" script
      );

      # Run the hooks in a sandbox with `nix flake check`.
      # Read-only filesystem and no internet access.
      checks = forEachSystem (system: {
        pre-commit-check = inputs.git-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixfmt.enable = true;
            statix.enable = true;
            check-yaml.enable = true;
            end-of-file-fixer.enable = true;
            trim-trailing-whitespace.enable = true;
          };
        };
      });

      devShells = forEachSystem (system: {
        default =
          let
            pkgs = nixpkgs.legacyPackages.${system};
            inherit (self.checks.${system}.pre-commit-check) shellHook enabledPackages;
          in
          pkgs.mkShell {
            inherit shellHook;
            buildInputs = enabledPackages;
          };
      });
    };
}
