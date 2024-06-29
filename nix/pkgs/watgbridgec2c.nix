{ lib
, buildGoApplication
, fetchFromGitHub
}:

buildGoApplication rec {
  pname = "watgbridgec2c";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "watgbridge";
    repo = "watgbridge";
    rev = "watgbridgec2c-v${version}";
    sha256 = "sha256-+Xx1aH4jNMjNplT/i4CKdAr6NQkv6qPBvnQ7zTd6098=";
  };
  pwd = src;

  subPackages = [ "cmd/watgbridgec2c" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; rec {
    description = "A bridge between WhatsApp and Telegram written in Golang";
    homepage = "https://github.com/watgbridge/watgbridge";
    changelog = "${homepage}/releases/tag/watgbridgec2c-v${version}";
    license = licenses.mit;
    mainProgram = "watgbridgec2c";
  };
}