#!/bin/sh
## Durga-Air v1.7 Beta by NoeticBSD | Email: noeticbsd@gmail.com
## IRC: noetic@irc.freenode.net #freebsd | Github http://github.com/NoeticBSD
#check for wlan0 
devchk=`ifconfig wlan0 | head -1| tail -1 | cut -b 1-5`
if [ $devchk = "wlan0" ]; then
	device="wlan0"
else
	clear
	ifconfig | grep 0 | awk '{print $1}'
	read -p "please enter wireless interface" device
fi

case $1 in
#main code
-open)
	clear
	sudo ifconfig $device up
	sudo ifconfig $device up scan
	read -p  "Select Wireless SSID> " ssid
	clear
	sudo ifconfig $device ssid $ssid 
	sudo dhclient $device
;;
-secured)
	clear
	sudo ifconfig $device up
	sudo ifconfig $device up scan
	read -p  "Select Wireless SSID> " ssid
	clear
	read -p "Enter Wireless Password/Passphrase> " pass
	clear				
	read -p "Would you like to save this wifi profile> " ans1
	case $ans1 in
		[nN][oO][nN])
			echo "Connecting to: " $ssid
			wpa_passphrase $ssid $pass >> /home/$USER/.durgaair/$ssid_temp
                        sudo wpa_supplicant -i$device -c /home/$USER/.durgaair/$ssid_temp &
			rm -rf /home/$USER/.durgaair/$ssid_temp
		;;
		*)
			echo "Connecting to: " $ssid
                        wpa_passphrase $ssid $pass >> /home/$USER/.durgaair/wpa_supplicant
			sudo wpa_supplicant -i$device -c /home/$USER/.durgaair/wpa_supplicant.conf &
	esac
;;
-saved)
	sudo wpa_supplicant -i$device -c /home/$USER/.durgaair/wpa_supplicant.conf &
;;
-NS)
	clear
	if [ ! -z $2 ] ; then
            if ! grep -q $2 /etc/resolv.conf ; then
                sudo echo "nameserver $2" >> /etc/resolv.conf
            fi
	fi
	echo "Done."
;;
-stop)
	clear
	sudo ifconfig $device down delete
	echo "Wireless has been disabled"
;;
-scan)
	clear
	sudo ifconfig $device up
	sudo ifconfig $device up scan
	echo "Available Wireless Networks"
;;
*)
clear
   cat <<EOF
Usage:
$0 -scan wlan0  -  Scans for wireless networks
$0 -open  -  Connects to open wifo
$0 -secured  -  Connects to secured wifi
$0 -saved  -  Connects to wifi using saved profile
$0 -stop [interface]  -  Stops wifi connection
$0 -NS [IP]  -  Sets this nameserver
EOF
    exit 0
;;
esac
