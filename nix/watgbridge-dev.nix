{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "watgbridge-dev";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "watgbridge";
    repo = "watgbridge";
    rev = "main";
    hash = "sha256-QH9H7m96f6tS3DeWB0e5HcljDMLIyUy2SJHk94Q/cD0=";
  } + "/src/cmd/watgbridge";

  ldflags = [ "-s" "-w" ];

  vendorHash = null;

  meta = with lib; rec {
    description = "A bridge between WhatsApp and Telegram written in Golang";
    homepage = "https://github.com/watgbridge/watgbridge";
    changelog = "${homepage}/compare/v${version}...main";
    license = licenses.mit;
    mainProgram = "watgbridge";
  };
}
