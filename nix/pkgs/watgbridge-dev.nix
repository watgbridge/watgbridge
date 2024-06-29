{ lib
, buildGoApplication
}:

buildGoApplication rec {
  pname = "watgbridge-dev";
  version = "2.0.0";

  pwd = ../../.;
  src = ../../.;

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
