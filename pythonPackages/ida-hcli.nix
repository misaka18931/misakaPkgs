{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  click,
  rich,
  rich-click,
  httpx,
  supabase,
  pydantic,
  platformdirs,
  packaging,
  questionary,
  semantic-version,
  requests,
  idapro,
  gotrue,
  pip,
  tomli,
  pyyaml,
  tenacity,
}:

buildPythonPackage rec {
  pname = "ida-hcli";
  version = "0.16.4";

  src = fetchFromGitHub {
    owner = "HexRaysSA";
    repo = "ida-hcli";
    rev = "v${version}";
    hash = "sha256-WL/TuvlWsd+Vwf0a/PhlblUcYPGF0ylfoowBa4igEdg=";
  };

  pyproject = true;

  build-system = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    click
    rich
    rich-click
    httpx
    supabase
    pydantic
    platformdirs
    packaging
    questionary
    semantic-version
    requests
    idapro
    gotrue
    pip
    tomli
    pyyaml
    tenacity
  ];

  pythonRelaxDeps = [ "pip" ];

  meta = with lib; {
    description = "A modern command-line interface for managing IDA Pro licenses, downloads, ...";
    homepage = "https://hcli.docs.hex-rays.com/";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
