#!/bin/bash
#########################################################
#  This is the install script to update  the            #
#  DMRGateway in /usr/local/bin  by VE3RD		#
#							#
#  VE3RD                                    2020-06-24  #
#########################################################

sudo mount -o remount,rw /
 cp ./Extras/dmrgateway.service /usr/local/sbin/

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


