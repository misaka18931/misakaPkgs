{
  buildPython3Plugin,
  ...
}:
let
  readJSON = p: builtins.fromJSON (builtins.readFile p);
  buildPluginRepo =
    plugins: bn:
    builtins.listToAttrs (
      map (
        {
          subdir,
          api,
          name,
          ...
        }@spec:
        let
          finalSpec = spec // {
            subdir = if subdir == "" then "." else subdir;
          };
        in
        {
          inherit name;
          value = if builtins.elem "python3" api then buildPython3Plugin finalSpec bn else null;
        }
      ) plugins
    );
in
bn: {
  official = buildPluginRepo (readJSON ./official-plugins.json) bn;
  community = buildPluginRepo (readJSON ./community-plugins.json) bn;
}
