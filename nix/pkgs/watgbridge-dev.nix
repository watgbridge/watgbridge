{ lib
, buildGoApplication
, nix-filter
}:

let

  localSource = nix-filter {
    name = "watgbridge";
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
  pname = "watgbridge-dev";
  version = "2.0.0";

  pwd = localSource;
  src = localSource;

  subPackages = [ "cmd/watgbridge" ];

  ldflags = [
    "-s"
    "-w"
    ''-X "github.com/watgbridge/watgbridge/cmd/watgbridge/state.Version=${version}-dev"''
    ''-X "github.com/watgbridge/watgbridge/cmd/watgbridge/state.SupportsBinaryUpdatesStr=false"''
  ];

  meta = with lib; rec {
    description = "A bridge between WhatsApp and Telegram written in Golang";
    homepage = "https://github.com/watgbridge/watgbridge";
    changelog = "${homepage}/compare/watgbridge-v${version}...main";
    license = licenses.mit;
    mainProgram = "watgbridge";
  };
}
