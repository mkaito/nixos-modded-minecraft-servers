# Nix flake template

This template contains:

* `nix` from git master
* `nixpkgs` from `nixos-20.09`
* `flake-utils`
* `flake-compat` with shims in `default.nix` and `shell.nix`
* `devShell` defined for all `defaultSystems` with said `nix` from master
