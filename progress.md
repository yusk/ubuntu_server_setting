# 進捗

## インフラ

* PC1 : Panasonic CF-B11, WiFi カード を Advanced-N 6205 -> WiFi Link 5300 に交換
* PC2 : Panasonic CF-SX1
* PC3 : Panasonic CF-B11

## 必要インフラ

* WiFi card : WiFi Link Intel 5300(.11n)

## ネットワーク設定

```
auto lo
iface lo inet loopback

auto wlan0
iface wlan0 inet static
	address ??.??.??.39,43,44
	netmask 255.255.0.0
	network ??.??.0.0
	broadcast ???.??.???.???
	gateway ??.??.0.1
	dns-nameservers ???.?.???.??, ???.?.??.??
	
	wpa-ssid "I????????"
	wpa-psk "E????????????"
```

## 目標

[Linux 802.11n CSI Tool](http://dhalperi.github.io/linux-80211n-csitool/index.html)を動かす

## 作業ログ

* 2016/10/27
	* 行ったこと
  		* 【問題】PC2, PC3が sudo apt-get update ができない(外部へのアクセスができない)(ping 8.8.4.4 は通る)
		* 【解決】外部アクセス可能に
			* dns-nameserver のipが片方死んでいた模様
		* 生きている方を指定したら無線接続可能に！
		* 【実行】[CSI Tool インストール方法の日本語訳](https://github.com/yusk/ubuntu_server_setting/blob/master/CSI_Tool_readme.md)の作成
		* 【実行】[CSI Tool インストールのシェルスクリプト](https://github.com/yusk/ubuntu_server_setting/blob/master/csi_tool_install.sh)の作成
		* 【実行】PC1に 同じネットワーク設定
		* 【断念】PC1の無線LAN接続失敗
		* 【実行】PC3に CSI Tool のインストール
			* エラーが二箇所
				* sudo make -C /lib/modules/$(uname -r)/build M=$(pwd)/drivers/net/wireless/iwlwifi INSTALL_MOD_DIR=updates modules_install
				* sudo modprobe iwiwifi connector_log=0x1
				* 以下にエラー内容記述
			* 気になる点
				* CSI Tool インストール後、外部との接続ができなくなった
				* ping 8.8.4.4 通っていた   
		* 【断念】PC3 の CSI Tool 動かず -> やはりWiFiカードは変えないといけなさそう
		* 【目標】PC1(Intel 5300 のカードを使っているPC) に無線LANを接続
		* 【実行】PC1 に ___ubuntu server 14.04.3___ を再インストール
			* インストールを無線で行えた -> 希望あり？
		* 【実行】無線の設定
			* はじめは、ping 8.8.4.4は出来るが、apt-get updateはできず
			* ネットワーク設定にdns-nameservise を一つに、broadcastを追加、ipを.42 -> .39に
			* apt-get update 動いた！！！
		* 【解決】PC1 無線LAN接続成功
		* 【目標】CSI Toolを動かす
		* 【実行】インストーラーに従って CSI Tool インストール
			* error 1 は発生していた。
			* 無視してインストール続行
			* 無線LANは繋がらず、アソシエイションもできない状態に
			* csi.dat のファイルサイズも増えず
	* 原因
		 * error 1 ?
	* 次の予定
		* PC1 の無線LAN接続
		* CSI Tool をどうにかして動かす

error 1

```
make: ディレクトリ `/usr/src/linux-headers-3.19.0-25-generic' に入ります
  INSTALL /home/yusk/linux-80211n-csitool/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
Can't read private key
  INSTALL /home/yusk/linux-80211n-csitool/drivers/net/wireless/iwlwifi/iwlwifi.ko
Can't read private key
  INSTALL /home/yusk/linux-80211n-csitool/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
Can't read private key
  DEPMOD  3.19.0-25-generic
make: ディレクトリ `/usr/src/linux-headers-3.19.0-25-generic' から出ます
```

error 2

```
Firmware size does not match iwlwifi-5000-2.ucode.sigcomm2010. The UW 802.11n CSI Tool will not work.
```

* 2016/10/28
	* 行ったこと
		* pythonの勉強
			* ライブラリ関連
				* numpy
				* pandas
				* matplotlib.pyplot
		* markdown × tex
			* $で囲むとtex記法が使えるらしい
			* md -> tex 変換が可能
				* [Markdown+Texの環境構築と使い方](http://qiita.com/ish_774/items/82cbda064792306a5493)
			* 原稿書くのに便利かも

