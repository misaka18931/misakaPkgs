loadRequirementsTxt: pkgs: ps: bn:
{
  subdir,
  packageUrl,
  sha256,
  path,
  version,
  name,
  ...
}:
let
  extractPythonDeps =
    p:
    map ({ name, ... }: ps.${name})
      (loadRequirementsTxt {
        requirements = if builtins.pathExists p then builtins.readFile p else "";
      }).dependencies.dependencies;
in
ps.toPythonModule (
  pkgs.stdenv.mkDerivation rec {
    inherit version;
    src = pkgs.fetchurl {
      url = packageUrl;
      name = path;
      inherit sha256;
    };

    outputs = [
      "out"
      "config"
    ];
    pname = "binaryninja-plugin-${name}";
    propagatedBuildInputs = extractPythonDeps "${src}/${subdir}/requirements.txt";
    passthru.binaryninjaPakcage = true;
    installPhase = ''
      local dest=$out/${bn.plugins}/${pname}
      mkdir -p $out
      cp -r . $out
      sed -i "1i import sys; sys.path = '${ps.makePythonPath propagatedBuildInputs}'.split(':') + sys.path" $out/${subdir}/__init__.py
      mkdir -p $config/${bn.plugins}
      ln -s $out/${subdir} $config/${bn.plugins}/${pname}
    '';
  }
)
