{
  lib,
  buildPythonPackage,
  evaluate,
  fetchFromGitHub,
  setuptools,
  asttokens,
  datasets,
  tensorboardx,
  huggingface-hub,
  hatchling,
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
  xdis-git,
  click,
}:

buildPythonPackage rec {
  pname = "pylingual";
  version = "0-unstable-2026-01-16";
  src = fetchFromGitHub {
    owner = "syssec-utd";
    repo = pname;
    rev = "fb400cd0e419f919754d1c799a11e50ca6c67706";
    hash = "sha256-knvpcqYiqTZkgjaTyqaqzbLj4wbAwnupqlztCiYJ2ZQ=";
  };

  pyproject = true;

  build-system = [
    hatchling
  ];

  propagatedBuildInputs = [
    asttokens
    datasets
    evaluate
    tensorboardx
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
    xdis-git
    click
  ];

  pythonRelaxDeps = [ "transformers" ];

  meta = with lib; {
    description = "Python decompiler for modern Python versions.";
    homepage = "https://pylingual.io";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
