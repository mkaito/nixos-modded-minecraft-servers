{
  description = "This is a flake template";

  inputs = {
    nix.url = "github:NixOS/nix";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";

    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    inherit (nixpkgs.lib) recursiveUpdate foldl' nixosSystem;
  in
    foldl' recursiveUpdate {} [
      # System-dependent outputs
      (flake-utils.lib.eachDefaultSystem (system: let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (pkgs) mkShell;
      in {
        devShell = mkShell {
          buildInputs = with pkgs; [
            # Make sure we have a fresh nix
            nixUnstable
            alejandra
            rnix-lsp
          ];
        };
      }))

      # System-independent outputs
      {
        module = import ./nixos/modules/services/games/minecraft-servers;
      }
    ];
}
