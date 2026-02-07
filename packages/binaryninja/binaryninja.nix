{
  autoPatchelfHook,
  copyDesktopItems,
  dbus,
  imagemagick,
  lib,
  libGL,
  libxkbcommon,
  makeDesktopItem,
  python3,
  qt6,
  requireFile,
  stdenv,
  wayland,
  libxcb-wm,
  libxcb-image,
  libxcb-keysyms,
  libxcb-render-util,
  unzip,
}:
bnpkgs:
stdenv.mkDerivation (finalAttrs: rec {
  pname = "binaryninja";
  APPID = "com.vector35.binaryninja";
  version = "5.2.8722";

  dontWrapQtApps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    imagemagick
    unzip
  ];

  buildInputs = [
    dbus
    libGL
    libxcb-wm
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxkbcommon
    python3
    qt6.qtdeclarative
    wayland
  ];

  desktopItems = map makeDesktopItem [
    {
      name = APPID;
      desktopName = "Binary Ninja";
      exec = pname;
      mimeTypes = [
        "application/x-${pname}"
        "application/x-executable"
        "application/x-elf"
        "application/x-sharedlib"
        "x-scheme-handler/${pname}"
      ];
      icon = pname;
      terminal = false;
      type = "Application";
      categories = [ "Utility" ];
      comment = "Binary Ninja: A Reverse Engineering Platform";
    }
  ];

  installPhase = ''
    runHook preInstall

    local BNPATH=$out/share/${pname}
    mkdir -p $BNPATH
    cp -R . $BNPATH

    # manually link python3
    patchelf --add-needed libpython3.so $BNPATH/libbinaryninjacore.so.1

    mkdir -p $out/{bin,lib}

    for path in ${pname} plugins/scc; do
      ln -s $BNPATH/$path $out/bin/`basename $path`
    done

    for path in libbinaryninjacore.so.1 libbinaryninjaui.so.1; do
      ln -s $BNPATH/$path $out/lib/`basename $path`
    done

    #substituteInPlace $BNPATH/python/binaryninja/_binaryninjacore.py
    #  --replace-fail "os.path.dirname(__file__)" "os.path.dirname()"

    # TODO: package documentations & API

    # mime type
    install -Dm644 ${./binaryninja-mime.xml} $out/share/mime/packages/application-x-${pname}.xml

    # icons
    for i in 16 22 24 32 48 64 128 256 512; do
      ixi="$i"x"$i"
      mkdir -p "$out/share/icons/hicolor/$ixi/apps"
      convert -background none -resize "$ixi" "$out/share/binaryninja/docs/img/logo.png" "$out/share/icons/hicolor/$ixi/apps/binaryninja.png"
    done

    runHook postInstall
  '';

  passthru = {
    fromInstaller =
      installer:
      finalAttrs.finalPackage.overrideAttrs {
        src = if builtins.isAttrs installer then requireFile installer else installer;
      };
    plugins = "plugins";
    pkgs = bnpkgs finalAttrs.finalPackage;
    pythonModule =
      with python3.pkgs;
      toPythonModule (
        let
          bn = finalAttrs.finalPackage;
        in
        stdenv.mkDerivation {
          pname = "binaryninja-python";
          inherit version;
          nativeInstallCheckInputs = [
            python3
            pythonImportsCheckHook
          ];
          pythonImportsCheck = [ "binaryninja" ];
          doInstallCheck = true;
          unpackPhase = "true";
          installPhase = ''
            local site=$out/${python3.sitePackages}
            mkdir -p $site
            for module in ${bn}/share/binaryninja/python/*; do
              ln -s $module $site/
            done
          '';
        }
      );
  };

  meta = {
    changelog = "https://binary.ninja/changelog/#${
      lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version
    }";
    description = "Binary Ninja: A Reverse Engineering Platform";
    homepage = "https://binary.ninja/";
    license = {
      fullName = "BINARY NINJA SOFTWARE LICENSE AGREEMENT";
      url = "https://docs.binary.ninja/about/license.html#non-commercial-student-license-named";
      free = false;
    };
    mainProgram = "binaryninja";
    maintainers = "misaka18931";
    platforms = [ "x86_64-linux" ];
  };
})
