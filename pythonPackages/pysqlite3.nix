{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  sqlite,
  pythonOlder,
  ...
}:
buildPythonPackage rec {
  pname = "pysqlite3";
  version = "0.6.0";
  src = fetchFromGitHub {
    owner = "coleifer";
    repo = pname;
    tag = version;
    hash = "sha256-OpUbzYNqe3xFHd11icAHfb0mAbjO8HFj6iQcEYPpcRY=";
  };

  pyproject = true;

  build-system = [
    setuptools
  ];

  buildInputs = [
    sqlite
  ];

  disabled = pythonOlder "3.9";

  meta = with lib; {
    description = "SQLite3 DB-API 2.0 driver from Python 3, packaged separately, with improvements ";
    homepage = "https://github.com/coleifer/pysqlite3";
    license = licenses.zlib;
    maintainers = [ "misaka18931" ];
  };
}
