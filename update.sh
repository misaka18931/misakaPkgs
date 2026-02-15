#!/usr/bin/env nix
#! nix shell nixpkgs#nix-update --command bash

# pythonPackages
for path in pythonPackages/*; do
            package=$(basename $path .nix)
            [ "$package" = default ] && continue

            case $package in
                pylingual|qiling)
                    version=branch=dev
                    ;;
                xdis-git)
                    version=branch
                    ;;
            esac
            if [ -n "$version" ]; then
                version=--version=$version
            fi
            nix-update python3Packages.$package \
                       --flake \
                       --build \
                       --commit \
                       --override-filename=$path \
                       $version
         done
