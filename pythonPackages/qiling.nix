{
  lib,
  buildPythonPackage,
  capstone,
  fetchFromGitHub,
  gevent,
  keystone-engine,
  multiprocess,
  pefile,
  poetry-core,
  pyelftools,
  pythonOlder,
  python-fx,
  python-registry,
  pyyaml,
  questionary,
  termcolor,
  unicorn,
}:

buildPythonPackage rec {
  pname = "qiling";
  version = "1.4.11-unstable-2026-09-24";

  pyproject = true;

  build-system = [
    poetry-core
  ];

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "qilingframework";
    repo = "qiling";
    rev = "23ad4fd369a360ad7992d90cb7577f0241061c2b";
    hash = "sha256-MQh5lK7rdyR3kJ8FJnF7AbVxmUepQVK/v6mlq43n2ns=";
  };
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'unicorn = "2.1.3"' 'unicorn = ">=2.1.3"'
  '';

  propagatedBuildInputs = [
    capstone
    gevent
    keystone-engine
    multiprocess
    pefile
    pyelftools
    python-fx
    python-registry
    pyyaml
    termcolor
    questionary
    unicorn
  ];

  # Tests are broken (attempt to import a file that tells you not to import it,
  # amongst other things)
  # doCheck = false;

  pythonImportsCheck = [ "qiling" ];

  meta = with lib; {
    description = "Qiling Advanced Binary Emulation Framework";
    homepage = "https://qiling.io/";
    changelog = "https://github.com/qilingframework/qiling/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = [ ];
  };
}
