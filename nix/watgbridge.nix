{ lib
, buildGoApplication
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "watgbridge";
  version = "2.0.0";

  # src = fetchFromGitHub {
  #   owner = "watgbridge";
  #   repo = "watgbridge";
  #   rev = "v${version}";
  #   hash = "sha256-QH9H7m96f6tS3DeWB0e5HcljDMLIyUy2SJHk94Q/cD0=";
  # } + "/src/cmd/watgbridge";

  src = ../src/cmd/watgbridge;
  # modules = "${src}/gomod2nix.toml";
  #
  ldflags = [ "-s" "-w" ];

  vendorHash = null;

  meta = with lib; rec {
    description = "A bridge between WhatsApp and Telegram written in Golang";
    homepage = "https://github.com/watgbridge/watgbridge";
    changelog = "${homepage}/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "watgbridge";
  };
}
