{
  description = "Flake for watgbridge";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    gomod2nix = {
        url = "github:nix-community/gomod2nix";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, gomod2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
         inherit system;
         overlays = [ gomod2nix.overlays.default ];
        };
      in
      with pkgs; {

        devShells.default = mkShell {
          name = "watgbridge-dev";
          nativeBuildInputs = [
            go
            gopls
            gomod2nix.packages."${system}".default
          ];

          shellHook = ''
              export GOPATH="$(git rev-parse --show-toplevel)/.go";
          '';
        };

        packages = rec {
          watgbridge = (pkgs.callPackage ./nix/pkgs/watgbridge.nix {});
          # # vX.Y.Z for watgbridge-dev means git after watgbridge-vX.Y.Z release
          watgbridge-dev = (pkgs.callPackage ./nix/pkgs/watgbridge-dev.nix {});

          watgbridgec2c = (pkgs.callPackage ./nix/pkgs/watgbridgec2c.nix {});
          # # vX.Y.Z for watgbridgec2c-dev means git after watgbridgec2c-vX.Y.Z release
          watgbridgec2c-dev = (pkgs.callPackage ./nix/pkgs/watgbridgec2c-dev.nix {});

          default = watgbridge;
        };

      }
    );
}
