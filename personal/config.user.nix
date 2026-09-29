# This file exists only so `flake.nix` has something to import when no machine
# config is supplied. It deliberately fails.
#
# Your real machine config lives OUTSIDE this repository, at
# /home/ayaneso/nix-personal/config.user.nix, and is passed in as a flake
# input so its contents never enter git. See AGENTS.md.
_:
throw ''
  config.user.nix was not supplied.

  The flake imports this file from the `personal` flake input. The input
  defaults to this stub, which throws on purpose. To build your real system,
  point the input at your machine config:

    nixos-rebuild switch \
      --override-input personal path:/home/ayaneso/nix-personal \
      --flake .#mine --sudo

  The `rebuild` alias already does this for you. To build the CI stand-in
  instead (throwaway account, no GPU), use:

    --override-input personal path:./personal-ci
''
