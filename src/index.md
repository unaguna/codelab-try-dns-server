author: KOIZUMI Yusuke
summary: CodeLabの解説用
id: docker-run-one-container
categories: docker
environments: Web
status: Publish
Feedback Link: /


# Docker コンテナの起動と設定

## はじめに
Duration: 0:05:00

Docker では「コンテナ」を作成し起動し、それを仮想環境として利用します。

このハンズオンでは、インターネット上で公開されている「イメージ」をもとにしてコンテナを作成・起動するための最も単純なコマンドからスタートします。その後、コマンドを修正したり Docker Compose を使用したりすることで、既存のコンテナをより活用できるようにします。

### 前提条件

- インターネットに接続されていること。とくにプロキシ経由での接続が不要であること

    - プロキシ経由でしかインターネットに接続できない場合、docker がプロキシを使用するように設定する必要があります。設定の方法は docker のセットアップの方法によって変わります。

- docker と docker compose が使用可能であること。

    下記のコマンドで確かめられます。

    ```shell
    # 正常であれば、クライアントとサーバの状態が表示される
    docker version
    # 正常であれば、docker compose のバージョンが表示される
    docker compose version

    # インストールの方法によっては、docker compose version ではなくこちらで動作するかも
    # その場合、以降の説明の `docker compose` は適宜 `docker-compose` に読み替えること
    docker-compose version
    ```

## Hello World
Duration: 0:15:00

コンテナはイメージをもとにして作成します。

まずは、動作確認にも使われるシンプルなイメージ hello-world を使用してコンテナを作成・起動してみましょう。

### コンテナの作成・起動

次のコマンドを実行することで、イメージをもとにコンテナを作成して実行することができます。実際に試してみましょう。

```shell
docker run hello-world
```

初回はイメージのダウンロードから始まるので時間がかかります。待ちましょう。

次のような書き出しで docker を説明する文章が表示されたら成功です。

```console
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

<aside class="negative">
イメージのダウンロードに失敗する旨のエラーが出ている場合、docker がインターネットに接続できていない可能性があります。

この問題が発生する場合、コンピュータがインターネットに接続されていること、（必要であれば）docker がプロキシを使うよう設定されていることを確認してください。
</aside>

### 作成したコンテナの確認

このイメージはデフォルトでは文章を出力して終了するように作られているため、作成・起動したコンテナは文章を出力したら停止します。実際に、先ほど作成・起動したコンテナが停止していることを確認してみましょう。

次のコマンドを実行することでコンテナの一覧を見ることができます。実行してみましょう。

```shell
docker ps -a
```

下記のように、コンテナの一覧が表示されるはずです。

```console
CONTAINER ID   IMAGE         COMMAND    CREATED         STATUS                     PORTS   NAMES
8dd5077d0ae1   hello-world   "/hello"   1 minutes ago   Exited (0) 1 minutes ago           unruffled_nobel
```

もしかしたら複数のコンテナの情報が表示されるかもしれません。その場合でも、IMAGE の列にはもとにしたイメージが、CREATED には作成したタイミングが記載されているので、どれが先ほど作成したコンテナかはわかるでしょう。

<aside class="positive">
ここでは IMAGE と CREATED をもとにコンテナを同定しましたが、`docker run` の実行時にコンテナ名を指定しておけば NAMES (コンテナ名) で同定することができます。
</aside>

STATUS に「Exited」と書かれている通り、このコンテナは停止しています。

### コンテナの削除