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
  version = "0.1.0-unstable-2026-10-27";
  src = fetchFromGitHub {
    owner = "syssec-utd";
    repo = pname;
    rev = "aca827dd2d2b7ec9ba7e648c818857a8b45daef6";
    hash = "sha256-bC8cZ0nzhTiBFDVb/1JrlX3xkJeCqa393Q8NrWb8+g8=";
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
