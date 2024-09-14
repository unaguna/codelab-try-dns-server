# codelab 作成環境

この devcontainer は、vscode で codelab を作成するための環境を提供します。

この環境では、保存時に自動で HTML に変換しブラウザに反映するよう各種機能の導入・設定がされています。

## 環境構築の前提条件

- docker を使用可能であること (`docker version` が正常に動作すること)
- vscode がインストールされていること
- vscode に拡張機能 [ms-vscode-remote.vscode-remote-extensionpack](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) がインストールされていること

## vscode 起動手順

1. vscode でこのディレクトリを開く
    - この段階で patch_dist.sh の実行に失敗した旨のエラーが表示されるかもしれないが、このスクリプトは以降の手順の後コンテナ内で動作していればよいので無視してよい
2. コマンドパレットを開く
    - (Windows の場合) [Ctrl] + [Shift] + [P] を入力する
3. コマンドパレットで「Dev Conteiners: Reopen in Container」をクリックする
    - 見つからない場合、パレットに「reopen in」のようにコマンドの一部を入力すると絞り込みできる
4. ウィンドウが自動で閉じてすぐにまた自動で開く
    - 初回起動時はウィンドウが閉じるまでに時間がかかる
5. 上で自動で開いたウィンドウが使用可能になる
    - 初回起動時は使用可能になるまで時間がかかる
    - ターミナルで patch_dist.sh が自動実行されるので、そのまま**閉じずに**使用すること。
        - ターミナルを使う必要があれば「+」ボタンでターミナルを追加できる。既存のターミナルを終了する必要は無い。
        - ターミナルが邪魔であれば「×」ボタンで非表示にできる。既存のターミナルを終了する必要は無い。

次回以降は、vscode のアイコンを右クリックして「(ディレクトリ名) [Dev Conttainer]」をクリックするなどでも起動できます。

## ディレクトリ構成

下記のディレクトリ構成で動作するように、自動ビルドなどを設定しています。

```plain
/   : コンテナのルートディレクトリ
|
+-- workspace
|   |   : このプロジェクトがマウントされる領域であり、
|   |     プロジェクトのワークスペース
|   |
|   +-- .devcontainer
|   |       : Dev Container + vscode の設定ファイル等
|   |
|   +-- .vscode
|   |       : vscode の設定ファイル等
|   |
|   +-- src
|   |       : codelab の元となる markdown ファイルを置く場所
|   |
|   +-- dist -> /workspace_local/dist
|           : 後述する dist ディレクトリへのシンボリックリンク
|             LiveServer で HTML を見れるようにするために、ここ（ワークスペース）にリンクを張る
|
+-- workspace_local
    |
    +-- dist
            : 生成したHTMLファイルの出力先（出力時に自動生成）
              出力後の自動修正を動作させるために、
              コンテナ外部からマウントしているワークスペース内ではなく
              ここにHTMLを出力する。
```

## 作業手順 (執筆時)

1. (初回のみ) `ln -s /workspace_local/dist dist` コマンドでシンボリックリンクを作成する
2. `./src/` ディレクトリに拡張子が `.md` のファイルを作成・編集する
    - [markdown codelab の書式](https://github.com/googlecodelabs/tools/tree/main/claat/parser/md) に沿って記述し、保存する
    - 保存時、`./dist/` ディレクトリ下に自動で HTML が生成される
3. vscode のウィンドウの右下の「Go Live」をクリックすることで、Live Server を起動する
4. Live Server を起動すると自動でブラウザが起動して Live Server のページを表示するので、HTML が生成されたディレクトリを選ぶことで、出力されたHTMLをブラウザで表示する
5. `.md` ファイルを編集して保存すると、自動でHTMLが再生成される。HTMLが再生成されるとブラウザが自動でリロードして、最新の状態をブラウザで確認できる。

## ZIP 出力

プロジェクト全体もしくは出力された codelab を ZIP ファイルとして出力することができます。

codelab を ZIP 形式で出力する場合、下記のように [enzip_dist.sh](./tools/enzip_dist.sh) を実行します。

```shell
./tools/enzip_dist.sh
```

このコマンドを実行すると `./build` ディレクトリが作成され、その中に ZIP ファイルが出力されます。

codelab 作成プロジェクト全体を ZIP 形式で出力する場合、下記のように [enzip.sh](./tools/enzip.sh) を実行します。

```shell
./tools/enzip.sh
```

このコマンドを実行すると `./build` ディレクトリが作成され、その中に ZIP ファイルが出力されます。この ZIP ファイルには生成された codelab そのもの、シンボリックリンク、build ディレクトリ、git リポジトリは含まれません。

## HTML の自動修正

claat が生成する HTML は一部に問題があるため、[patch_dist.sh](./tools/patch_dist.sh) を使用して一部を下記のように修正します。vscode 起動時にこのスクリプトのラッパー [patch_dist_watch.sh](./tools/patch_dist_watch.sh) が自動で実行されるようになっているため、下記の修正は自動で実施されます。

1. WEBサーバに配備せずファイルシステム上でも使えるようにするために以下の置換を実施する

    - 「href="//」⇒「href="http://」

2. Google Analytics を無効化するため、HTMLファイル内の `<google-codelab-analytics>...</google-codelab-analytics>` タグを取り除く

    - 次の置換により実現する: 「google-codelab-analytics」⇒「!--」

3. 左上の×ボタン (Close ボタン) や右下の Done ボタンのリンク先が `/` になってしまう (2024年7月現在) ため、下記のコードを各 HTML の `<head>...</head>` 内に記載する

    ```html
    <script>
        window.addEventListener('DOMContentLoaded', (event) => {
            document.getElementById("arrow-back").setAttribute("href", "../");
            document.getElementById("done").setAttribute("href", "../");
        });
    </script>
    ```

    MEMO: いかにもナンセンスな解決方法だが、リンク先をあらかじめ指定する方法が無いらしい (2024年7月現在)。こちらの issue も参照: <https://github.com/googlecodelabs/tools/issues/535>

4. 左下の「Report a mistake」を非表示にするために、HTML ファイルの `<style></style>` タグ内に下記のコードを記載する。

    ```css
    google-codelab #drawer .metadata {
      display: none;
    }
    ```

上述の修正が適さない場合は、適宜 [patch_dist.sh](./tools/patch_dist.sh) を改修してください。

### なぜ /workspace_local で自動修正を実施するのか

claat の出力先を /workspace_local/dist に設定しているため、出力後の自動修正もそこで実施されます。しかし、そのように設定する理由は claat の都合ではなく、自動修正の都合によるものです。

ここで自動修正を実施する理由は、/workspace はコンテナの外部の領域をマウントしている場所であり、そのような場所では inotify によるファイル監視が動作しない場合があるためです。2024年7月現在、Windows の Docker Desktop 経由でマウントした際にファイル監視が動作しないことを確認しています。

以上の理由で上述の自動修正処理は /workspace の外で実施する必要があるため、/workspace_local で実施しています。

## 自動更新の仕組み

HTMLの自動生成とブラウザの自動リロードはそれぞれ下記の拡張機能で実施しています。動作を変更したい場合は該当する設定を編集してください。

### HTML の自動生成

HTML の自動生成は、保存時に自動でコマンドを実行できるようにする拡張機能 [Run on Save](https://marketplace.visualstudio.com/items?itemName=pucelle.run-on-save) で実現しています。この拡張機能を使用することで、`./src/**/*.md` に該当するファイルを保存した際に HTML 生成コマンドである `claat export` が自動で実行されるようにしています。

Run on Save は単に任意のコマンドを保存時に実行するだけの拡張機能です。そのため、HTML生成のパラメータは `claat export` 実行時の引数として指定します。

また、出力されたファイルは、vscode 起動時に自動で実行されている [patch_dist.sh](./tools/patch_dist.sh) の働きで一部修正されます。

### ブラウザの自動更新

ブラウザの自動更新には拡張機能 [Live Server](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer) を使用しています。この拡張機能を使用すると、静的にファイルを提供するWEBサーバが立ち上がり、それをブラウザで開くことで HTML ファイルを閲覧できます。Live Server が提供する HTML ファイルを開いているとき、vscode でファイルが更新されるとブラウザが自動で更新されます。
