#!/bin/sh
## Durga-Air v1.9 Beta by NoeticBSD | Email: noeticbsd@gmail.com | IRC: noetic@irc.freenode.net #freebsd | Github http://github.com/NoeticBSD ##
clear

if [ $USER = "root" ]; then

	
file="/$HOME/.wpa_supplicant"
if [ -f "$file" ]
then
	echo " "
else
	cp /etc/wpa_supplicant.conf /$HOME/.wpa_supplicant
fi

devchk=`ifconfig wlan0 | head -1| tail -1 | cut -b 1-5`
if [ $devchk = "wlan0" ]; then
	device="wlan0"
else
	ifconfig | grep 0 | awk '{print $1}'
	read -p "please enter wireless interface" device
fi

case $1 in
-open)
	ifconfig $device up
	ifconfig $device up scan
	read -p  "Select Wireless SSID> " ssid
	clear
	ifconfig $device ssid $ssid 
	dhclient $device &
;;

-secured)
	ifconfig $device up
	ifconfig $device up scan
	read -p  "Select Wireless SSID> " ssid
	clear
	read -p "Enter Wireless Password/Passphrase> " pass
	clear				
	read -p "Would you like to save this wifi profile> " ans1
	case $ans1 in
	[nN][oO][nN])
			echo "Connecting to: " $ssid
			wpa_passphrase $ssid $pass >> /tmp/$ssid_temp
                       	wpa_supplicant -i$device -c /tmp/$ssid_temp &
			rm -rf /tmp/$ssid_temp
	;;
	
	*)
			echo "Connecting to: " $ssid
                       	wpa_passphrase $ssid $pass >> /$HOME/.wpa_supplicant
			wpa_supplicant -i$device -c /$HOME/.wpa_supplicant &
	esac
;;

-saved)
	sudo wpa_supplicant -i$device -c /$HOME/.wpa_supplicant &
;;

-NS)
	if [ ! -z $2 ] ; then
       		if ! grep -q $2 /etc/resolv.conf ; then
               		echo "nameserver $2" >> /etc/resolv.conf
       			echo "$2 has been added"  
    		fi
	fi
;;

-stop)
	ifconfig $device down delete
	echo "Wireless has been disabled"
;;

-scan)
	echo "				  AVAILABLE WIRELESS NETWORKS					  "
	echo "<------------------------------------------------------------------------------------------>"
	ifconfig $device up
	ifconfig $device up scan 
;;

*)
   cat <<EOF
Usage:
$0 -scan  -  Scans for wireless networks
$0 -open  -  Connects to open wifo
$0 -secured  -  Connects to secured wifi
$0 -saved  -  Connects to wifi using saved profile
$0 -stop  -  Stops wifi connection
$0 -NS [IP]  -  Sets this nameserver
EOF
    exit 0
;;
esac

else
	echo "DurgaAir requires root/superuser privileges."
fi

