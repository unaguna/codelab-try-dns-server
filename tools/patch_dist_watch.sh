#!/bin/bash

# 監視対象のディレクトリ
DIR_TO_WATCH=${DIST_DIR:-"/workspace_local/dist"}

SCRIPT_DIR=$(cd $(dirname $0); pwd)

# ディレクトリ内の\ファイルの変更を監視し、変更があった場合に文字列置換を実行
# CAUTION: この変換は何度も実施されることがあるので、冪等になるように注意して作成すること。

inotifywait -m -e modify --format '%w%f' -r "$DIR_TO_WATCH" | while read -r FILE; do
    if [[ "$FILE" == "$DIR_TO_WATCH/"*"/index.html" ]]; then
        "$SCRIPT_DIR/patch_dist.sh" "$FILE"
    fi
    if [[ "$FILE" == */codelab.json ]]; then
        "$SCRIPT_DIR/make_index.go"
    fi
done
