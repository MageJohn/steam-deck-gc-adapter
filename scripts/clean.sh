#!/bin/bash

git submodule foreach git clean -xf

echo "Removing out/"
rm -rf out
