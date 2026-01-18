{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  pyyaml,
  colorama,
  pefile,
  pyelftools,
  pydantic,
  rich,
  humanize,
  protobuf,
  msgspec,
  xmltodict,
  dnfile,
  dncil,
  vivisect,
  viv-utils,
  ruamel-yaml,
  networkx,
  ida-settings,
  ida-netnode,
}:
buildPythonPackage rec {
  pname = "flare-capa";
  version = "9.3.1"; # replace with latest version

  src = fetchPypi {
    pname = "flare_capa";
    inherit version;
    hash = "sha256-XTrWRF5QD5uvLq6odJi/r2dGOXtkmwJdvsbcSvi16tk=";
  };

  pyproject = true;

  build-system = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    pyyaml
    colorama
    pefile
    pyelftools
    pydantic
    rich
    humanize
    protobuf
    msgspec
    xmltodict
    dnfile
    dncil
    vivisect
    viv-utils
    ruamel-yaml
    networkx
    ida-settings
    ida-netnode
  ];

  meta = with lib; {
    description = "The FLARE team's open-source tool to identify capabilities in executable files.";
    homepage = "https://mandiant.github.io/capa/";
    license = licenses.asl20;
    maintainers = [ "misaka18931" ];
    platforms = platforms.linux;
  };
}
