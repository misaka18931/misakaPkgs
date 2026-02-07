#!/usr/bin/env nix
#! nix shell nixpkgs#nix-prefetch-github nixpkgs#nix-prefetch-scripts nixpkgs#parallel nixpkgs#jq nixpkgs#curl nixpkgs#coreutils --command bash

# Usage: generate-repo.sh url/to/listing name

curl -sL -o - "$1" | jq -c ".[]" | parallel -j 32 --pipe --will-cite \
 'while read -r PLUGIN_JSON; do
    echo $PLUGIN_JSON | jq --arg sha256 \
                   "$(nix-prefetch-url 2>/dev/null \
                                       --type sha256 $(echo $PLUGIN_JSON | jq -r ".packageUrl" ))" \
                   ". + {sha256: \$sha256}"
  done' \
  | jq -s "." > "$2"
