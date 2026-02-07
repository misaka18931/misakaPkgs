{
  autoPatchelfHook,
  copyDesktopItems,
  dbus,
  fetchurl,
  fontconfig,
  freetype,
  lib,
  libGLU,
  libxkbcommon,
  makeWrapper,
  makeDesktopItem,
  openssl,
  python3,
  qt6,
  requireFile,
  stdenv,
  unzip,
  wayland,
  xcbutilimage,
  xcbutilkeysyms,
  xcbutilrenderutil,
  xcbutilwm,
  libxml2,
}:
let
  BNPython = with python3.pkgs; [
    arrow
    jsonschema
    tiktoken
    networkx
    websockets
    requests
    beautifulsoup4
  ];
  variant = "personal";
in
stdenv.mkDerivation (finalAttrs: rec {
  pname = "binaryninja-${variant}";
  version = "5.2.8614-dev";

  src = requireFile {
    name = "binaryninja_linux_dev_${variant}.zip";
    url = "https://portal.binary.ninja/licenses/";
    sha256 = "sha256-v8qLtNEqIULm7oaiXG7K2nwNusKHwOswCEXNNSmnfBg=";
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/Vector35/binaryninja-api/448f40be71dffa86a6581c3696627ccc1bdf74f2/docs/img/logo.png";
    hash = "sha256-TzGAAefTknnOBj70IHe64D6VwRKqIDpL4+o9kTw0Mn4=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "com.vector35.binaryninja";
      desktopName = "Binary Ninja Personal";
      comment = "A Reverse Engineering Platform";
      exec = "binaryninja";
      icon = "binaryninja";
      mimeTypes = [
        "application/x-binaryninja"
        "x-scheme-handler/binaryninja"
      ];
      categories = [ "Utility" ];
    })
  ];

  dontWrapQtApps = true;

  nativeBuildInputs = [
    unzip
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    dbus
    fontconfig
    freetype
    libGLU
    libxkbcommon
    openssl
    python3
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtshadertools
    stdenv.cc.cc.lib
    wayland
    xcbutilimage
    xcbutilkeysyms
    xcbutilrenderutil
    xcbutilwm
  ];

  preFixup = ''
    # Fix libxml2 breakage. See https://github.com/NixOS/nixpkgs/pull/396195#issuecomment-2881757108
    mkdir -p "$out/lib"
    ln -s "${lib.getLib libxml2}/lib/libxml2.so" "$out/lib/libxml2.so.2"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/
    cp -R . $out/

    patchelf --add-needed libpython3.so $out/binaryninja

    wrapProgram $out/binaryninja \
      --set PYTHONPATH "${python3.pkgs.makePythonPath BNPython}"

    mkdir $out/bin

    ln -s $out/binaryninja $out/bin/binaryninja

    install -Dm644 ${finalAttrs.icon} $out/share/icons/hicolor/256x256/apps/binaryninja.png

    runHook postInstall
  '';

  meta = {
    changelog = "https://binary.ninja/changelog/#${
      lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version
    }";
    description = "Interactive decompiler, disassembler, debugger";
    homepage = "https://binary.ninja/";
    license = {
      fullName = "Binary Ninja Free Software License";
      url = "https://docs.binary.ninja/about/license.html#free-license";
      free = false;
    };
    mainProgram = "binaryninja";
    maintainers = with lib.maintainers; [ scoder12 ];
    platforms = [ "x86_64-linux" ];
  };
})
