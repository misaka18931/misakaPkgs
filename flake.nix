{
  description = "misakaPkgs";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{ self, flake-parts, ... }:
    let
      evalPackages =
        pkgsRef:
        builtins.mapAttrs (
          f: f_type:
          if f_type != "directory" || (builtins.readDir ./pkgs/${f}) ? "package.nix" == "regular" then
            throw "pkgs/${f} is not a valid package!"
          else
            pkgsRef.callPackage (./pkgs/${f}/package.nix) { }
        ) (builtins.readDir ./pkgs);
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # To import a flake module
        # 1. Add foo to inputs
        # 2. Add foo as a parameter to the outputs function
        # 3. Add here: foo.flakeModule

      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        {
          # Per-system attributes can be defined here. The self' and inputs'
          # module parameters provide easy access to attributes of the same
          # system.
          formatter = pkgs.nixfmt-rfc-style;

          # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
          packages = evalPackages pkgs;
        };
      flake = {
        overlay = final: evalPackages;
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.
        homeManagerModules = builtins.mapAttrs (
          f: f_type:
          if f_type != "directory" || (builtins.readDir ./pkgs/${f}) ? "default.nix" == "regular" then
            throw "pkgs/${f} is not a valid module!"
          else
            import ./hm-modules/${f} self
        ) (builtins.readDir ./hm-modules);
      };
    };
}
