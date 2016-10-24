# 研究用のubuntu_serverの設定方法

## 1. どうにかしてubuntu_serverをインストール

* ディスクをPCに入れる
* BIOSで起動の優先順位を変える
* 再起動
* インストーラーに従う

↑ うる覚えかつ、自信なし

## 2. ネットに繋がるようにする(有線)

* iwconfig でインターフェースを確認
* /etc/network/interfaces に IPアドレスなどを記述

```
auto lo
iface lo inet loopback
 
auto eth0
iface eth0 inet static
address 192.168.11.211
netmask 255.255.255.0
network 192.168.11.0
broadcast 192.168.11.255
gateway 192.168.11.1
dns-nameservers 192.168.11.1
```
* sudo /etc/init.d/networking restart でネットワークを再起動
	* もしくは、
	* sudo ifdown eth0 
	* sudo ifup eth0
* iwconfig, ifconfig でちゃんと繋がっているか確認
* ping -c 3 8.8.4.4 でホストに繋がっているかどうか確認

## 3. ネットに繋がるようにする(無線, WPA)

* iwconfig でインターフェースを確認
* sudo apt-get install wpasupplicant
	* wpaの設定のため
* wpa_passphrase [ssid] [password] > /etc/wpa_supplicant/wpa_supplicant.conf
	* で wpa_supplicant.conf を生成
* /etc/wpa_supplicant/wpa_supplicant.conf にセキュリティ情報を書き足す(以下は、認証方式:WPA-PSK,暗号方式:AES)

```
network={
ssid="my_ssid"
psk=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
proto=WPA
key_mgmt=WPA-PSK
pairwise=CCMP
group=CCMP
}
```


* /etc/network/interfaces に IPアドレスなどを記述

```
auto lo
iface lo inet loopback
 
auto wlan0
iface wlan0 inet static
address 192.168.11.211
netmask 255.255.255.0
network 192.168.11.0
broadcast 192.168.11.255
gateway 192.168.11.1
dns-nameservers 192.168.11.1
wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
```

* sudo /etc/init.d/networking restart でネットワークを再起動
* wpa_supplicant -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf -w
	* で動作確認
		* CTRL-EVENT-CONNECTED - Connection to xx:xx:xx:xx:xx:xx completed ・・・
		* が出ればOK
* wpa_supplicant -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf -B
	* で バックグラウンド実行
		* IPアドレスが表示されればOK
* iwconfigでSSIDが表示されずに繋がらない場合、
	* iwconfig wlan0 essid [ssid]
	* で無理やりつける
		* もしくは、
		* wireless-essid [ssid]
		* を /etc/network/interfaces に追記し、
		* sudo /etc/init.d/networking restart
* ifup wlan0 で起動

# 4. CSI Toolの導入

[Linux 802.11n CSI Tool Installation Instructions](http://dhalperi.github.io/linux-80211n-csitool/installation.html)

# 998. 参考URL

* [Ubuntu serverで無線LANの設定](http://bty.sakura.ne.jp/wp/archives/754)
* [ゆうちくりんの忘却禄 Linuxで無線LAN](http://www.youchikurin.com/blog/2007/06/linuxlan_1.html)

# 999. その他

## よく使うコマンド

* sudo bash
	* rootに入る
* less /var/log/syslog
	* システムログを見る
* dmesg | less
	* システムログを見る
* ping -c 3 172.16.0.1
	* ?
* ping -c 3 172.16.0.3
	* ?
