{ lib
, buildGoApplication
, nix-filter
, self
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

  devVersion = (
    if (builtins.hasAttr "rev" self) then
      self.rev
    else if (builtins.hasAttr "dirtyRev" self) then
      self.dirtyRev
    else
      "dev"
  );

in buildGoApplication rec {
  pname = "watgbridge-dev";
  version = devVersion;

  pwd = localSource;
  src = localSource;

  subPackages = [ "cmd/watgbridge" ];

  ldflags = [
    "-s"
    "-w"
    ''-X "github.com/watgbridge/watgbridge/cmd/watgbridge/state.Version=${version}"''
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
