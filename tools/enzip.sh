#!/bin/bash

set -e

readonly BUILD_DIR_NAME=build
readonly zip_path="${WORKSPACE}/${BUILD_DIR_NAME}/${PROJECT_NAME}.zip"

cd "$WORKSPACE"

# create a directory in which the zip created
mkdir -p "$BUILD_DIR_NAME"

# create list of files to add the zip
targets=$(find . -mindepth 1 -maxdepth 1 -type f,d ! -name "$BUILD_DIR_NAME" ! -name .git -print0 | xargs -0 echo)
readonly targets

# create zip file
rm -f "$zip_path"
zip -r "$zip_path" $targets
