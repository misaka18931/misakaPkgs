{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.programs.binaryninja;
in
{
  options.programs.binaryninja = {
    enable = mkEnableOption "Binary Ninja";
    package = mkOption {
      type = types.package;
      default = pkgs.binaryninja; # Assumes you have this in your overlay or pkgs
      description = "The Binary Ninja package to use.";
    };
    extraPackages = mkOption {
      default = ps: [ ];
      description = "User packages (plugins, types, themes, etc.) to be added to configuration.";
    };
    license = mkOption {
      type = types.nullOr (
        types.submodule {
          options = {
            source = mkOption {
              type = types.nullOr types.path;
              default = null;
              description = "Path to the license file.";
            };
            text = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Hardcoded text for the license file.";
            };
          };
        }
      );
      default = null;
      description = "Binary Ninja license";
    };
  };

  config = mkIf cfg.enable (
    let
      managed = cfg.extraPackages cfg.package.pkgs;
      userDir = ".binaryninja";
      mapDirContent =
        drvs: path:
        mkMerge (
          map (
            drv:
            let
              p = "${drv.config}/${path}";
            in
            if (builtins.pathExists p) && (builtins.readFileType p == "directory") then
              mapAttrs' (name: type: {
                name = "${userDir}/${path}/${name}";
                value = {
                  source = "${p}/${name}";
                };
              }) (builtins.readDir p)
            else
              { }
          ) drvs
        );
    in
    {
      # Add Binary Ninja to user packages
      home.packages = [ cfg.package ];
      home.file = mkMerge [
        (mapDirContent managed "plugins")
        (mkIf (cfg.license != null) {
          "${userDir}/license.dat" = cfg.license;
        })
      ];
    }
  );
}
