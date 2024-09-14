#!/bin/bash

set -e

readonly DIST_DIR=/workspace_local/dist
readonly BUILD_DIR_NAME=build
readonly zip_path="${WORKSPACE}/${BUILD_DIR_NAME}/${PROJECT_NAME}-dist.zip"

cd "$WORKSPACE"

# generate codelabs
find src -name '*.md' | xargs claat export -o "$DIST_DIR"
./tools/patch_dist.sh

# create a directory in which the zip created
mkdir -p "$BUILD_DIR_NAME"

# create list of files to add the zip
cd "$DIST_DIR"
targets=$(find . -mindepth 1 -maxdepth 1 -type f,d -print0 | xargs -0 echo)
readonly targets

# create zip file
rm -f "$zip_path"
zip -r "$zip_path" $targets
