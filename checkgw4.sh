#!/bin/bash
#########################################################
#  This is a CRON Utility to Re-Install DMRGateway-4    #
#  after a Disasterous Pi-Star Update    		#
#							#
#  VE3RD                                    2021-06-18  #
#########################################################

sudo mount -o remount,rw /

#echo -e '\e[1;44m'
#clear

GWVer=$(sudo DMRGateway -v /etc/dmrgateway | cut -d " " -f3)
GWVer2=$(echo "$GWVer"  | cut -d "-" -f2)
#echo "$GWVer2"
if [ "$GWVer2" = "4RD" ]; then
 echo "DMRGateway Version $GWVer"
else
 echo "Running Pi-Star DMRGateway $GWVer"
 echo "Updateing to DMRGateway-4 (VE3RD)"

 if [ -f /home/pi-star/DMRGateway-4/DMRGateway ]; then
    echo "Binaey File Not Found!   - Compiling  Package!"
   
   cd /home/pi-star/DMRGateway-4/ ; make
 fi 
 sudo /home/pi-star/DMRGateway-4/binupdate.sh
fi
