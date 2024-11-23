#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT=$(realpath "${SCRIPT_DIR}/..")

# shellcheck source=./lib/colours.sh
source "$SCRIPT_DIR/lib/colours.sh"

LIBUSB_DIR="${ROOT}/src/libusb"
WUGA_DIR="${ROOT}/src/wii-u-gc-adapter"
LIB_OUT_DIR="${LIBUSB_DIR}/out"
WUGA_OUT_DIR="${ROOT}/"

rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

echo -e "${Blu}Building libusb${RCol}"
cd "$LIBUSB_DIR" || exit
./autogen.sh && \
  ./configure --prefix="$LIB_OUT_DIR" && \
  make && \
  make install \
  || exit

echo -e "${Gre}Successfully built libusb${RCol}"

echo -e "${Blu}Building wii-u-gc-adapter${RCol}"
cd "$WUGA_DIR" || exit
# builiding object files
echo -e "${Yel}Compiling object files${RCol}"
# shellcheck disable=SC2046
gcc -c -o wii-u-gc-adapter.o wii-u-gc-adapter.c \
  -Wall -Wextra -pedantic -Wno-format -std=c99 \
  $(pkg-config --cflags udev) \
  "-I${LIB_OUT_DIR}/libusb/include/libusb-1.0" \
  || exit
# linking
echo -e "${Yel}Linking${RCol}"
gcc -o "${WUGA_OUT_DIR}/wii-u-gc-adapter" wii-u-gc-adapter.o \
  "${LIB_OUT_DIR}/lib/libusb-1.0.a" \
  -lpthread -ludev \
  || exit

echo -e "${Gre}Successfully built wii-u-gc-adapter${RCol}"