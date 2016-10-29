# 進捗

## インフラ

* PC1 : Panasonic CF-B11, WiFi カード を Advanced-N 6205 -> WiFi Link 5300 に交換, CSI Tool インストール済み
* PC2 : Panasonic CF-SX1
* PC3 : Panasonic CF-B11, CSI Tool インストール済み

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
				* apt-get updateはできなくなっていた
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
		* PC1の調整
			* 【実行】PC3の状況把握
			* 【実行】PC1の状況把握
			* 【目標】PC1の無線LAN接続
			* 【実行】[Installation Instructions](http://dhalperi.github.io/linux-80211n-csitool/installation.html)の一部をちゃんと和訳
				* 英文
					* Connect to an 802.11n access point, by using (for example) the iw and iproute2 utilities (or if NetworkManager is enabled for the wireless interface, using nm-cli or the graphical applet). 
					* Alternatively, you can let your system function as an 802.11n access point by installing and configuring hostapd (see the supplementary material for configuration examples); in this case, start hostapd on this system and then connect another 802.11n station to it.
					* Either way, once you are connected, begin logging CSI to a file:
					* sudo linux-80211n-csitool-supplementary/netlink/log_to_file csi.dat
				* 和訳
					* 例えば、iw と iproute2 のユーティリティを使用して(もしくは、NetworkManagerが有効である場合、nm-cli か graphical appletを使用して)、802.11nアクセスポイントに接続する
					* あるいは、hostapd をインストールし設定することにより802.11nのアクセスポイントとして動作させることができる場合、hostapdをスタートし、それに別の802.11nステーションを接続する。
					* いずれにしても、一度でも接続すれば、ファイルへのCSIのロギングを開始する	
			* 【実行】ググる
				* [iproute2 入門](https://linuxjf.osdn.jp/JFdocs/Adv-Routing-HOWTO/lartc.iproute2.html)
				* [net-toolsとiproute2のコマンド対応早見表](https://orebibou.com/2014/12/ip-toolsとiproute2のコマンド対応早見表/)	
				* [Ubuntu 14.04の不安定なWi-Fi接続を直しました](http://blog.webfun.tech/entry/fix-wifi-error-on-ubntu14)
				* [ubuntu 14.04 を無線LANアクセスポイントにする](http://blog.be-dama.com/2014/07/23/ubuntu-14-04-を無線lanアクセスポイントにする/)
			* 【考察】PC1
				* if wlan0 ができない -> リロードしたドライバに問題が？
					* 別の方法で設定すべき？
					* iproutes 使える？
				* 




PC3

```
# iwconfig

eth0      no wireless extensions.

wlan0     IEEE 802.11abgn  ESSID:"I???????_ac"  
          Mode:Managed  Frequency:5.18 GHz  Access Point: DC:??:??:??:??:05   
          Bit Rate=243 Mb/s   Tx-Power=15 dBm   
          Retry short limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=67/70  Signal level=-43 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:8   Missed beacon:0

lo        no wireless extensions.

# ifconfig

lo        Link encap:ローカルループバック  
          inetアドレス:127.0.0.1  マスク:255.0.0.0
          inet6アドレス: ::1/128 範囲:ホスト
          UP LOOPBACK RUNNING  MTU:65536  メトリック:1
          RXパケット:2 エラー:0 損失:0 オーバラン:0 フレーム:0
          TXパケット:2 エラー:0 損失:0 オーバラン:0 キャリア:0
          衝突(Collisions):0 TXキュー長:0 
          RXバイト:176 (176.0 B)  TXバイト:176 (176.0 B)

wlan0     Link encap:イーサネット  ハードウェアアドレス 60:??:??:??:??:b0  
          inetアドレス:1??.??.??.44  ブロードキャスト:1??.??.255.255  マスク:255.255.0.0
          inet6アドレス: fe80::6267:20ff:fe90:56b0/64 範囲:リンク
          UP BROADCAST RUNNING MULTICAST  MTU:1500  メトリック:1
          RXパケット:1255 エラー:0 損失:0 オーバラン:0 フレーム:0
          TXパケット:123 エラー:0 損失:0 オーバラン:0 キャリア:0
          衝突(Collisions):0 TXキュー長:1000 
          RXバイト:239638 (239.6 KB)  TXバイト:17551 (17.5 KB)

# ping -c 3 8.8.4.4

PING 8.8.4.4 (8.8.4.4) 56(84) bytes of data.
64 bytes from 8.8.4.4: icmp_seq=1 ttl=41 time=44.6 ms
64 bytes from 8.8.4.4: icmp_seq=2 ttl=41 time=44.1 ms
64 bytes from 8.8.4.4: icmp_seq=3 ttl=41 time=44.2 ms

--- 8.8.4.4 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 44.161/44.366/44.676/0.222 ms

```

PC1

```
# iwconfig

eth0 	no wireless extensions.

wlan0	IEEE 802.11abgn 	ESSID:"I???????_ac"
		Mode:Managed	Frequency:5.18GHz 	Access Point: DC:??:??:??:??:05
		Bit Rate=6 Mb/s 	Tx-Power=15 dBm
		Retry short limit:7 	RTS thr:off 	Fragment thr:off
		Encryption key:off
		Power Management:off
		Link Quality=57/80 	Signal level=-53 dBm
		Rx invalid nwid:0 	Rx invalid crypt:0 	Rx invalid frag:0
		Tx excessive retries:31 	Invalid misc:0 	Missed beacon:0

lo 		no wireless extensions.

# ifconfig

lo 		Link encap:Local Loopback
		inet addr:127.0.0.1 	Mask:255.0.0.0
		inet6 addr: ::1/128 	Scope:Host
		UP LOOPBACK RUNNING 	MTU:65536 	Metric:1
		RX packets:27	errors:0 	dropped:0 	overruns:0 	frame:0
		TX packets:27	errors:0 	dropped:0 	overruns:0 	carrier:0
		collisions:0 	txqueuelen:0
		RZ bytes:2504 (2.5 KB) 	TX bytes:2504 (2.5 KB)

wlan0	Link encap:Ethernet 	HWaddr 00:1?:??:??:??:fe
		inet addr:1??.??.??.39	Bcast:1??.??.255.255		Mask:255.255.0.0
		inet6 addr: fe??::???:????:????:10fe/64		Scope:Link
		UP LOOPBACK RUNNING 	MTU:1500	Metric:1
		RX packets:3319	errors:0 	dropped:0 	overruns:0 	frame:0
		TX packets:33	errors:0 	dropped:0 	overruns:0 	carrier:0
		collisions:0 	txqueuelen:1000
		RZ bytes:662732 (662.7 KB)	TX bytes:2474 (2.4 KB)

# ping -c 3 8.8.4.4

PING 8.8.4.4 (8.8.4.4) 56(84) bytes of data.
From 172.16.10.19 icmp_seq=1 Destination Host Unreachable
From 172.16.10.19 icmp_seq=2 Destination Host Unreachable
From 172.16.10.19 icmp_seq=3 Destination Host Unreachable

--- 8.8.4.4 ping statistics ---
3 packets transmitted, 0 received. +3 errors, 100% packet loss, time 1999ms pipe 3

# sudo modprobe -r iwlwifi mac80211
# sudo modprobe iwlwifi connector_log=0x1

# iwconfig

eth0 	no wireless extensions.

wlan0	IEEE 802.11abgn 	ESSID:off/any
		Mode:Managed	Access Point: Not-Associated	Tx-Power=15 dBm
		Retry short limit:7 	RTS thr:off 	Fragment thr:off
		Encryption key:off
		Power Management:off

lo 		no wireless extensions.

# ifconfig

lo 		Link encap:Local Loopback
		inet addr:127.0.0.1 	Mask:255.0.0.0
		inet6 addr: ::1/128 	Scope:Host
		UP LOOPBACK RUNNING 	MTU:65536 	Metric:1
		RX packets:44	errors:0 	dropped:0 	overruns:0 	frame:0
		TX packets:44	errors:0 	dropped:0 	overruns:0 	carrier:0
		collisions:0 	txqueuelen:0
		RZ bytes:4216 (4.2 KB) 	TX bytes:4216 (4.2 KB)

# ifup wlan0

RTNETLINK answers: File exists
Faild to bring up wlan0


```

