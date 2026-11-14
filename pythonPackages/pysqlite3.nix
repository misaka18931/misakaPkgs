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
  version = "testnewbuild-1";
  src = fetchFromGitHub {
    owner = "coleifer";
    repo = pname;
    tag = version;
    hash = "sha256-GJ6Y9NjA3qdH1tR3+rV7g/fGHsQkeMDwzKNMHADlTBk=";
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
  };
}
