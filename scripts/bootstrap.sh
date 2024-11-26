#!/bin/bash

on_exit(){
  echo "Something went wrong. Aborting installation"
}

trap on_exit EXIT

cd /tmp || exit 1
echo "Downloading package to /tmp"
if ! curl -#LO https://github.com/MageJohn/steam-deck-gc-adapter/releases/download/v0.0.0/steam-deck-gc-adapter.tar.gz; then
  echo "Could not download package. Are you connected to the internet?"
  exit 1
fi
tar -xaf steam-deck-gc-adapter.tar.gz || exit 1

echo "Package downloaded and extracted."

cd steam-deck-gc-adapter || exit 1
exec ./scripts/install.sh
