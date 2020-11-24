#!/usr/bin/env bash
set -euo pipefail

## Usage: Symlink onto $PATH, then run from the root of your server modpack
#
# This script will pack up all relevant files from the modpack, so that you can
# send your friends the .tar.xz file with your modifications.
#
# On Windows, this file can be unpacked with 7zip, for example.

fname="modpack.tar.xz"

[[ -e $fname ]] && rm -f "$fname"
tar cvJf "$fname" mods config scripts
