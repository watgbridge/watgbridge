{
  description = "Flake for watgbridge";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      with pkgs; {

        devShells.default = mkShell {
          name = "watgbridge-dev";
          nativeBuildInputs = [ go gopls ];
          buildInputs = [ libwebp ];
        };

        packages = rec {
          watgbridge = (pkgs.callPackage ./nix/watgbridge.nix {});
          default = watgbridge;
        };

      }
    );
}
