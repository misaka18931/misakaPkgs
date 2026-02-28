pkgs: pkgs.sing-box.overrideAttrs (prev: {
  version = "1.13.0-unstable-2026-02-28";
  src = pkgs.fetchFromGitHub {
    owner = "reF1nd";
    repo = "sing-box";
    rev = "6da7e538e122b77c226ce48c1a6b4ecb61fd3fc4";
    hash = "sha256-lhkz/mXydZz5iJllqSp4skA4+jxs8oUmon/oFs98Zfc=";
  };
  vendorHash = "sha256-vVLaG0PV1OXA+YL67BnrHJiSkNVzJbZ8TeMKbO2rMu0=";
  meta = prev.meta // {
    homepage = "https://sing-boxr.dustinwin.us.kg";
    description = prev.meta.description + " (fork at reF1nd/sing-box)";
  };
})
