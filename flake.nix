{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
            inherit system;
            overlays = [ overlay ];
        };
        overlay = (final: prev: {
          site = prev.callPackage ./. {};
        });
      in 
      rec {
        inherit (overlay);

        defaultPackage = pkgs.site;

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            zola
            vscodium
          ];
        };
      }
    );
}
