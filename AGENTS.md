# AGENTS.md — NixOS Config

## Structure

- **`flake.nix`** — entrypoint; lists every module explicitly in `nixosConfigurations.mine.modules`
- **`config.default.nix`** — the main toggle board; all `mine.apps.<category>.<name>.enable` flags go here. Tracked.
- **`modules/nixos/apps/<category>/<name>.nix`** — per-app NixOS + home-manager module
- **`modules/nixos/`** — `apps/`, `services/`, `system/`, `user/`, `fonts/`
- **`hosts/mine/hardware-configuration.nix`** — auto-generated, do not edit
- **`personal/config.user.nix`** — tracked stub that throws. Placeholder for the `personal` input. Never edit.
- **`personal-ci/config.user.nix`** — CI stand-in (throwaway account, no GPU), used via `--override-input personal path:./personal-ci`. Tracked.
- **`/home/ayaneso/nix-personal/config.user.nix`** — the real machine config: identity, hostname, disks, GPU, `$HOME` paths. **Outside the repo, never committed.**

`flake.nix` imports `config.default.nix` and `inputs.personal + "/config.user.nix"`,
so any option set in the machine config overrides the same option in
`config.default.nix`. Keep the split at that boundary: a toggle belongs in
`config.default.nix`, the value that identifies this machine belongs in the
personal config.

### The machine config is a flake input

Nix builds a local flake's source from the **git index**, so an untracked file
inside the repo is invisible to it:

```
error: Path 'config.user.nix' in the repository "..." is not tracked by Git.
```

That is why the machine config lives outside the repository and arrives as the
`personal` flake input — a `path:` input is copied wholesale, with no git
involvement and no `--impure` needed. `flake.lock` records only the tracked
stub, so the real path never enters git.

| Context | Input |
|---|---|
| local | `--override-input personal path:/home/ayaneso/nix-personal` |
| CI | `--override-input personal path:./personal-ci` |

The local rebuild aliases already carry the flag: it is built from
`mine.apps.shell.bash.rebuild.personalConfig`, which your machine config sets.
A bare `nix build` hits the stub and fails with instructions rather than
quietly building a system with the wrong hostname and user.

## Adding a new app

1. Create `modules/nixos/apps/<category>/<name>.nix` with the standard pattern:
   - options at `mine.apps.<category>.<name>.enable`
   - config inside `mkIf cfg.enable` using `home-manager.users.${user.name}.home.packages` or `environment.systemPackages`
2. Add `./modules/nixos/apps/<category>/<name>.nix` to the `modules` list in `flake.nix` (alphabetical within category)
3. Add `<category>.<name>.enable = true;` to `config.default.nix`

## Build & deploy

Every command needs the `personal` input, or the flake hits the throwing stub.

```sh
# rebuild system
sudo nixos-rebuild switch \
  --override-input personal path:/home/ayaneso/nix-personal \
  --flake /home/ayaneso/dev/nixos#mine

# using the shell alias (if bash.enable + rebuild.enable) — carries the override
rebuild

# just build (no switch)
nix build --override-input personal path:/home/ayaneso/nix-personal \
  .#nixosConfigurations.mine.config.system.build.toplevel
```

## Linting & formatting

```sh
# format with nixfmt
nix fmt

# run pre-commit checks (nixfmt, statix, yaml, eof, trailing-whitespace)
nix flake check
```

Dev shell (with `direnv` via `.envrc`) provides `nixfmt` and `nixd`.

### Check both configs with a full evaluation

`nix eval .#…config.someOption` is lazy: it evaluates only what you ask for, so
it happily returns a value while a missing `enable` flag or a mistyped option
elsewhere in the system would still fail the real build. Use this to force the
whole thing, assertions included, without building:

```sh
# your machine
nix eval --override-input personal path:/home/ayaneso/nix-personal \
  --raw .#nixosConfigurations.mine.config.system.build.toplevel.drvPath

# what CI builds
nix eval --override-input personal path:./personal-ci \
  --raw .#nixosConfigurations.mine.config.system.build.toplevel.drvPath
```

Run both after touching any `enable` flag or any option's type.

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
