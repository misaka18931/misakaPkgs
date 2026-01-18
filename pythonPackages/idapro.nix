{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:
buildPythonPackage rec {
  pname = "idapro";
  version = "0.0.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Cy4YSxnk2EBOpIsfF/ObIbBUkxMVlA7pcW74VZFEmI8=";
  };

  pyproject = true;

  build-system = [
    setuptools
  ];

  propagatedBuildInputs = [

  ];

  meta = with lib; {
    description = "IDA Library Python Module";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ "misaka18931" ];
  };
}
