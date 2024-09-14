#!/bin/bash

cd /workspace_local/dist

# 左上の×ボタン (Close ボタン) のリンク先
URL_CLOSE='../'
# 右下の Done ボタンのリンク先
URL_DONE='../'

# 追加する <script> タグ
script_tag=`tr -d '\n' <<EOF
<script>
    window.addEventListener('DOMContentLoaded', (event) => {
        document.getElementById("arrow-back")?.setAttribute("href", "${URL_CLOSE}");
        document.getElementById("done")?.setAttribute("href", "${URL_DONE}");
    });
</script>
EOF
`

# <style> タグ内に追加するスタイル指定
style_part=`tr -d '\n' <<EOF
google-codelab #drawer .metadata {
  display: none;
}
EOF
`

file_list=($@)
if [ ${#file_list[@]} -eq 0 ]; then
    file_list=`find . -name '*.html'`
fi

# ディレクトリ内の\ファイルの変更を監視し、変更があった場合に文字列置換を実行
# CAUTION: この変換は何度も実施されることがあるので、冪等になるように注意して作成すること。

echo "${file_list[@]}" | while read -r FILE; do
    if [[ "$FILE" == *.html ]]; then
        sed -i \
            -e "s|^</head>|${script_tag}</head>|" \
            -e 's|href="//|href="http://|g' \
            -e "s| </style>|${style_part}</style>|" \
            -e "s/google-codelab-analytics/!--/g" \
            "$FILE"
        echo "$(date --iso=seconds) Replaced in $FILE"
    fi
done
