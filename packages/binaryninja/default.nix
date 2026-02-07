{
  inputs,
  pkgs,
  callPackage,
  python3,
  ...
}:
let
  bnPackages = import ./pkgs/generated.nix {
    buildPython3Plugin =
      import ./pkgs/plugin.nix inputs.pyproject-nix.lib.project.loadRequirementsTxt pkgs
        python3.pkgs;
  };
in
(callPackage ./binaryninja.nix { }) bnPackages
