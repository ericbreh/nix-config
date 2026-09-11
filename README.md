# ericbreh's nix-config

Nix config focused on simplicity and ease of use. Follows the dendritic pattern.

- **Standalone Features:** Every file or directory under `modules/features/` is an isolated feature that never imports another feature.

- **Unified Exports:** Each feature exports its options as a NixOS module, a Home Manager module, or both. If a NixOS host needs Home Manager options, the NixOS module injects the Home Manager module via `home-manager.sharedModules`, so NixOS hosts only ever import NixOS modules.

- **Flat Directory Structure:** Features remain as single `.nix` files in `modules/features/` by default, becoming a directory when they require supporting files.

This allows each host to maintain a single list of features in its `configuration.nix` which could include any combination of features without worrying about duplicate imports.

- **Generated Hardware Config:** Each NixOS host's `hardware.nix` contains only what `nixos-generate-config` produced. All manual changes live in the host's `configuration.nix`.

## Hosts

| Host | Type | Description |
| --- | --- | --- |
| `titan` | NixOS | Laptop |
| `silver` | NixOS | Server |
| `rhea` | NixOS | Server |
| `vzgccy` | Home Manager | WSL |

## Installation

### NixOS host

```sh
nixos-generate-config --show-hardware-config > modules/hosts/<host>/hardware.nix
sudo nixos-rebuild switch --flake .#<host>
```

### Home Manager host

```sh
nix run home-manager -- switch --flake .#<host>
```
