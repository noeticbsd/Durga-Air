# Durga-Air
a simple shell script to setup a wifi connection for FreeBSD
Durga-Air is a shell based command line tool used to assist FreeBSD users with wireless connections. The reason for this was due to issuing I began to have with WifiMgr. Durga-Air is completely CLI based and requires that you have sudo/root access, wlan0 configured(suggested but not required), and wpa_supplicant installed, Durga-Air currently supports the following tasks

1) Scan for Available WAP
2) Connect to open WAP
3) Connect to secured WAP and saves a copy of the wpa_supplicant config for this connection
4) Connect to previsouly used secured WAP (uses saved wpa_supplicant config files)
5) Disconnect/Stop Wifi connections from CLI

We are currently working to add new options to the script. 

Installation:

1) You will need to create a folder .durgaair under your main home directory (mkdir /home/$USER/.durgaair).
2) Download and copy the wpa_wifi.conf (wpa_supplicant.conf) to the /home/user/.durgaair directory. 
3) installation is complete you can now run durga-air. 
