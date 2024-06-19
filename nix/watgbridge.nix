{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "watgbridge";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "watgbridge";
    repo = "watgbridge";
    rev = "v${version}";
    hash = lib.fakeHash;
  };

  ldflags = [ "-s" "-w" ];

  meta = with lib; rec {
    description = "A bridge between WhatsApp and Telegram written in Golang";
    homepage = "https://github.com/watgbridge/watgbridge";
    changelog = "${homepage}/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "watgbridge";
  };
}
