#!/bin/bash
############################################################
#  This script will automate the process of                #
#  Installing and Configuring The DMRGateway-4 	           #
#							   #
#  VE3RD                                      2022/04/25   #
############################################################
set -o errexit
set -o pipefail
sudo mount -o remount,rw /
sudo echo "Starting setgwmode" > /home/pi-star/testlog.txt
CALL=$(sed -nr "/^\[General\]/ { :l /^Callsign[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)

## Raw Mode
function GWMode1(){
#sudo sed -i '/TGRewrite1/s/^/#/g' /etc/dmrgateway    ###    (to comment out)

 sudo sed -i '/^\[/h;G;/General/s/\(GWMode=\).*/\11/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(TGRewrite0=\).*/\1'"2,1,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 2/s/\(TGRewrite0=\).*/\1'"2,1,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 3/s/\(TGRewrite0=\).*/\1'"2,1,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(TGRewrite0=\).*/\1'"2,1,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(TGRewrite0=\).*/\1'"2,1,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(TGRewrite0=\).*/\1'"2,1,2,1,999999"'/m;P;d' /etc/dmrgateway

 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(TGRewrite1=\).*/\1'"2,1,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 2/s/\(TGRewrite1=\).*/\1'"2,1,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 3/s/\(TGRewrite1=\).*/\1'"2,1,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(TGRewrite1=\).*/\1'"2,1,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(TGRewrite1=\).*/\1'"2,1,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(TGRewrite1=\).*/\1'"2,1,2,1,999999"'/m;P;d' /etc/dmrgateway

 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(PCRewrite0=\).*/\1'"2,1,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 2/s/\(PCRewrite0=\).*/\1'"2,1,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 3/s/\(PCRewrite0=\).*/\1'"2,1,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(PCRewrite0=\).*/\1'"2,1,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(PCRewrite0=\).*/\1'"2,1,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(PCRewrite0=\).*/\1'"2,1,2,1,999999"'/m;P;d' /etc/dmrgateway

 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(SrcRewrite0=\).*/\1'"2,1,2,$CALL,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 2/s/\(SrcRewrite0=\).*/\1'"2,1,2,$CALL,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 3/s/\(SrcRewrite0=\).*/\1'"2,1,2,$CALL,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(SrcRewrite0=\).*/\1'"2,1,2,$CALL,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(SrcRewrite0=\).*/\1'"2,1,2,$CALL,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(SrcRewrite0=\).*/\1'"2,1,2,$CALL,999999"'/m;P;d' /etc/dmrgateway


}

## 8 Digit Mode
function GWMode8(){
 #sudo sed -i '/TGRewrite1/s/^#//g' /etc/dmrgateway     ###    (to uncomment)

 sudo sed -i '/^\[/h;G;/General/s/\(GWMode=\).*/\18/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(TGRewrite0=\).*/\1'"2,11000001,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 2/s/\(TGRewrite0=\).*/\1'"2,12000001,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 3/s/\(TGRewrite0=\).*/\1'"2,13000001,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(TGRewrite0=\).*/\1'"2,14000001,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(TGRewrite0=\).*/\1'"2,15000001,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(TGRewrite0=\).*/\1'"2,16000001,2,1,999999"'/m;P;d' /etc/dmrgateway

 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(TGRewrite1=\).*/\1'"2,1000001,2,1000001,5599999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 2/s/\(TGRewrite1=\).*/\1'"2,1000001,2,1000001,5599999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 3/s/\(TGRewrite1=\).*/\1'"2,1000001,2,1000001,5599999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(TGRewrite1=\).*/\1'"2,1000001,2,1000001,5599999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(TGRewrite1=\).*/\1'"2,1000001,2,1000001,5599999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(TGRewrite1=\).*/\1'"2,1000001,2,1000001,5599999"'/m;P;d' /etc/dmrgateway

 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(PCRewrite0=\).*/\1'"2,11000001,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 2/s/\(PCRewrite0=\).*/\1'"2,12000001,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 3/s/\(PCRewrite0=\).*/\1'"2,13000001,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(PCRewrite0=\).*/\1'"2,14000001,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(PCRewrite0=\).*/\1'"2,15000001,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(PCRewrite0=\).*/\1'"2,16000001,2,1,999999"'/m;P;d' /etc/dmrgateway

# sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(TGRewrite1=\).*/\1'"2,1,2,1,9999999"'/m;P;d' /etc/dmrgateway
# sudo sed -i '/^\[/h;G;/DMR Network 2/s/\(TGRewrite1=\).*/\1'"2,1,2,1,9999999"'/m;P;d' /etc/dmrgateway
# sudo sed -i '/^\[/h;G;/DMR Network 3/s/\(TGRewrite1=\).*/\1'"2,1,2,1,9999999"'/m;P;d' /etc/dmrgateway
# sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(TGRewrite1=\).*/\1'"2,1,2,1,9999999"'/m;P;d' /etc/dmrgateway
# sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(TGRewrite1=\).*/\1'"2,1,2,1,9999999"'/m;P;d' /etc/dmrgateway
# sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(TGRewrite1=\).*/\1'"2,1,2,1,9999999"'/m;P;d' /etc/dmrgateway

 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(SrcRewrite0=\).*/\1'"2,1,2,$CALL,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 2/s/\(SrcRewrite0=\).*/\1'"2,1,2,$CALL,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 3/s/\(SrcRewrite0=\).*/\1'"2,1,2,$CALL,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(SrcRewrite0=\).*/\1'"2,1,2,$CALL,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(SrcRewrite0=\).*/\1'"2,1,2,$CALL,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(SrcRewrite0=\).*/\1'"2,1,2,$CALL,999999"'/m;P;d' /etc/dmrgateway

}


function GWMode7(){
#sudo sed -i '/TGRewrite1/s/^/#/g' /etc/dmrgateway    ###    (to comment out)

 sudo sed -i '/^\[/h;G;/General/s/\(GWMode=\).*/\17/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(TGRewrite0=\).*/\1'"2,1000001,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 2/s/\(TGRewrite0=\).*/\1'"2,2000001,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 3/s/\(TGRewrite0=\).*/\1'"2,3000001,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(TGRewrite0=\).*/\1'"2,4000001,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(TGRewrite0=\).*/\1'"2,5000001,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(TGRewrite0=\).*/\1'"2,6000001,2,1,999999"'/m;P;d' /etc/dmrgateway

 sudo sed -i '/^\[/h;G;/General/s/\(GWMode=\).*/\17/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(TGRewrite1=\).*/\1'"2,1000001,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 2/s/\(TGRewrite1=\).*/\1'"2,2000001,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 3/s/\(TGRewrite1=\).*/\1'"2,3000001,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(TGRewrite1=\).*/\1'"2,4000001,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(TGRewrite1=\).*/\1'"2,5000001,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(TGRewrite1=\).*/\1'"2,6000001,2,1,999999"'/m;P;d' /etc/dmrgateway

 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(PCRewrite0=\).*/\1'"2,1000001,2,1,9999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 2/s/\(PCRewrite0=\).*/\1'"2,2000001,2,1,9999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 3/s/\(PCRewrite0=\).*/\1'"2,3000001,2,1,9999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(PCRewrite0=\).*/\1'"2,4000001,2,1,9999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(PCRewrite0=\).*/\1'"2,5000001,2,1,9999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(PCRewrite0=\).*/\1'"2,6000001,2,1,9999999"'/m;P;d' /etc/dmrgateway

 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(SrcRewrite0=\).*/\1'"2,1,2,$CALL,9999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 2/s/\(SrcRewrite0=\).*/\1'"2,1,2,$CALL,9999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 3/s/\(SrcRewrite0=\).*/\1'"2,1,2,$CALL,9999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(SrcRewrite0=\).*/\1'"2,1,2,$CALL,9999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(SrcRewrite0=\).*/\1'"2,1,2,$CALL,9999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(SrcRewrite0=\).*/\1'"2,1,2,$CALL,9999999"'/m;P;d' /etc/dmrgateway

}

sudo mount -o remount,rw /

if [ "$1" == "1" ]; then
	GWMode1
fi
if [ "$1" == "7" ]; then
	GWMode7
fi
if [ "$1" == "8" ]; then
	GWMode8
fi


sudo dmrgateway.service restart 

sleep 3
#	sudo reboot


