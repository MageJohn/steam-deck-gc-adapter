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

while true; do
  # shellcheck disable=SC2162
  read -p "Do you wish to inspect the files before installing? [y/N]: " yn
  case $yn in
    [Yy]*)
      xdg-open steam-deck-gc-adapter 2> /dev/null
      # shellcheck disable=SC2162
      read -p "Hit enter to continue"
      break
    ;;
    "") ;&
    [Nn]*)
      # just continue
      break
    ;;
  esac
done


cd steam-deck-gc-adapter || exit 1
exec ./scripts/install.sh
