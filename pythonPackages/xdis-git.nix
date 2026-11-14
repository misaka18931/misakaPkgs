pkgs: xdis: xdis.overrideAttrs (prev:
  {
    version = "6.3.1-unstable-2026-11-13";
    src = pkgs.fetchFromGitHub {
      owner = "rocky";
      repo = "python-xdis";
      rev = "35d8df26622903e57c97a797cb7fefd2f0338267";
      hash = "sha256-63E5KcoT6yROAWNeZVk99pdMwNzq3roBiTDIGLw9qos=";
    };
})
