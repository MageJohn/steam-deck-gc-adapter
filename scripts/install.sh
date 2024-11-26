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

echo -e "${Blu}Installing udev rule (requires superuser)${RCol}"
# pkexec is similar to sudo, but can skip the password if the user doesn't have
# one set, and will show a graphical password prompt. It also accepts a script
# on standard input, which we use here.
pkexec <<EOF
  install -Dvm 0664 "$ROOT/etc/51-gcadapter.rules" -t /etc/udev/rules.d/
  udevadm control --reload-rules
EOF

if [[ $? == 126 || $? == 127 ]]; then
  echo -e "${Red}Could not acquire super user privileges. Aborting${RCol}"
  exit 1
fi

if [[ -z "$XDG_CONFIG_HOME" ]]; then
  XDG_CONFIG_HOME="$HOME/.config"
fi

echo -e "${Blu}Installing systemd unit${RCol}"
install -Dvm 0664 "$ROOT/etc/wii-u-gc-adapter.service" -t "$XDG_CONFIG_HOME/systemd/user"
echo -e "${Blu}Installing wii-u-gc-adapter executable${RCol}"
install -Dvm 0755 "$ROOT/wii-u-gc-adapter" -t "$HOME/.local/bin"

echo -e "${Blu}Configuring GameCube controller bindings${RCol}"
"$SCRIPT_DIR"/sdl_bind_append.sh

echo -e "${Blu}Enabling systemd unit${RCol}"
systemctl enable --user --now wii-u-gc-adapter.service || exit 1

echo -e "${Gre}Success!${RCol}"
