# nixos

My personal NixOS config

Enable programs & services you want in `config.user.nix` (there is an example file). Note: the `config.user.nix` file on Git is merely a placeholder.

To enable, run
```sh
nixos-rebuild switch --flake /home/ayaneso/dev/nixos#mine --sudo
```
