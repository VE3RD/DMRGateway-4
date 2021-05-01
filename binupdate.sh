#!/bin/bash
#########################################################
#  This is the install script to update  the            #
#  DMRGateway in /usr/local/bin  by VE3RD		#
#							#
#  VE3RD                                    2020-06-24  #
#########################################################

sudo mount -o remount,rw /
# cp ./Extras/dmrgateway.service /usr/local/sbin/

sed -i '/use_colors = /c\use_colors = ON' ~/.dialogrc
sed -i '/screen_color = /c\screen_color = (WHITE,BLUE,ON)' ~/.dialogrc
sed -i '/title_color = /c\title_color = (YELLOW,RED,ON)' ~/.dialogrc
echo -e '\e[1;44m'
clear
echo "Starting Binary Install"

echo ""
while true; do
    read -p "Do you wish to update your /etc/dmrgateway file?" yn
    case $yn in
        [Yy]* ) cp ./DMRGateway.ini /etc/dmrgateway ; break;;
        [Nn]* ) break ;;
        * ) echo "Please answer yes or no.";;
    esac
done


#Check for NetMode
NetMode=$(sudo sed -nr "/^\[General\]/ { :l /^NetMode[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
if [ ! $NetMode ]; then
	echo "Please Add NetMode Parameter to /etc/dmrgateway"
	echo "Netmode=0 for Raw Mode,    NetMode=1 for 7 Digit Mode"
	echo "Install Script Aborting, Correct the Error and rerun this script"
	exit
fi 
sudo dmrgateway.service stop
sudo cp ./DMRGateway /usr/local/bin/
sudo dmrgateway.service start
sleep 2
sudo mmdvmhost.service restart
sed -i '/use_colors = /c\use_colors = OFF' ~/.dialogrc

echo -e '\e[\033[40m'

clear

