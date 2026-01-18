{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  rustPlatform,
  maturin,
}:

buildPythonPackage rec {
  pname = "python-flirt";
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "williballenthin";
    repo = "lancelot";
    rev = "v${version}";
    sha256 = "sha256-IgkfUkVsJyAsqH+L9GBdTQI1ure4k8mVLLWHj7AFDj8=";
  };

  # Because this is a Rust extension (PyO3), include Rust toolchain
  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  build-system = [
    maturin
  ];

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ar-0.9.0" = "sha256-eyi1MlhJVvsiBOsetDHXFpdk+ABeZo/fVXNyvc5mw9s=";
    };
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  pyproject = true;

  # Possibly set build crates features if needed
  # e.g., set environment variable or cargo flags
  buildInputs = [ ]; # any runtime dependencies?

  # If the Python package lives in a sub-directory (e.g., python/), set:
  # sourceRoot = "pylancelot";

  meta = with lib; {
    description = "Python bindings for lancelot-flirt (flirt signatures matching)";
    homepage = "https://github.com/williballenthin/lancelot";
    # license = licenses.apache2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.yourname ];
  };
}
