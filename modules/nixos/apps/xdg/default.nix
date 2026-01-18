{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  inherit (config.mine) user apps;

  # Browser MIME types
  browserMimeTypes = [
    "text/html"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/about"
    "x-scheme-handler/unknown"
  ];

  # Image viewer MIME types
  imageMimeTypes = [
    "image/png"
    "image/jpeg"
    "image/jpg"
    "image/gif"
    "image/webp"
    "image/svg+xml"
    "image/bmp"
  ];

  # PDF viewer MIME types
  pdfMimeTypes = [
    "application/pdf"
  ];

  # Video/audio MIME types
  videoMimeTypes = [
    "video/mp4"
    "video/x-matroska"
    "video/webm"
    "video/mpeg"
    "video/x-msvideo"
    "audio/mpeg"
    "audio/mp3"
    "audio/ogg"
    "audio/flac"
    "audio/wav"
  ];

  # Helper function to create MIME associations
  createMimeAssoc = mimeTypes: desktopFile: builtins.listToAttrs (
    map (mimeType: {
      name = mimeType;
      value = desktopFile;
    }) mimeTypes
  );

in
{
  config = mkIf config.mine.user.home-manager.enable {
    home-manager.users.${user.name} = {
      xdg.mimeApps = mkMerge [
        # Enable xdg.mimeApps if any default is set
        {
          enable = mkIf (
            apps.browser.firefox.default
            || apps.browser.chromium.default
            || apps.browser.zen.default
            || apps.viewer.imv.default
            || apps.viewer.mpv.default
            || apps.viewer.sioyek.default
          ) true;
        }

        # Browser defaults
        (mkIf apps.browser.firefox.default {
          defaultApplications = createMimeAssoc browserMimeTypes "firefox.desktop";
        })

        (mkIf apps.browser.chromium.default {
          defaultApplications = createMimeAssoc browserMimeTypes "chromium-browser.desktop";
        })

        (mkIf apps.browser.zen.default {
          defaultApplications = createMimeAssoc browserMimeTypes "zen.desktop";
        })

        # Image viewer defaults
        (mkIf apps.viewer.imv.default {
          defaultApplications = createMimeAssoc imageMimeTypes "imv.desktop";
        })

        # Media player defaults
        (mkIf apps.viewer.mpv.default {
          defaultApplications = createMimeAssoc videoMimeTypes "mpv.desktop";
        })

        # PDF viewer defaults
        (mkIf apps.viewer.sioyek.default {
          defaultApplications = createMimeAssoc pdfMimeTypes "sioyek.desktop";
        })
      ];
    };
  };
}
