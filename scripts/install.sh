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

echo -e "${Gre}Success!${RCol}

${URed}Now setup controller inputs${RCol}
1. To do this, first copy all of the following line:

0300788f7e0500003703000000000000,Wii U GameCube Adapter,platform:Linux,a:b0,x:b3,b:b1,y:b2,dpleft:b10,dpright:b11,dpup:b8,dpdown:b9,leftx:a0,lefty:a1,rightx:a3,righty:a4,lefttrigger:a2,rightshoulder:b6,righttrigger:a5,start:b7,steam:2,hint:!SDL_GAMECONTROLLER_USE_GAMECUBE_LABELS:=1,

2. Now open Steam in Desktop mode.
3. Go to the top left Steam menu and open Settings.
4. Select the Controller section.
5. Make sure a GameCube controller is plugged in and selected.
6. In the line Test Device Inputs, select Begin Test.
7. In the tester you should see that the buttons are not correctly mapped.
8. Click Setup Device Inputs.
9. Click Paste from Clipboard.
10. The controller should now be correctly mapped."
