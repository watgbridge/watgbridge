{ lib
, buildGoApplication
, fetchFromGitHub
}:

buildGoApplication rec {
  pname = "watgbridge";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "watgbridge";
    repo = "watgbridge";
    rev = "watgbridge-v${version}";
    sha256 = "sha256-+Xx1aH4jNMjNplT/i4CKdAr6NQkv6qPBvnQ7zTd6098=";
  };
  pwd = src;

  subPackages = [ "cmd/watgbridge" ];

  ldflags = [
    "-s"
    "-w"
    ''-X "github.com/watgbridge/watgbridge/cmd/watgbridge/state.Version=${version}"''
    "-X 'github.com/watgbridge/watgbridge/cmd/watgbridge/state.SupportsBinaryUpdatesStr=false'"
  ];

  meta = with lib; rec {
    description = "A bridge between WhatsApp and Telegram written in Golang";
    homepage = "https://github.com/watgbridge/watgbridge";
    changelog = "${homepage}/releases/tag/watgbridge-v${version}";
    license = licenses.mit;
    mainProgram = "watgbridge";
  };
}
