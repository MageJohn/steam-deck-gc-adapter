#!/bin/bash

git submodule foreach git clean -xf
git clean -f
