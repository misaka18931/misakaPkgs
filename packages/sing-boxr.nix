pkgs: pkgs.sing-box.overrideAttrs (prev: {
  version = "1.13.0-unstable-2026-02-28";
  src = pkgs.fetchFromGitHub {
    owner = "reF1nd";
    repo = "sing-box";
    rev = "7536a8302dafc0ce1e3bb15d4ee6cb2709d5af24";
    hash = "sha256-so6OAF9oeaKlXndg3usod6CNAUwC0a9NX1TOS8MYG/Y=";
  };
  vendorHash = "sha256-vVLaG0PV1OXA+YL67BnrHJiSkNVzJbZ8TeMKbO2rMu0=";
  meta = prev.meta // {
    homepage = "https://sing-boxr.dustinwin.us.kg";
    description = prev.meta.description + " (fork at reF1nd/sing-box)";
  };
})
