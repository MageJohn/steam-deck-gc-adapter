#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT=$(realpath "${SCRIPT_DIR}/..")

# shellcheck source=./lib/colours.sh
source "$SCRIPT_DIR/lib/colours.sh"

PROJECT_NAME=steam-deck-gc-adapter
TAR_PATH="${ROOT}/${PROJECT_NAME}.tar.gz"
PKG_PARENT="${ROOT}/pkg"
PKG_DIR="${PKG_PARENT}/${PROJECT_NAME}"
BIN_PATH="${ROOT}/wii-u-gc-adapter"

if [[ ! -f "$BIN_PATH" ]]; then
  echo -e "${Red}wii-u-gc-adapter has not been built${RCol}"
  echo -e "Run ./scripts/build.sh before running this script again"
  exit 1
fi

rm -rf "$PKG_PARENT"
mkdir -p "$PKG_DIR"

install -Dvm 0664 "$ROOT"/etc/* -t "${PKG_DIR}/etc"
install -svm 0755 "$BIN_PATH" "$PKG_DIR"
install -Dvm 0664 "${ROOT}/scripts/lib/colours.sh" -t "${PKG_DIR}/scripts/lib"
install -Dvm 0755 "${ROOT}/scripts/install.sh" -t "${PKG_DIR}/scripts"

echo -e "Compressing package ${TAR_PATH}"
tar -C "${PKG_PARENT}" -caf "${TAR_PATH}" "${PROJECT_NAME}/" \
  || exit 1
