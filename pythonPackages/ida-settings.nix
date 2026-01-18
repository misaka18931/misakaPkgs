{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  ida-hcli,
}:

buildPythonPackage rec {
  pname = "ida-settings";
  version = "3.3.0";
  src = fetchFromGitHub {
    owner = "williballenthin";
    repo = "ida-settings";
    rev = "v${version}";
    hash = "sha256-EVt0swvfaqONm9FaNf3IKOTcgl689vX9zfMPuya5qOY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'uv_build>=0.8.6,<0.9.0' 'uv_build'
  '';

  pyproject = true;

  build-system = [
    uv-build
  ];

  propagatedBuildInputs = [
    ida-hcli
  ];

  meta = with lib; {
    description = "Fetch and set configuration values for IDA Plugins";
    homepage = "https://github.com/williballenthin/ida-settings";
    license = licenses.mit;
    maintainers = [ "misaka18931" ];
    platforms = platforms.linux;
  };
}
