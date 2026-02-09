{
  description = "A set of custom packages that misaka daily drives.";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    pyproject-nix.url = "github:pyproject-nix/pyproject.nix";
    pyproject-nix.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }@inputs:
    (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        formatter = pkgs.nixfmt-tree;
        python3Packages = import ./pythonPackages pkgs.python3.pkgs;
        packages = {
          binaryninja = pkgs.callPackage ./packages/binaryninja { inherit inputs pkgs; };
        };
      }
    ))
    // {
      overlays.default = final: prev: {
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          (pyfinal: pyprev: (import ./pythonPackages pyfinal))
        ];
        binaryninja = final.callPackage ./packages/binaryninja {
          inherit inputs;
          pkgs = final;
        };
      };
      homeManagerModules.binaryninja = import ./modules/home-manager/binaryninja.nix;
    };
}
