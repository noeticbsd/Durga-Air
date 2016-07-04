#!/bin/sh
## Durga-Air v1.0 Beta by NoeticBSD
## Email: ShadowBSD.dev@gmail.com
## IRC: noetic@irc.freenode.net #freebsd

echo "Durga-Air v1.0 By NoeticBSD"
case $1 in
-open)
	ifconfig -a | grep 0 | awk '{print $1}'| grep 0
	read -p "Select wireless interface> " device
	clear
	sudo ifconfig $device up
	sudo ifconfig $device up scan
	read -p  "Select a SSID> " ssid
	clear
	echo "Connecting to $ssid"
	ifconfig $device ssid $ssid
	dhclient $device
;;
-secured)
	ifconfig -a | grep 0 | awk '{print $1}'| grep 0
	read -p "Select wireless interface> " device
	clear
	sudo ifconfig $device up
	sudo ifconfig $device up scan
	read -p  "Select a SSID> " ssid
	clear
	read -p "Enter Wifi Password/Passphrase> " pass
	clear				
	cp /home/$USER/.wifi_conf/wpa_wifi.conf /home/$USER/.wifi_conf/$ssid.conf
	sed -i.conf 's/home/'$ssid'/g' /home/$USER/.wifi_conf/$ssid.conf
	sed -i.conf 's/pass/'$pass'/g' /home/$USER/.wifi_conf/$ssid.conf
	read -p "Would you like to save this wifi profile> " ans1
	case $ans1 in
		[nN][oO][nN])
			echo "Connecting to: " $ssid
                        sudo wpa_supplicant -i$device -c /home/$USER/.wifi_conf/$ssid.conf &
			rm /home/$USER/.wifi_conf/$ssid.conf
		;;
		*)
			echo "Connecting to: " $ssid
                        sudo wpa_supplicant -i$device -c /home/$USER/.wifi_conf/$ssid.conf &
	esac
;;
-saved)
	ifconfig -a | grep 0 | awk '{print $1}'| grep 0
	read -p "Select wireless interface> " device
	clear
	sudo ifconfig $device up
	sudo ifconfig $device up scan
	read -p  "Select a SSID> " ssid
	clear
	sudo wpa_supplicant -i$device -c /home/$USER/.wifi_conf/$ssid.conf &
;;
*)
	echo "Usage: wifi-manager -[open|secured|saved]"
;;
esac
