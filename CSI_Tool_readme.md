# 概要

## 概要

このWebページでは、当社の802.11n測定と実験プラットフォームを使用するための命令が含まれています。CSIツールは、カスタム修正ファームウェアおよびオープンソースのLinuxワイヤレスドライバーを使用して、インテルのWi-Fiワイヤレスリンク5300の802.11n MIMO無線上に構築されています。我々は、すべてのソフトウェアとの実験を実行するために、チャネル測定値を読み、解析するために必要なスクリプトが含まれています。

IWL5300は40 MHzで4で20 MHzまたは1で、すべての2サブキャリアに対して約1グループである30サブキャリアグループ、のチャネル行列をレポート形式での802.11nチャネル状態情報を提供します。各チャネル行列のエントリは、実部と虚部のための符号付き8ビット分解能それぞれに、複素数です。これは、単一の送受信アンテナ対の間の信号経路の利得及び位相を特定します。

以下に私たちのツールのリリース声明により多くの情報があります。

## 出版

ParCast：MIMO-OFDM無線LANでのソフト動画配信
ACMモビコム2012。
ツールリリース：802.11n対応を収集するチャネル状態情報とトレース
ACM SIGCOMMコンピュータコミュニケーションレビュー（CCR）、2011年1月。
無線チャネルの測定値から予測可能な802.11パケット配信
ACMのSIGCOMM2010。
Demystifing802.11nの消費電力
USENIX HotPower2010。
IEEE802.11nのチャネルモデルのドプラ成分の調査
IEEEのGLOBECOM - 2010ワイヤレス通信。
ダミーのための複数のアンテナを持つ802.11
ACM SIGCOMMコンピュータコミュニケーションレビュー（CCR）、2010年1月。
802.11n対応の測定に関する研究：2つのアンテナよりも優れています
未発表の技術報告書、ワシントン、2009年の大学。

## ユーザー

省略

# インストール手順

これらの命令は、現在3.2（例えばUbuntuの12.04）と4.2（例えば、Ubuntuの14.04.4）との間で、上流のLinuxカーネルのバージョンに基づいているLinuxオペレーティングシステム上で動作することが期待されます。

ワシントン大学の本来のテストベッドで使用されるこのページの古いバージョンは、ここにアーカイブされます。

## 1.前提条件

ビルドツール、Linux開発ヘッダー、およびGitのクライアントをインストールします。Ubuntuでは、実行します。

```
sudo apt-get install gcc make linux-headers-$(uname -r) git-core
```

ヒント：あなたの実験中に、無線インターフェースをより細かく制御状態を維持するために、あなたはおそらく、このようなIWとiproute2のようにコマンドラインユーティリティを使用して構成することになるでしょう。もしそうなら、あなたは最初に（それがインストールされている場合）は、無線インターフェースを制御からのNetworkManagerを無効にする必要があります。Ubuntuでは、実行します。

```
sudo apt-get install iw
echo iface wlan0 inet manual | sudo tee -a /etc/network/interfaces
sudo restart network-manager
```

ヒント：あなたは自動的に（あなたがドライバに独自の変更を開発している場合は特に）、実行起動時にロードするから無線ドライバを防止したい場合：

```
echo blacklist iwldvm | sudo tee -a /etc/modprobe.d/csitool.conf
echo blacklist iwlwifi | sudo tee -a /etc/modprobe.d/csitool.conf
```

## 2.ビルドし、変更されたワイヤレスドライバをインストールします。

無線ドライバの修正を含むCSIツール、Linuxのソースツリーを、入手し、あなたの上流のカーネルバージョンのリポジトリに適切なタグをチェックアウト：

```
CSITOOL_KERNEL_TAG=csitool-$(uname -r | cut -d . -f 1-2)
git clone https://github.com/dhalperi/linux-80211n-csitool.git
cd linux-80211n-csitool
git checkout ${CSITOOL_KERNEL_TAG}
```

ヒント：あなたはその後、互換性を向上させるために、あなたのディストリビューションが提供するカーネルのバージョンのLinuxのソースツリーに、これらのドライバの変更をマージすることができます。Ubuntuでは、実行します。

```
UBUNTU_KERNEL_TAG=Ubuntu-3.13.0-32.57
# Modify the line above with your Ubuntu kernel tag. First, determine your full kernel
# version by reading /proc/version_signature; then, look up the Ubuntu kernel tag at:
# http://people.canonical.com/~kernel/info/kernel-version-map.html

. /etc/lsb-release
git remote add ubuntu git://kernel.ubuntu.com/ubuntu/ubuntu-${DISTRIB_CODENAME}.git
git pull --no-edit ubuntu ${UBUNTU_KERNEL_TAG}
```

既存のカーネルの変更されたドライバをビルドします。

```
make -C /lib/modules/$(uname -r)/build M=$(pwd)/drivers/net/wireless/iwlwifi modules
```

モジュールのアップデートディレクトリに変更されたドライバをインストールします。

```
sudo make -C /lib/modules/$(uname -r)/build M=$(pwd)/drivers/net/wireless/iwlwifi INSTALL_MOD_DIR=updates modules_install
sudo depmod
cd ..
```

ヒント：メッセージ「秘密鍵を読み取ることができません"が表示される場合は、モジュールに署名することができませんでした。カーネルモジュール署名検証を強制しない限り、これは問題は発生しません。

## 3.変更されたファームウェアをインストールします。

CSIツール補足資料を入手します。

```
git clone https://github.com/dhalperi/linux-80211n-csitool-supplementary.git
```

インテルのWi-Fiリンク5000シリーズアダプタの既存のファームウェアを再配置：

```
for file in /lib/firmware/iwlwifi-5000-*.ucode; do sudo mv $file $file.orig; done
```

修正されたファームウェアをインストールします。

```
sudo cp linux-80211n-csitool-supplementary/firmware/iwlwifi-5000-2.ucode.sigcomm2010 /lib/firmware/
sudo ln -s iwlwifi-5000-2.ucode.sigcomm2010 /lib/firmware/iwlwifi-5000-2.ucode
```

## 4.ユーザ空間のロギングツールを構築

log_to_file、CSIは、ファイルへのドライバを介して取得した書き込みコマンドラインツールを構築します。

```
make -C linux-80211n-csitool-supplementary/netlink
```

## 5.ロギングとテストを有効にします

ドライバをアンロードします。

```
sudo modprobe -r iwlwifi mac80211
```

ヒント：メッセージは、「FATAL：モジュールiwlwifiは使用中です。」iwldvmモジュールは明示的に（Ubuntuの以外のディストリビューションで）最初にアンロードする必要がある場合に表示されることがあります。もしそうなら、これを代わりに使用します。

```
sudo modprobe -r iwldvm iwlwifi mac80211
```

ドライバがアンロードされると、CSIのログを有効にしてそれをリロードします。

```
sudo modprobe iwlwifi connector_log=0x1
```

（例えば）IWとiproute2のユーティリティを使用して、802.11nアクセスポイントに接続する（またはNetworkManagerはNM-CLIまたはグラフィカルアプレットを使用して、無線インターフェイスのために有効になっている場合）。あるいは、インストールとhostapd（設定例については補足資料を参照）を設定することにより、802.11nアクセスポイントとして使用しているシステムの機能をさせることができます。この場合には、このシステムでhostapdを開始し、それに別の802.11nステーションを接続します。

いずれにしても、あなたが接続されると、ファイルへのCSIのロギングを開始します。

```
sudo linux-80211n-csitool-supplementary/netlink/log_to_file csi.dat
```

異なる端末でのIP接続しているアクセスポイントのアドレス（または接続されたステーション）でpingコマンドを実行します。応答はハイスループット（802.11n対応）ビットレートで返送される場合は、log_to_fileは、各ファイルにパケットを受信するためのCSIを書き、また、端末にメッセージを出力します。レート選択アルゴリズムに応じて、最初のいくつかのパケットは通常、レガシー（の802.11a/ b / g対応）の代わりにハイスループットビットレートのビットレートで送信されることに注意してください。これらは、CSIを提供するわけではありません。

CSIの収集の詳細についてはよくある質問を参照してください。