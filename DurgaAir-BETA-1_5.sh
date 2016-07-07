#!/bin/sh
## Durga-Air v1.1 Beta by NoeticBSD
## Email: noeticbsd@gmail.com
## IRC: noetic@irc.freenode.net #freebsd

#check for wlan0 
devchk=`ifconfig wlan0 | head -1| tail -1 | cut -b 1-5`
if [ $devchk = "wlan0" ]; then
	echo "wlan0 Exists."
	device="wlan0"
else
	clear
	ifconfig | grep 0 | awk '{print $1}'
	read -p "please enter wireless interface" device
fi


#main code
case $1 in
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
	cp /home/$USER/.durgaair/wpa_wifi.conf /home/$USER/.durgaair/$ssid.conf
	sed -i.conf 's/home/'$ssid'/g' /home/$USER/.durgaair/$ssid.conf
	sed -i.conf 's/pass/'$pass'/g' /home/$USER/.durgaair/$ssid.conf
	read -p "Would you like to save this wifi profile> " ans1
	case $ans1 in
		[nN][oO][nN])
			echo "Connecting to: " $ssid
                        sudo wpa_supplicant -i$device -c /home/$USER/.durgaair/$ssid.conf &
			rm /home/$USER/.durgaair/$ssid.conf
		;;
		*)
			echo "Connecting to: " $ssid
                        sudo wpa_supplicant -i$device -c /home/$USER/.durgaair/$ssid.conf &
	esac
;;
-saved)
	clear
	sudo ifconfig $device up
	sudo ifconfig $device up scan
	read -p  "Select Wireless SSID> " ssid
	clear
	sudo wpa_supplicant -i$device -c /home/$USER/.durgaair/$ssid.conf &
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
   cat <<EOF
Usage:
$0 -scan wlan0  -  Scans for wireless networks
$0 -open  -  Connects to open wifo
$0 -secured  -  Connects to secured wifi
$0 -saved  -  Connects to wifi using saved profile
$0 -stop wlan0  -  Stops wifi connection
$0 -NS 8.8.8.8  -  Sets this nameserver
EOF
    exit 0

;;
esac
