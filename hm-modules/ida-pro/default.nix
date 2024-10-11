self:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  cfg = config.programs.ida-pro;
in
{
  options.programs.ida-pro = {
    enable = lib.mkEnableOption "enable the Interactive Disassembler";
    package = lib.mkOption {
      type = lib.types.package;
      default = self.packages.${system}.ida-pro-rc1;
    };
    pythonEnv = lib.mkOption {
      type = lib.types.package;
      default = pkgs.python3;
    };
    plugins = lib.mkOption {

      type = lib.types.listOf lib.types.anything;
      default = [ ];
    };
  };
  config = lib.mkIf cfg.enable (
    let
      python = cfg.pythonEnv;
      ida-pro = cfg.package;
    in
    {
      home.packages = [ ida-pro ];
      # TODO: is it really anywhere?
      # this also loads any python packages avaliable in the user's python
      home.activation.ida-pro = lib.hm.dag.entryAnywhere ''
        run ${ida-pro}/opt/idapyswitch --force-path ${python}/lib/lib${python.libPrefix}.so
      '';
    }
  );
}
