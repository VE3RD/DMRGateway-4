#!/bin/bash
#########################################################
#  This is the install script to update  the            #
#  DMRGateway in /usr/local/bin  by VE3RD		#
#							#
#  VE3RD                                    2021-05-01  #
#########################################################

sudo mount -o remount,rw /

echo -e '\e[1;44m'
clear
echo "Starting Binary Install"

echo ""
echo "If this is a first time install of DMRGateway-4 then say Yes to the /etc/dmrgateway file update"
echo "If this is an Update of DMRGateway-4 then say No"
echo ""
while true; do
    read -p "Do you wish to update your /etc/dmrgateway file? y/n " yn
    case $yn in
        [Yy]* ) cp ./DMRGateway.ini /etc/dmrgateway ; break;;
        [Nn]* ) break ;;
        * ) echo "Please answer yes or no.";;
    esac
done


sudo dmrgateway.service stop
sudo cp ./DMRGateway /usr/local/bin/
sudo dmrgateway.service start
sleep 2
sudo mmdvmhost.service restart
sed -i '/use_colors = /c\use_colors = OFF' ~/.dialogrc

echo -e '\e[\033[40m'

clear

