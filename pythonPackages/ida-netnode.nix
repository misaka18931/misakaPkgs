{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  six,
}:
buildPythonPackage rec {
  pname = "ida-netnode";
  version = "3.0";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-t+Hy+/V+PhBO13nVjl8/BQqkjM5YG6uL8UzO56MV4y4=";
  };

  pyproject = true;

  build-system = [
    setuptools
  ];

  propagatedBuildInputs = [
    six
  ];

  meta = with lib; {
    description = "Humane API for storing and accessing persistent data in IDA Pro databases";
    homepage = "https://github.com/williballenthin/ida-netnode";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
