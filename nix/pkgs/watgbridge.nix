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
    rev = "v${version}";
    sha256 = "sha256-+Xx1aH4jNMjNplT/i4CKdAr6NQkv6qPBvnQ7zTd6098=";
  };
  pwd = src;

  ldflags = [
    "-s"
    "-w"
    "-X 'github.com/watgbridge/watgbridge/cmd/watgbridge/state.VERSION=${version}'"
  ];

  meta = with lib; rec {
    description = "A bridge between WhatsApp and Telegram written in Golang";
    homepage = "https://github.com/watgbridge/watgbridge";
    changelog = "${homepage}/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "watgbridge";
  };
}
