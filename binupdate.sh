#!/bin/bash
#########################################################
#  This is the install script to update  the            #
#  DMRGateway in /usr/local/bin  by VE3RD		#
#							#
#  VE3RD                                    2021-05-01  #
#########################################################

sudo mount -o remount,rw /

#echo -e '\e[1;44m'
#clear
echo "Starting Binary Install"

# if this is a first install make a backup of the original DMRGateway
if [ ! -f /usr/local/bin/DMRGateway.orig ]; then
   sudo cp /usr/local/bin/DMRGateway /usr/local/bin/DMRGateway.orig
fi

sudo dmrgateway.service stop
sudo cp ./DMRGateway /usr/local/bin/
sudo dmrgateway.service start
sleep 2
sudo mmdvmhost.service restart
#sed -i '/use_colors = /c\use_colors = OFF' ~/.dialogrc

#echo -e '\e[\033[40m'


