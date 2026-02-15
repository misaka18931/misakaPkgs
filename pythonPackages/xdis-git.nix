pkgs: xdis: xdis.overrideAttrs (prev:
  {
    version = "6.1.8-unstable-2026-02-08";
    src = pkgs.fetchFromGitHub {
      owner = "rocky";
      repo = "python-xdis";
      rev = "859621a9ee026d94b2b40178a62491af5332b414";
      hash = "sha256-pdOe+ok8xHh/FUVkxrqMwZDf6sQhf+ey7JUBrNPnT78=";
    };
})
