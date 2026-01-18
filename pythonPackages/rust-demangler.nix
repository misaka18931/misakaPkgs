{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:
buildPythonPackage rec {
  pname = "rust_demangler";
  version = "1.0"; # replace with latest version
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-o+iAMuaRMi0UzsE399mvvkSsZahCF8WZvSz+SA7IvQ8=";
  };

  pyproject = true;

  build-system = [
    setuptools
  ];

  meta = with lib; {
    description = "A package for demangling Rust symbols, written in Python.";
    license = licenses.mit;
    homepage = "https://github.com/teambi0s/rust_demangler";
    maintainers = [ "misaka18931" ];
    platforms = platforms.linux;
  };
}
