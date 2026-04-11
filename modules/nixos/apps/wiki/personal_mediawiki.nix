{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.wiki.personal_mediawiki;
in
{
  options.mine.apps.wiki.personal_mediawiki = {
    enable = mkEnableOption "Enable personal MediaWiki";
  };

  config = mkIf cfg.enable {
    services.mediawiki = {
      enable = true;
      # Prior to NixOS 24.05, there is a admin name bug that prevents using spaces in the mediawiki name https://github.com/NixOS/nixpkgs/issues/298902
      name = "Personal_MediaWiki";
      httpd.virtualHost = {
        hostName = "mediawiki.localhost";
        adminAddr = "admin@example.com";
      };
      # Administrator account username is admin.
      # Set initial password to "cardbotnine" for the account admin.
      passwordFile = pkgs.writeText "password" "cardbotnine";
      extraConfig = ''
        # Disable anonymous editing
        $wgGroupPermissions['*']['edit'] = false;
        $wgDefaultSkin = 'citizen';
      '';
      skins = {
        Citizen = pkgs.fetchzip {
          url = "https://github.com/StarCitizenTools/mediawiki-skins-Citizen/archive/refs/heads/main.zip";
          hash = "sha256-2MA+mc6FaD0a59jsdhSMousiD4l4ladQ9YfN7Mn93R8=";
        };
      };

      extensions = {
        VisualEditor = null;
        Cite = null;
        Poem = null;
        WikiEditor = null;
        Gadgets = null;

        # https://www.mediawiki.org/wiki/Extension:TemplateStyles
        TemplateStyles = pkgs.fetchzip {
          url = "https://extdist.wmflabs.org/dist/extensions/TemplateStyles-REL1_45-637da08.tar.gz";
          hash = "sha256-h3WcSzGryuWRnXoRcGIpjcOhkLo31/7fwYDfPW2eZ7M=";
        };

        PortableInfobox = pkgs.fetchFromGitHub {
          owner = "Universal-Omega";
          repo = "PortableInfobox";
          hash = "sha256-KWTmxKNo5JxCkPPRbU6e+UyI7rG4UAeLsN/lg4Z9+R0=";
          rev = "3dbdf893652c7fa189cbb5a3f5f6fb27e3bd3b3d";
        };

        Scribunto = pkgs.fetchzip {
          url = "https://extdist.wmflabs.org/dist/extensions/Scribunto-REL1_45-61207ea.tar.gz";
          hash = "sha256-K1+1tnzkKsQoQ+crWqhHXcp4F8rIDg5Oqq+jEnPam4c=";
        };

        Variables = pkgs.fetchzip {
          url = "https://extdist.wmflabs.org/dist/extensions/Variables-REL1_45-ada8bc6.tar.gz";
          hash = "sha256-F5mEwIE2zjNm0XpGgL3GrW0phF7IFxVt/0UJtSf0/yw=";
        };

        VariablesLua = pkgs.fetchFromGitHub {
          owner = "Liquipedia";
          repo = "VariablesLua";
          rev = "64a5776f055b33c38602e8a94f7237a6b8cb4c79";
          hash = "sha256-IyvI08vxQ1aH5QSPjjNjXej3yE9AnMy02TMRy0OkZ74=";
        };

        ParserFunctions = pkgs.fetchzip {
          url = "https://extdist.wmflabs.org/dist/extensions/ParserFunctions-REL1_45-b1349db.tar.gz";
          hash = "sha256-LVPTMBB2hgDW+gPTxC85/nluXReOjtM5uWsrzJ3BOLw=";
        };
      };
    };
  };
}
