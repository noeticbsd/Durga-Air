#!/bin/sh
## Durga-Air v1.1 Beta by NoeticBSD
## Email: noeticbsd@gmail.com
## IRC: noetic@irc.freenode.net #freebsd
case $1 in
-open)
	ifconfig | grep 0 | awk '{print $1}'| grep 0
	read -p "Select Wireless Interface> " device
	clear
	sudo ifconfig $device up
	sudo ifconfig $device up scan
	read -p  "Select Wireless SSID> " ssid
	clear
	echo "Connecting to $ssid"
	ifconfig $device ssid $ssid
	dhclient $device
;;
-secured)
	ifconfig -a | grep 0 | awk '{print $1}'| grep 0
	read -p "Select Wireless Interface> " device
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
	ifconfig -a | grep 0 | awk '{print $1}'| grep 0
	read -p "Select Wireless Interface> " device
	clear
	sudo ifconfig $device up
	sudo ifconfig $device up scan
	read -p  "Select Wireless SSID> " ssid
	clear
	sudo wpa_supplicant -i$device -c /home/$USER/.durgaair/$ssid.conf &
;;
-NS)
	
	if [ ! -z $2 ] ; then
            if ! grep -q $2 /etc/resolv.conf ; then
                sudo echo "nameserver $2" >> /etc/resolv.conf
            fi
	fi
;;
-stop)
	ifconfig $device down delete
	exit()
;;
*)
	echo "Usage: ./DurgaAir.sh -[open|secured|saved|NS]"
;;
esac
