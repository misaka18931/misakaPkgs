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
  version = "1.4.7";

  pyproject = true;

  build-system = [
    poetry-core
  ];

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "qilingframework";
    repo = "qiling";
    rev = version;
    hash = "sha256-B3p3Ve/mZvKZLbVlEjItS+O4tSYwJV7wSsj0gV/CZq8=";
  };
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'capstone = "^4"' 'capstone = ">=4"' \
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
