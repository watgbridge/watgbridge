{ lib
, buildGoApplication
, nix-filter
, self
}:

let

  localSource = nix-filter {
    name = "watgbridgec2c";
    root = ../../.;
    exclude = [
      "flake.nix"
      "flake.lock"
      "README.md"
      ".github"
      "nix"
      ".envrc"
      ".gitignore"
      "Dockerfile"
      "LICENSE"
      ./cmd/watgbridgec2c
    ];
  };

in buildGoApplication rec {
  pname = "watgbridgec2c-dev";
  version = "2.0.0";

  pwd = localSource;
  src = localSource;

  subPackages = [ "cmd/watgbridgec2c" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; rec {
    description = "A bridge between WhatsApp and Telegram written in Golang";
    homepage = "https://github.com/watgbridge/watgbridge";
    changelog = "${homepage}/compare/watgbridgec2c-v${version}...main";
    license = licenses.mit;
    mainProgram = "watgbridge";
  };
}
