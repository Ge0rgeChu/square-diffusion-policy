#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
dest=data/robomimic/datasets/square/ph/image.hdf5
if [[ -f "$dest" ]] && sha256sum --check data.sha256; then exit 0; fi
mkdir -p "$(dirname "$dest")"
tmp=$(mktemp -d "$(dirname "$dest")/download.XXXXXXXX")
trap 'rm -f -- "$tmp"/part-* "$tmp/image.hdf5"; rmdir -- "$tmp"' EXIT
base=https://github.com/Ge0rgeChu/square-diffusion-policy/releases/download/experiments-v1
for part in 00 01; do
    curl --fail --location --retry 3 "$base/square-image.hdf5.part-$part" -o "$tmp/part-$part"
done
cat "$tmp/part-00" "$tmp/part-01" > "$tmp/image.hdf5"
printf '%s  %s\n' "$(cut -d' ' -f1 data.sha256)" "$tmp/image.hdf5" | sha256sum --check
mv -- "$tmp/image.hdf5" "$dest"
