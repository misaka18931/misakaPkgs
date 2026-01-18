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
    description = "Python module for demangling rust function names";
    license = licenses.mit;
  };
}
