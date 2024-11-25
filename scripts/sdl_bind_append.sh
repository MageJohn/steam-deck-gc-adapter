#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT=$(realpath "$SCRIPT_DIR/..")

# shellcheck source=./lib/colours.sh
source "$SCRIPT_DIR/lib/colours.sh"

TOOL_DIR="$ROOT/tools"
BINDS_FILE="$ROOT/etc/gamepad_binds.txt"
STEAM_CONFIG="$HOME/.local/share/Steam/config/config.vdf"

manual_instructions() {
  echo -e "Could not configure the bindings for GameCube controllers."
  echo -e "You can manually configure the bindings by plugging in the"
  echo -e "controller and selecting \"Begin Test\" in Steam's controller settings"
}

cd "$TOOL_DIR" || exit

if ! which python > /dev/null; then
  echo -e "${Red}python could not be found${RCol}\n"
  manual_instructions
  exit 1
fi

if [[ ! -f "$STEAM_CONFIG" ]]; then
  echo -e "${Red}File $STEAM_CONFIG does not exist${RCol}\n"
  manual_instructions
  exit 1
fi

if [[ ! -f venv/bin/activate ]]; then
  python -m venv venv
fi

# can't check this source, but it won't affect variables so it's fine
# shellcheck disable=SC1091
source "venv/bin/activate"

pip install -r requirements.txt --find-links=wheels/

python sdl_bind_append.py "$STEAM_CONFIG" "$BINDS_FILE"
