echo "ssh接続を可能に"
apt-get install openssh-server

echo "日本語化"
echo "vim ~/.bashrc"
echo "---------------------------"
echo 'case $TERM in'
echo '     linux)LANG=C ;;'
echo '     *)LANG=ja_JP.UTF-8 ;;'
echo 'esac'
echo "---------------------------"
echo "を追記"
echo "source ~/.bashrc"

echo "サスペンドの防止"
echo "vim /etc/systemd/logind.conf"
echo "---------------------------"
echo "- #HandleLidSwitch=suspend"
echo "+ HandleLidSwitch=ignore"
echo "---------------------------"
echo "sudo restart systemd-logind"



