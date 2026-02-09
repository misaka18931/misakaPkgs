callPackage: {
  ida-netnode = callPackage ./ida-netnode.nix { };
  ida-hcli = callPackage ./ida-hcli.nix { };
  ida-settings = callPackage ./ida-settings.nix { };
  idapro = callPackage ./idapro.nix { };
  flare-capa = callPackage ./flare-capa.nix { };
  pylingual = callPackage ./pylingual.nix { };
  rust-demangler = callPackage ./rust-demangler.nix { };
  qiling = callPackage ./qiling.nix { };
  libdebug = callPackage ./libdebug.nix { };
  pysqlite3 = callPackage ./pysqlite3.nix { };
}
