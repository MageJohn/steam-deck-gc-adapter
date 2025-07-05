#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT=$(realpath "$SCRIPT_DIR/..")

# shellcheck source=./lib/colours.sh
source "$SCRIPT_DIR/lib/colours.sh"

if [[ ! -x "$ROOT/wii-u-gc-adapter" ]]; then
  echo -e "${Red}wii-u-gc-adapter binary not found${RCol}"
  echo
  echo -e "This script should be run from the release archive,"
  echo -e "or after building the wii-u-gc-adapter binary."
  exit 1
fi

if [[ -z "$XDG_CONFIG_HOME" ]]; then
  XDG_CONFIG_HOME="$HOME/.config"
fi

echo -e "${Blu}Installing systemd unit${RCol}"
install -Dvm 0664 "$ROOT/etc/wii-u-gc-adapter.service" -t "$XDG_CONFIG_HOME/systemd/user"
install -Dvm 0664 "$ROOT/etc/wii-u-gc-adapter.target" -t "$XDG_CONFIG_HOME/systemd/user"
echo -e "${Blu}Installing wii-u-gc-adapter executable${RCol}"
install -Dvm 0755 "$ROOT/wii-u-gc-adapter" -t "$HOME/.local/bin"

echo -e "${Blu}Enabling systemd unit${RCol}"
systemctl enable --user wii-u-gc-adapter.timer || exit 1
systemctl start --user wii-u-gc-adapter.service || exit 1

echo -e "${Gre}Success!${RCol}"
