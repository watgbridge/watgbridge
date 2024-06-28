{ lib
, buildGoApplication
}:

buildGoApplication rec {
  pname = "watgbridge-dev";
  version = "2.0.0";

  pwd = ../../.;
  src = ../../.;

  ldflags = [
    "-s"
    "-w"
    "-X 'github.com/watgbridge/watgbridge/cmd/watgbridge/state.VERSION=${version}-dev'"
  ];

  meta = with lib; rec {
    description = "A bridge between WhatsApp and Telegram written in Golang";
    homepage = "https://github.com/watgbridge/watgbridge";
    changelog = "${homepage}/compare/v${version}...main";
    license = licenses.mit;
    mainProgram = "watgbridge";
  };
}