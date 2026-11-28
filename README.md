# Nix Files

A [dendritic](https://github.com/mightyiam/dendritic) flake. Every `.nix` file under `modules/` is a [flake-parts](https://flake.parts) module, loaded by [import-tree](https://github.com/denful/import-tree) (paths containing `/_` are skipped).

Files are named by feature, not by configuration class. A feature contributes to every class it touches, e.g. `shell.nix` sets `flake.modules.darwin.base` and `flake.modules.homeManager.base`.

### Layout

- `modules/hosts/`: one file per machine, defining its host module and `darwinConfigurations` entry
- `modules/users/`: one file per user, defining its home module, standalone `homeConfigurations` entry and system account
- everything else: features that feed the `base` modules

### Applying

```sh
sudo darwin-rebuild switch --flake .     # Maxs-MacBook-Pro
home-manager switch --flake .#mlarsson   # standalone home-manager
```

### Adding a NixOS host

1. Add `modules/hosts/<name>.nix` defining `flake.modules.nixos.<name>` and `flake.nixosConfigurations.<name>`.
2. Give features with a system side a `flake.modules.nixos.base` (e.g. `home-manager.nix` imports `home-manager.nixosModules.home-manager`).
3. Give the user a `flake.modules.nixos.<user>` that creates the account and sets `home-manager.users.<user>`.
