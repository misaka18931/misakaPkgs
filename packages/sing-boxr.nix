pkgs: pkgs.sing-box.overrideAttrs (prev: {
  version = "1.15.0-alpha.13-unstable-2026-10-26";
  src = pkgs.fetchFromGitHub {
    owner = "reF1nd";
    repo = "sing-box";
    rev = "732618a5989cd2566f072c374fe2f619200f33f9";
    hash = "sha256-Q29HT/FZwRecuolIVsZ4RhtiaNW3oGKOtj19jb0U+Z8=";
  };
  vendorHash = "sha256-jmoLLw/7JM1gsTIITt85vjkCUayubt+s4p4ZOBIzG1Y=";
  meta = prev.meta // {
    homepage = "https://sing-boxr.dustinwin.us.kg";
    description = prev.meta.description + " (fork at reF1nd/sing-box)";
  };
})
