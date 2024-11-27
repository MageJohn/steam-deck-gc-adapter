#!/bin/bash

set -o errexit

on_exit(){
  echo "Something went wrong. Aborting installation"
}

trap on_exit EXIT

# This line is kept up to date by prepare-release.sh
VERSION=v0.0.1

cd /tmp
echo "Downloading package to /tmp"
if ! curl -#LO "https://github.com/MageJohn/steam-deck-gc-adapter/releases/download/$VERSION/steam-deck-gc-adapter.tar.gz"; then
  echo "Could not download package. Are you connected to the internet?"
  exit 1
fi
tar -xaf steam-deck-gc-adapter.tar.gz

echo "Package downloaded and extracted."

cd steam-deck-gc-adapter
exec ./scripts/install.sh
