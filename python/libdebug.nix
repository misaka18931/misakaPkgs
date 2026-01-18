{
  lib,
  pkgs,
  buildPythonPackage,
  fetchFromGitHub,
  scikit-build-core,
  cmake,
  ninja,
  pkg-config,
  nanobind,
  typing-extensions,
  elfutils,
  libdwarf,
  libiberty,
  zlib,
  psutil,
  pyelftools,
  prompt-toolkit,
  requests,
}:

buildPythonPackage rec {
  pname = "libdebug";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "libdebug";
    repo = "libdebug";
    rev = "${version}";
    hash = "sha256-J0ETzqAGufsZyW+XDhJCKwX1rrmDBwlAicvBb1AAiIQ=";
  };

  pyproject = true;

  dontUseCmakeConfigure = true;

  build-system = [
    scikit-build-core
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    nanobind
    typing-extensions
  ];

  buildInputs = [
    elfutils
    libdwarf
    libiberty
    pkgs.zstd
    zlib
  ];

  propagatedBuildInputs = [
    psutil
    pyelftools
    prompt-toolkit
    requests
  ];

  meta = with lib; {
    description = "A Python library to debug binary executables, your own way.";
    homepage = "https://libdebug.org/";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
