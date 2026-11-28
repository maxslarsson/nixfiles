# Nix Files

A [dendritic](https://github.com/mightyiam/dendritic) flake. Every `.nix` file under `modules/` is a [flake-parts](https://flake.parts) module, loaded by [import-tree](https://github.com/denful/import-tree) (paths containing `/_` are skipped).

Files are named by feature, not by configuration class. A feature contributes to every class it touches, e.g. `shell.nix` sets `flake.modules.darwin.base` and `flake.modules.homeManager.base`.

### Layout

- `flake.nix`: inputs, systems, and the flake-parts modules for `flake.modules`, `darwinConfigurations` and `homeConfigurations`
- `modules/configurations.nix`: declares `configurations.darwin.<name>` and `configurations.home.<name>`, and generates `darwinConfigurations` and `homeConfigurations` from them
- `modules/dev-shell.nix`: the dev shell for this repo
- `modules/formatter.nix`: [treefmt-nix](https://github.com/numtide/treefmt-nix) config for `nix fmt` and its flake check
- `modules/hosts/`: one file per machine (`macbook`), setting `configurations.darwin.<name>`
- `modules/users/`: one file per home (`personal`, `work`), setting `configurations.home.<name>`, plus its system account on hosts that create one
- everything else: features that feed the `base` modules

The repo must be cloned to `~/dev/nixfiles`: `~/.config/nvim` links to `modules/neovim/nvim` in the checkout, so config edits apply without a rebuild.

### Applying

```sh
sudo darwin-rebuild switch --flake ~/dev/nixfiles#macbook
home-manager switch --flake ~/dev/nixfiles#work
```

After the first switch, the fish abbreviation `update` pulls and re-switches the same configuration with [nh](https://github.com/nix-community/nh). `configurations.nix` adds it to every configuration.

### Adding a NixOS host

1. In `configurations.nix`, add a `configurations.nixos` sibling of `darwin` that generates `flake.nixosConfigurations` with `inputs.nixpkgs.lib.nixosSystem`, its `update` running `nh os switch ~/dev/nixfiles#<name>`.
2. Add `modules/hosts/<name>.nix` setting `configurations.nixos.<name>.module`.
3. Give features with a system side a `flake.modules.nixos.base` (e.g. `home-manager.nix` imports `home-manager.nixosModules.home-manager`).
4. Give the user a `flake.modules.nixos.<user>` that creates the account and sets `home-manager.users.<user>`.
