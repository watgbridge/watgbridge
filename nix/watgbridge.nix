{ lib
, buildGoModule
}:

buildGoModule rec {
  pname = "watgbridge";
  version = "2.0.0";

  src = ../src/cmd/watgbridge;

  ldflags = [ "-s" "-w" ];

  meta = with lib; rec {
    description = "A bridge between WhatsApp and Telegram written in Golang";
    homepage = "https://github.com/watgbridge/watgbridge";
    changelog = "${homepage}/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "watgbridge";
  };
}
