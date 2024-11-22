#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=./lib/colours.sh
source "$SCRIPT_DIR/lib/colours.sh"

LIBUSB_DIR=$(realpath "$SCRIPT_DIR/../libusb")
WUGA_DIR=$(realpath "$SCRIPT_DIR/../wii-u-gc-adapter")
OUT_DIR=$(realpath "$SCRIPT_DIR/../out")

rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

echo -e "${Blu}Building libusb${RCol}"
cd "$LIBUSB_DIR" || exit
./autogen.sh && \
  ./configure --prefix="$OUT_DIR/libusb" && \
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
  "-I${OUT_DIR}/libusb/include/libusb-1.0" \
  || exit
# linking
echo -e "${Yel}Linking${RCol}"
gcc -o "$OUT_DIR/wii-u-gc-adapter" wii-u-gc-adapter.o \
  "$OUT_DIR/libusb/lib/libusb-1.0.a" \
  -lpthread -ludev \
  || exit

echo -e "${Gre}Successfully built wii-u-gc-adapter${RCol}"