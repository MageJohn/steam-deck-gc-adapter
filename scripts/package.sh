#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT=$(realpath "${SCRIPT_DIR}/..")

# shellcheck source=./lib/colours.sh
source "$SCRIPT_DIR/lib/colours.sh"

PROJECT_NAME=steam-deck-gc-adapter
TAR_PATH="${ROOT}/${PROJECT_NAME}.tar.gz"
PKG_DIR="${ROOT}/pkg"
BIN_PATH="${ROOT}/wii-u-gc-adapter"
TOOLS_PATH="${ROOT}/tools"

if [[ ! -f "$BIN_PATH" ]]; then
  echo -e "${Red}wii-u-gc-adapter has not been built${RCol}"
  echo -e "Run ./scripts/build.sh before running this script again"
  exit 1
fi

rm -rf "$PKG_DIR"
mkdir -p "${PKG_DIR}/${PROJECT_NAME}"

cp -r etc "${BIN_PATH}" "${PKG_DIR}/${PROJECT_NAME}"

mkdir -p "${PKG_DIR}/${PROJECT_NAME}/tools"
cp "${TOOLS_PATH}/sdl_bind_append.py" "${TOOLS_PATH}/requirements.txt" \
  "${PKG_DIR}/${PROJECT_NAME}/tools"

tar -C "${PKG_DIR}" -caf "${TAR_PATH}" "${PROJECT_NAME}/"
