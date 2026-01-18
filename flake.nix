{
  description = "A set of custom packages that misaka daily drives.";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, flake-utils }:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        formatter = pkgs.nixfmt-tree;
        python3Packages = import ./pythonPackages pkgs.python3.pkgs;

      }
    )) // {
      overlays.python = final: prev: {
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          (pyfinal: pyprev: (import ./pythonPackages pyfinal))
        ];
      };
    };
}
