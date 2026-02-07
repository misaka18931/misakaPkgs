loadRequirementsTxt: pkgs: ps:
{
  subdir,
  packageUrl,
  sha256,
  path,
  version,
  name,
  dependencies,
  ...
}:
bn:
let
  normalizeName = name: pkgs.lib.toLower (builtins.replaceStrings [ "_" ] [ "-" ] name);
  stripPy = name: pkgs.lib.removePrefix "py" name;
  extractPythonDeps =
    requirements:
    map
      (
        { name, ... }:
        let
          norm = normalizeName name;
        in
        if ps ? ${name} then
          ps.${name}
        else if ps ? ${norm} then
          ps.${norm}
        else if ps ? ${stripPy name} then
          ps.${stripPy name}
        else
          ps.${stripPy norm}
      )
      (loadRequirementsTxt {
        inherit requirements;
      }).dependencies.dependencies;
in
ps.toPythonModule (
  pkgs.stdenv.mkDerivation rec {
    inherit version;
    src = pkgs.fetchurl {
      url = packageUrl;
      name = "${path}.zip";
      inherit sha256;
    };

    nativeBuildInputs = [ pkgs.unzip ];

    outputs = [
      "out"
      "config"
    ];
    pname = "binaryninja-plugin-${name}";
    propagatedBuildInputs = extractPythonDeps dependencies;
    passthru.binaryninjaPakcage = true;
    installPhase = ''
      local dest=$out/${bn.plugins}/${pname}
      mkdir -p $out
      cp -r . $out
      local init=$out/${subdir}/__init__.py
      local LINE="import sys; sys.path = '${ps.makePythonPath propagatedBuildInputs}'.split(':') + sys.path\n"
      local LAST_LINE=$(grep -n "from __future__" "$init" | tail -n 1 | cut -d: -f1)
      if [ -z "$LAST_LINE" ]; then
        sed -i "1i $LINE" "$init"
      else
        sed -i "''${LAST_LINE}a $LINE" "$init"
      fi

      mkdir -p $config/${bn.plugins}
      ln -s $out/${subdir} $config/${bn.plugins}/${path}
    '';
  }
)
