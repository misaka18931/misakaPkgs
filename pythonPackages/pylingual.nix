{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  poetry-core,
  asttokens,
  datasets,
  huggingface-hub,
  matplotlib,
  networkx,
  numpy,
  pydot,
  pyenv,
  requests,
  tokenizers,
  torch,
  tqdm,
  rich,
  seqeval,
  transformers,
  xdis,
  click,
}:

buildPythonPackage rec {
  pname = "pylingual";
  version = "0.1.0-unstable-20260108";
  src = fetchFromGitHub {
    owner = "syssec-utd";
    repo = pname;
    rev = "99c74eeff5262c0200a3d378298af1f736e20b01";
    hash = "sha256-+DSMw4N3Fx53dwCDlzXwSjlmfSCXcK0w0FQk17Xsqmk=";
  };

  pyproject = true;

  build-system = [
    poetry-core
  ];

  propagatedBuildInputs = [
    asttokens
    datasets
    huggingface-hub
    matplotlib
    networkx
    numpy
    pydot
    pyenv
    requests
    tokenizers
    torch
    tqdm
    rich
    seqeval
    transformers
    xdis
    click
  ];
  pythonRelaxDeps = [ "transformers" ];
  meta = with lib; {
    description = "Python decompiler for modern Python versions.";
    homepage = "https://pylingual.io";
    license = licenses.mit;
    maintainers = [ "misaka18931" ];
    platforms = platforms.linux;
  };
}
