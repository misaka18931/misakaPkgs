{
  lib,
  rustPlatform,
  fetchFromGitHub,
  python3,
  cmake,
  libclang,
}:
rustPlatform.buildRustPackage rec {
  pname = "lancelot";
  version = "v0.9.7";

  src = fetchFromGitHub {
    owner = "williballenthin";
    repo = pname;
    rev = version;
    hash = "sha256-IgkfUkVsJyAsqH+L9GBdTQI1ure4k8mVLLWHj7AFDj8=";
  };

  nativeBuildInputs = [
    python3
    cmake
  ];

  buildInputs = [

  ];

  LIBCLANG_PATH = "${libclang.lib}/lib";

  cargoHash = "sha256-2b4Je8zIntTSHmxu9nR7G26T8Aud4kvl1Bq1df5pbGM=";
  cargoPatches = [
    ./add-Cargo-lock.patch
  ];
  meta = with lib; {
    description = "intel x86(-64) code analysis library that reconstructs control flow ";
    homepage = "https://github.com/williballenthin/lancelot";
    license = licenses.apsl20;
  };
}
