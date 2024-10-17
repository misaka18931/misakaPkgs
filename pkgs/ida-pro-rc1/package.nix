{
  autoPatchelfHook,
  cairo,
  copyDesktopItems,
  dbus,
  requireFile,
  fontconfig,
  freetype,
  glib,
  gtk3,
  lib,
  libdrm,
  libGL,
  libkrb5,
  libsecret,
  libsForQt5,
  libunwind,
  libxkbcommon,
  makeWrapper,
  openssl,
  python3,
  stdenv,
  xorg,
  zlib,
}:

let
  srcs = builtins.fromJSON (builtins.readFile ./srcs.json);
in
stdenv.mkDerivation rec {
  pname = "ida-pro";
  version = "9.0.240925";

  # https://auth.lol/ida
  src = requireFile {
    name = "ida-pro_90_x64linux.run";
    url = "magnet:?xt=urn:btih:920c1a578e815e9d0e4b843179306cdcb5e8e00d&dn=idapro90rc1";
    hash = "sha256-FZz4mDoOexmdbvq1r0Lsoxoojn7y7ETrpjNt5Ky4EHo=";
  };

  patcher = ./keygen2.py;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
    autoPatchelfHook
    libsForQt5.wrapQtAppsHook
    python3
  ];

  # We just get a runfile in $src, so no need to unpack it.
  dontUnpack = true;

  # Add everything to the RPATH, in case IDA decides to dlopen things.
  runtimeDependencies = [
    cairo
    dbus
    fontconfig
    freetype
    glib
    gtk3
    libdrm
    libGL
    libkrb5
    libsecret
    libsForQt5.qtbase
    libsForQt5.qtwayland
    libunwind
    libxkbcommon
    openssl
    stdenv.cc.cc
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libXau
    xorg.libxcb
    xorg.libXext
    xorg.libXi
    xorg.libXrender
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xorg.xcbutilwm
    zlib
  ];
  buildInputs = runtimeDependencies;

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib $out/opt $out/share

    # IDA depends on quite some things extracted by the runfile, so first extract everything
    # into $out/opt, then remove the unnecessary files and directories.
    IDADIR=$out/opt

    # where IDA will save its .desktop entries
    HOME=$out/share
    mkdir -p $out/share/Desktop

    # Invoke the installer with the dynamic loader directly, avoiding the need
    # to copy it to fix permissions and patch the executable.
    $(cat $NIX_CC/nix-support/dynamic-linker) $src \
      --mode unattended --prefix $IDADIR

    # move desktop entries to where they belongs
    mv $out/share/Desktop $out/share/applications

    # patch libida.so
    pushd $IDADIR
    python $patcher
    mv libida.so.patched libida.so
    mv libida32.so.patched libida32.so
    popd

    # move IDA remote debug servers
    mv $IDADIR/dbgsrv $out/share

    # Some libraries come with the installer.
    addAutoPatchelfSearchPath $IDADIR

    # wrap executables
    for bb in ida assistant hvui; do
      wrapProgram $IDADIR/$bb \
        --prefix QT_PLUGIN_PATH : $IDADIR/plugins/platforms
    done

    # expose executables
    for bb in ida assistant idat hvui; do
      ln -s $IDADIR/$bb $out/bin/$bb
    done

    # runtimeDependencies don't get added to non-executables, and openssl is needed
    #  for cloud decompilation
    patchelf --add-needed libcrypto.so $IDADIR/libida.so
    patchelf --add-needed libcrypto.so $IDADIR/libida32.so

    runHook postInstall
  '';

  meta = with lib; {
    description = "The world's smartest and most feature-full disassembler";
    homepage = "https://hex-rays.com/ida-pro/";
    changelog = "https://hex-rays.com/products/ida/news/";
    license = licenses.unfree;
    mainProgram = "ida64";
    maintainers = [ "misaka18931" ];
    platforms = [ "x86_64-linux" ]; # Right now, the installation script only supports Linux.
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
