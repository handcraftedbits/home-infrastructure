#!/bin/bash

bootstrap_url="${BUILD_ISO_BOOTSTRAP_URL}"
cache_dir="${BUILD_ISO_CACHE_DIR}"
iso="${BUILD_ISO_FILENAME}"

if [[ ! -f "/opt/container/cache/iso/${iso}" ]]
then
     echo "NixOS installation ISO ${iso} does not exist; building"

     docker run --rm -v "${cache_dir}:/output" ghcr.io/handcraftedbits/nixos-unattended-iso-builder:latest \
          --bootstrap-url "${bootstrap_url}" \
          --output-file "${iso}" \
          --system x86_64-linux
fi
