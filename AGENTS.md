# AGENTS.md — NixOS Config

## Structure

- **`flake.nix`** — entrypoint; lists every module explicitly in `nixosConfigurations.mine.modules`
- **`config.user.nix`** — the main toggle board; all `mine.apps.<category>.<name>.enable` flags go here
- **`modules/nixos/apps/<category>/<name>.nix`** — per-app NixOS + home-manager module
- **`modules/nixos/`** — `apps/`, `services/`, `system/`, `user/`, `fonts/`
- **`hosts/mine/hardware-configuration.nix`** — auto-generated, do not edit
- **`config.user.nix.example`** — template used in CI; `config.user.nix` is gitignored

## Adding a new app

1. Create `modules/nixos/apps/<category>/<name>.nix` with the standard pattern:
   - options at `mine.apps.<category>.<name>.enable`
   - config inside `mkIf cfg.enable` using `home-manager.users.${user.name}.home.packages` or `environment.systemPackages`
2. Add `./modules/nixos/apps/<category>/<name>.nix` to the `modules` list in `flake.nix` (alphabetical within category)
3. Add `<category>.<name>.enable = true;` to `config.user.nix`

## Build & deploy

```sh
# rebuild system
sudo nixos-rebuild switch --flake /home/ayaneso/dev/nixos#mine

# using the shell alias (if bash.enable + rebuild.enable)
rebuild

# just build (no switch)
nix build .#nixosConfigurations.mine.config.system.build.toplevel
```

## Linting & formatting

```sh
# format with nixfmt
nix fmt

# run pre-commit checks (nixfmt, statix, yaml, eof, trailing-whitespace)
nix flake check
```

Dev shell (with `direnv` via `.envrc`) provides `nixfmt` and `nixd`.

## Key conventions & gotchas

- **`nixpkgs` follows `nixos-unstable`**
- **Unfree**: globally allowed in `config.user.nix`; per-package `allowUnfreePredicate` for home-manager (currently only `discord`)
- **stateVersion**: `26.05`
- **Hostname**: `ep44` (set in `networking.networkmanager.hostname`)
- **Home-manager** manages user packages (e.g. `home.packages = with pkgs; [ inkscape ]`) — wrap in `home-manager.users.${user.name}`
- **`main.nix`** recursively auto-imports all `default.nix` under `modules/nixos/`, but `flake.nix` explicitly lists every module anyway — always register new modules in `flake.nix`
- **Hardware config** is in `hosts/mine/`; do not edit `hardware-configuration.nix` directly
- **Swap file**: 32 GiB at `/swapfile`, hibernation enabled with resume offset
- **Docker**: rootless, custom data path at `/mnt/cocker/docker`
- **NVIDIA**: `nvidia-container-toolkit` auto-enabled when `system.graphics.nvidia.enable` is set
- **Steam**: enabled with remote play, dedicated server, and local network game transfer ports open
- **MediaMTX**: RTMP (1935) + WebRTC (8889/8189) ports open in firewall
- **CI**: `nix build` on every PR/push to master; `update-flake-lock` runs weekly via cron
- **Git config**: user `btmxh`, default branch `master`
