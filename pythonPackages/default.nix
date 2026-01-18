pythonPackages:
let
  callPackage = pythonPackages.callPackage;
in
rec {
  ida-netnode = callPackage ./ida-netnode.nix { };
  ida-hcli = callPackage ./ida-hcli.nix { inherit idapro; };
  ida-settings = callPackage ./ida-settings.nix { inherit ida-hcli; };
  idapro = callPackage ./idapro.nix { };
  flare-capa = callPackage ./flare-capa.nix { inherit ida-settings ida-netnode; };
  pylingual = callPackage ./pylingual.nix { };
  rust-demangler = callPackage ./rust-demangler.nix { };
  qiling = callPackage ./qiling.nix { };
  libdebug = callPackage ./libdebug.nix { };
}
