#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT=$(realpath "${SCRIPT_DIR}/..")

# shellcheck source=./lib/colours.sh
source "$SCRIPT_DIR/lib/colours.sh"

cd "${ROOT}" || exit

PROJECT_NAME=steam-deck-gc-adapter
TAR_NAME="${PROJECT_NAME}.tar.gz"
DIST_DIR="dist"
ETC_DIR="etc"
BIN_PATH="out/wii-u-gc-adapter"

if [[ ! -f "$BIN_PATH" ]]; then
  echo -e "${Red}wii-u-gc-adapter has not been built${RCol}"
  echo -e "Run ./scripts/build.sh before running this script again"
  exit 1
fi

rm -rf "$DIST_DIR"
mkdir -p "${DIST_DIR}/${PROJECT_NAME}"

cp "${ETC_DIR}"/* "${BIN_PATH}" "${DIST_DIR}/${PROJECT_NAME}"

tar -C "${DIST_DIR}" -caf "${TAR_NAME}" "${PROJECT_NAME}/"
