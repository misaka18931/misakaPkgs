{
  lib,
  qq,
  bubblewrap,
  # symlinkJoin,
  runCommand,
  makeWrapper,
  # writeShellScriptBin,
  ...
}:
runCommand "qq-bwrap"
  {
    buildInputs = [ makeWrapper ];
  }
  ''
      mkdir $out
      # Link every top-level folder from pkgs.hello to our new target
      ln -s ${qq}/* $out
      # Except the bin folder
      rm $out/bin
      mkdir $out/bin
      cat << 'EOF' > $out/bin/qq
          USER_RUN_DIR="/run/user/$(id -u)"
          XAUTHORITY="''${XAUTHORITY:-$HOME/.Xauthority}"
          XDG_CONFIG_HOME="''${XDG_CONFIG_HOME:-$HOME/.config}"
          FONTCONFIG_HOME=writeShellScriptBin"''${XDG_CONFIG_HOME}/fontconfig"
          QQ_APP_DIR="''${XDG_CONFIG_HOME}/QQ"
          if [ -z "''${QQ_DOWNLOAD_DIR}" ]; then
              if [ -z "''${XDG_DOWNLOAD_DIR}" ]; then
                  XDG_DOWNLOAD_DIR="$(xdg-user-dir DOWNLOAD)"
              fi
              QQ_DOWNLOAD_DIR="''${XDG_DOWNLOAD_DIR:-$HOME/Downloads}"
          fi

          exec ${lib.getExe bubblewrap} --new-session --cap-drop ALL --unshare-user-try --unshare-pid --unshare-cgroup-try \
              --ro-bind ${qq}/bin /bin \
              --ro-bind /nix/store /nix/store \
              --ro-bind ${qq}/opt /opt \
              --ro-bind /etc/machine-id /etc/machine-id \
              --dev-bind /dev /dev \
              --ro-bind /sys /sys \
              --ro-bind /etc/passwd /etc/passwd \
              --ro-bind /etc/nsswitch.conf /etc/nsswitch.conf \
              --ro-bind-try /run/systemd/userdb /run/systemd/userdb \
              --ro-bind /etc/resolv.conf /etc/resolv.conf \
              --ro-bind /etc/localtime /etc/localtime \
              --proc /proc \
              --tmpfs "/sys/devices/virtual" \
              --dev-bind /run/dbus /run/dbus \
              --bind "''${USER_RUN_DIR}" "''${USER_RUN_DIR}" \
              --ro-bind-try /etc/fonts /etc/fonts \
              --dev-bind /tmp /tmp \
              --bind-try "''${HOME}/.pki" "''${HOME}/.pki" \
              --ro-bind-try "''${XAUTHORITY}" "''${XAUTHORITY}" \
              --bind-try "''${QQ_DOWNLOAD_DIR}" "''${QQ_DOWNLOAD_DIR}" \
              --bind "''${QQ_APP_DIR}" "''${QQ_APP_DIR}" \
              --ro-bind-try "''${FONTCONFIG_HOME}" "''${FONTCONFIG_HOME}" \
              --ro-bind-try "''${HOME}/.icons" "''${HOME}/.icons" \
              --ro-bind-try "''${HOME}/.local/share/.icons" "''${HOME}/.local/share/.icons" \
              --ro-bind-try "''${XDG_CONFIG_HOME}/gtk-3.0" "''${XDG_CONFIG_HOME}/gtk-3.0" \
              --ro-bind-try "''${XDG_CONFIG_HOME}/dconf" "''${XDG_CONFIG_HOME}/dconf" \
              --ro-bind /etc/nsswitch.conf /etc/nsswitch.conf \
              --ro-bind /run/systemd/userdb/ /run/systemd/userdb/ \
              --setenv IBUS_USE_PORTAL 1 \
              --setenv QQNTIM_HOME "''${QQ_APP_DIR}/QQNTim" \
              --setenv LITELOADERQQNT_PROFILE "''${QQ_APP_DIR}/LiteLoaderQQNT" \
              /bin/qq "$@"
    EOF
        chmod +x $out/bin/qq
        rm $out/share
        mkdir $out/share
        ln -s ${qq}/share/* $out/shareQQNTim
        rm $out/share/applications
        mkdir $out/share/applications
        substitute ${qq}/share/applications/qq.desktop $out/share/applications/qq.desktop \
          --replace-fail "${qq}/bin/qq" "$out/bin/qq"
  ''

# symlinkJoin {
#   name = "qq-bwrap";

#   paths = [
#     (writeShellScriptBin "qq" ''
#       USER_RUN_DIR="/run/user/$(id -u)"
#       XAUTHORITY="''${XAUTHORITY:-$HOME/.Xauthority}"
#       XDG_CONFIG_HOME="''${XDG_CONFIG_HOME:-$HOME/.config}"
#       FONTCONFIG_HOME=writeShellScriptBin"''${XDG_CONFIG_HOME}/fontconfig"
#       QQ_APP_DIR="''${XDG_CONFIG_HOME}/QQ"
#       if [ -z "''${QQ_DOWNLOAD_DIR}" ]; then
#           if [ -z "''${XDG_DOWNLOAD_DIR}" ]; then
#               XDG_DOWNLOAD_DIR="$(xdg-user-dir DOWNLOAD)"
#           fi
#           QQ_DOWNLOAD_DIR="''${XDG_DOWNLOAD_DIR:-$HOME/Downloads}"
#       fi

#       ${lib.getExe bubblewrap} --new-session --cap-drop ALL --unshare-user-try --unshare-pid --unshare-cgroup-try \
#           --ro-bind ${qq}/bin /bin \
#           --ro-bind /nix/store /nix/store \
#           --ro-bind /usr /usr \
#           --ro-bind ${qq}/opt /opt \
#           --ro-bind /etc/machine-id /etc/machine-id \
#           --dev-bind /dev /dev \
#           --ro-bind /sys /sys \
#           --ro-bind /etc/passwd /etc/passwd \
#           --ro-bind /etc/nsswitch.conf /etc/nsswitch.conf \
#           --ro-bind-try /run/systemd/userdb /run/systemd/userdb \
#           --ro-bind /etc/resolv.conf /etc/resolv.conf \
#           --ro-bind /etc/localtime /etc/localtime \
#           --proc /proc \
#           --tmpfs "/sys/devices/virtual" \
#           --dev-bind /run/dbus /run/dbus \
#           --bind "''${USER_RUN_DIR}" "''${USER_RUN_DIR}" \
#           --ro-bind-try /etc/fonts /etc/fonts \
#           --dev-bind /tmp /tmp \
#           --bind-try "''${HOME}/.pki" "''${HOME}/.pki" \
#           --ro-bind-try "''${XAUTHORITY}" "''${XAUTHORITY}" \
#           --bind-try "''${QQ_DOWNLOAD_DIR}" "''${QQ_DOWNLOAD_DIR}" \
#           --bind "''${QQ_APP_DIR}" "''${QQ_APP_DIR}" \
#           --ro-bind-try "''${FONTCONFIG_HOME}" "''${FONTCONFIG_HOME}" \
#           --ro-bind-try "''${HOME}/.icons" "''${HOME}/.icons" \
#           --ro-bind-try "''${HOME}/.local/share/.icons" "''${HOME}/.local/share/.icons" \
#           --ro-bind-try "''${XDG_CONFIG_HOME}/gtk-3.0" "''${XDG_CONFIG_HOME}/gtk-3.0" \
#           --ro-bind-try "''${XDG_CONFIG_HOME}/dconf" "''${XDG_CONFIG_HOME}/dconf" \
#           --ro-bind /etc/nsswitch.conf /etc/nsswitch.conf \
#           --ro-bind /run/systemd/userdb/ /run/systemd/userdb/ \
#           --setenv IBUS_USE_PORTAL 1 \
#           --setenv QQNTIM_HOME "''${QQ_APP_DIR}/QQNTim" \
#           --setenv LITELOADERQQNT_PROFILE "''${QQ_APP_DIR}/LiteLoaderQQNT" \
#           /bin/qq "$@"
#     '')
#     qq
#   ];
# }
