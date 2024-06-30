{
  description = "Flake for watgbridge";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nix-filter.url = "github:numtide/nix-filter";
    gomod2nix = {
        url = "github:nix-community/gomod2nix";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    gomod2nix,
    nix-filter
  }: flake-utils.lib.eachDefaultSystem (system:
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
        # # vX.Y.Z for watgbridge means git after watgbridge-vX.Y.Z release
        watgbridge = (pkgs.callPackage ./nix/pkgs/watgbridge-dev.nix { inherit nix-filter; });
        # # vX.Y.Z for watgbridgec2c means git after watgbridgec2c-vX.Y.Z release
        watgbridgec2c = (pkgs.callPackage ./nix/pkgs/watgbridgec2c-dev.nix { inherit nix-filter; });
        default = watgbridge;
      };

    }
  );
}
