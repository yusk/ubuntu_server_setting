echo "ビルドツール、Linux開発ヘッダー、およびGitのクライアントをインストール"
cd
apt-get install gcc make linux-headers-$(uname -r) git-core

echo "無線ドライバの修正を含むCSIツール、Linuxのソースツリーを入手"
CSITOOL_KERNEL_TAG=csitool-$(uname -r | cut -d . -f 1-2)
git clone https://github.com/dhalperi/linux-80211n-csitool.git
cd linux-80211n-csitool
git checkout ${CSITOOL_KERNEL_TAG}

echo "既存のカーネルの変更されたドライバをビルド"
make -C /lib/modules/$(uname -r)/build M=$(pwd)/drivers/net/wireless/iwlwifi modules

echo "モジュールのアップデートディレクトリに変更されたドライバをインストール"
make -C /lib/modules/$(uname -r)/build M=$(pwd)/drivers/net/wireless/iwlwifi INSTALL_MOD_DIR=updates modules_install
depmod
cd

echo "CSIツール補足資料を入手"
git clone https://github.com/dhalperi/linux-80211n-csitool-supplementary.git

echo "インテルのWi-Fiリンク5000シリーズアダプタの既存のファームウェアを再配置"
for file in /lib/firmware/iwlwifi-5000-*.ucode; do sudo mv $file $file.orig; done

echo "修正されたファームウェアをインストール"
cp linux-80211n-csitool-supplementary/firmware/iwlwifi-5000-2.ucode.sigcomm2010 /lib/firmware/
ln -s iwlwifi-5000-2.ucode.sigcomm2010 /lib/firmware/iwlwifi-5000-2.ucode

echo "ファイルへのドライバを介して取得した書き込みコマンドラインツールを構築"
make -C linux-80211n-csitool-supplementary/netlink

echo "ドライバをアンロード"
sudo modprobe -r iwlwifi mac80211

echo "CSIのログを有効にしてそれをリロード"
sudo modprobe iwlwifi connector_log=0x1

echo "ロギングを開始"
linux-80211n-csitool-supplementary/netlink/log_to_file csi.dat

echo "異なる端末でのIP接続しているアクセスポイントのアドレスでpingコマンドを実行"
echo "-> csi.dat に書き込まれる"