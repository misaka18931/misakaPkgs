{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:
buildPythonPackage rec {
  pname = "idapro";
  version = "0.0.12";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1vEdUSamuat/AWVzxnSjtapFzzhYn4s9GyhMHI/M1p8=";
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
  };
}
