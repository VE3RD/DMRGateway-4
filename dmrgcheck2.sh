#!/bin/bash
#################################################################
#  Check for Unauthorized Changes in /etc/dmrgateway and 	#
#  Restore the backup file 					#
#								#
#  VE3RD 					2021-03-16	#
#################################################################
set -o errexit
set -o pipefail
sudo mount -o remount,rw /

f1="/etc/dmrgateway"
f2="/etc/dmrgateway.bak"
log="/var/log/pi-star/dmrgawaychange.txt"

 GWAddr=$(sed -nr "/^\[DMR Network\]/ { :l /^Address[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)

function logit {
file=$(cat /etc/dmrgateway )

M=$(ls -alt /etc/dmrgateway  | cut -d " " -f 6)
D=$(ls -alt /etc/dmrgateway  | cut -d " " -f 7)
T=$(ls -alt /etc/dmrgateway  | cut -d " " -f 8)

Mb=$(ls -alt /etc/dmrgateway.bak  | cut -d " " -f 6)
Db=$(ls -alt /etc/dmrgateway.bak  | cut -d " " -f 7)
Tb=$(ls -alt /etc/dmrgateway.bak  | cut -d " " -f 8)

echo "Work: $M $D $T -- Bak: $Mb $Db $Tb" >> /var/log/pi-star/dmrgawaychange.txt

}


if [ "$GWAddr" == 127.0.0.1 ]; then
 	if [ "$f1" -nt "$f2" ]; then
		echo "The /etc/dmrgateway file has been modified"
		sudo cp /etc/dmrgateway.bak /etc/dmrgateway
                logit
 		touch /etc/dmrgateway ; touch /etc/dmrgateway.bak 
		sudo dmrgateway.service restart ; mmdvmhost.service restart
  	else
		echo "Files Match - No Action Taken"
	fi 
else
 	echo "The DMRGateway is NOT Turned ON - No Action Taken!"
fi




