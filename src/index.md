author: KOIZUMI Yusuke
summary: 仮想マシン上でDNSサーバを立ち上げて、LAN内向けに名前解決を提供します
id: try-dns-server
categories: named
environments: Web
status: Publish
Feedback Link: /


# 自宅 DNS サーバの立ち上げとレコード登録

## はじめに
Duration: 0:05:00

このハンズオンでは、次の手順で DNS サーバを構築します。

1. Oracle VirtualBox の仮想マシンに Almalinux (CentOS の後継) をインストールします。
2. named を設定して DNS サーバとして利用可能にします。
3. 特定のドメインについての名前解決を提供します。
