#!/bin/bash
############################################################
#  This script will automate the process of                #
#  Installing and Configureing The DMRGateway-4 	   #
#							   #
#  VE3RD                                      2020/10/04   #
############################################################
set -o errexit
set -o pipefail
sudo mount -o remount,rw /

if [ "$1" ]; then
  HS="$1"
else
  HS=9
fi
ver="20200512"
export NCURSES_NO_UTF8_ACS=1

if [ -f ~/.dialog ]; then
 j=1
else
 sudo dialog --create-rc ~/.dialogrc
fi
#use_colors = ON
#screen_color = (WHITE,BLUE,ON)
#title_color = (YELLOW,RED,ON)
sed -i '/use_colors = /c\use_colors = ON' ~/.dialogrc
sed -i '/screen_color = /c\screen_color = (WHITE,BLUE,ON)' ~/.dialogrc
sed -i '/title_color = /c\title_color = (YELLOW,RED,ON)' ~/.dialogrc

echo -e '\e[1;44m'
clear

sudo mount -o remount,rw /
homedir=/home/pi-star/DMRGateway-4/
curdir=$(pwd)
clear
echo " "
echo " If this is a fresh DMRGateway install - Select Item 1 to create and/or edit a  password file."
echo " "
echo " Item 2 will overwrite the /etc/dmrgateway file with a default vsersion"
echo " and proceed with a limited configuration"
echo " "
echo " Item 2 will Compile (If Required) and Install the Binary File"
echo " "
sleep 3


function GetSetInfo()
{
echo "Running GetSetInfo"
CALL=$(sed -nr "/^\[General\]/ { :l /^Callsign[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
ID=$(sed -nr "/^\[General\]/ { :l /^Id[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
LAT=$(sed -nr "/^\[Info\]/ { :l /^Latitude[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
LON=$(sed -nr "/^\[Info\]/ { :l /^Longitude[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
RXF=$(sed -nr "/^\[Info\]/ { :l /^RXFrequency[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
TXF=$(sed -nr "/^\[Info\]/ { :l /^TXFrequency[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
LOC=$(sed -nr "/^\[Info\]/ { :l /^Location[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
DES=$(sed -nr "/^\[Info\]/ { :l /^Description[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)
#URL=$(sed -nr "/^\[Info\]/ { :l /^URL[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)

 sudo sed -i '/^\[/h;G;/Info/s/\(Latitude=\).*/\1'"$LAT"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/Info/s/\(Id=\).*/\1'"$LON"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/Info/s/\(RXFrequency=\).*/\1'"$RXF"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/Info/s/\(TXFrequency=\).*/\1'"$TXF"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/Info/s/\(Location=\).*/\1'"$LOC"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/Info/s/\(Descriptiony=\).*/\1'"$DES"'/m;P;d' /etc/dmrgateway

URL1="HTTP:\/\/www.qrz.com\/db\/$CALL"
echo "URL $URL1"

 sudo sed -i '/^\[/h;G;/Info/s/\(URL=\).*/\1'"$URL1"'/m;P;d' /etc/dmrgateway
#sed 's#http://www.find.com/page#http://www.replace.com/page#g' /etc/dmrgateway
}

function SetNetworks()
{
echo "Running SetNetworks"

#[DMR Network 1]
SRCRW="2,9990,2,$CALL,1"
Id1="$ID""$HS""1"
 PWD=$(sed -nr "/^\[DMR Network 1\]/ { :l /^PWD[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $pwf)
 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(URL=\).*/\1'"$Id"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(Password=\).*/\1'"$PWD"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(SRCRewrite=\).*/\1'"$SRCRW"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(Id=\).*/\1'"$Id1"'/m;P;d' /etc/dmrgateway
 

#[DMR Network 2]
Id1="$ID""$HS""2"
 PWD=$(sed -nr "/^\[DMR Network 2\]/ { :l /^PWD[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $pwf)
 sudo sed -i '/^\[/h;G;/DMR Network 2/s/\(URL=\).*/\1'"$Id"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 2/s/\(Password=\).*/\1'"$PWD"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 2/s/\(SRCRewrite=\).*/\1'"$SRCRW"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 2/s/\(Id=\).*/\1'"$Id1"'/m;P;d' /etc/dmrgateway

#[DMR Network 3]
Id1="$ID""$HS""3"
 PWD=$(sed -nr "/^\[DMR Network 3\]/ { :l /^PWD[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $pwf)
 sudo sed -i '/^\[/h;G;/DMR Network 3/s/\(URL=\).*/\1'"$Id"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 3/s/\(Password=\).*/\1'"$PWD"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 3/s/\(SRCRewrite=\).*/\1'"$SRCRW"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 3/s/\(Id=\).*/\1'"$Id1"'/m;P;d' /etc/dmrgateway


#[DMR Network 4]
Id1="$ID""$HS""4"
 PWD=$(sed -nr "/^\[DMR Network 4\]/ { :l /^PWD[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $pwf)
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(URL=\).*/\1'"$Id"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(Password=\).*/\1'"$PWD"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(SRCRewrite=\).*/\1'"$SRCRW"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(Id=\).*/\1'"$Id1"'/m;P;d' /etc/dmrgateway


#[DMR Network 5]
Id1="$ID""$HS""5"
 PWD=$(sed -nr "/^\[DMR Network 5\]/ { :l /^PWD[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $pwf)
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(URL=\).*/\1'"$Id"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(Password=\).*/\1'"$PWD"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(SRCRewrite=\).*/\1'"$SRCRW"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(Id=\).*/\1'"$Id1"'/m;P;d' /etc/dmrgateway


#[DMR Network 6]
Id1="$ID""$HS""6"
 PWD=$(sed -nr "/^\[DMR Network 6\]/ { :l /^PWD[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $pwf)
 sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(URL=\).*/\1'"$Id"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(Password=\).*/\1'"$PWD"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(SRCRewrite=\).*/\1'"$SCRW"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(Id=\).*/\1'"$Id1"'/m;P;d' /etc/dmrgateway


}
service_handle() {
        # What do we want do to?
        doWhat=${1}
        systemctl ${doWhat} dmrgateway.timer > /dev/null 2>&1
        systemctl ${doWhat} dmrgateway.service > /dev/null 2>&1
        systemctl ${doWhat} mmdvmhost.service > /dev/null 2>&1 && sleep 2 > /dev/null 2>&1
}


function CopyBin()
{
echo "Running CopyBin"

if [ ! -f /home/pi-star/DMRGateway-4/DMRGateway ]; then
	sudo mount -o remount,rw /
	echo "Stopping DMRGateway and MMDVMHost"
	make clean
	echo "Compiling DMRGateway Files"
	make
	service_handle stop
	echo "Copying Binary file to /usr/local/bin/"
	sudo cp /home/pi-star/DMRGateway-4/DMRGateway /usr/local/bin/
	echo "Starting DMRGateway and MMDVMHost"
	service_handle start

else
	sudo mount -o remount,rw /
	echo "Stopping DMRGateway and MMDVMHost"
	service_handle stop
	echo "Copying Binary file to /usr/local/bin/"
	sudo cp /home/pi-star/DMRGateway-4/DMRGateway /usr/local/bin/
	echo "Starting DMRGateway and MMDVMHost"
	service_handle start
fi
}

function Menu
{
	echo "Stopping DMRGateway and MMDVMHost"
HEIGHT=15
WIDTH=60
CHOICE_HEIGHT=7
BACKTITLE="This SCRIPT will Install the DMRGateway-4 by VE3RD"
TITLE="Main Menu - DMRGateway Options"
MENU="Select your Installation Mode"

OPTIONS=(1 "Edit the DMRGateway Password File" 
	 2 "Install DMRGateway & Update /etc/dmrgateway"
         3 "Install DMRGateway NO Config File Update"
	 4 "Quit")


CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
echo -e '\e[1;44m'


case $CHOICE in
        1)
            echo "Editing The DMRGateway Pasword File"		
		nano /etc/dmrgwpass
		Menu
            ;;
         2)   echo "You Chose to Install DMRGateway with an update to /etc/dmrgateway"
		sudo cp /home/pi-star/DMRGateway-4/DMRGateway.ini /etc/dmrgateway
		GetSetInfo
		SetNetworks
		CopyBin

            ;;
         3)
            echo "You Chose to Install DMRGateway - No Config File Update"		
		CopyBin
            ;;
	4)   echo " You Chose to Quit"
		exit
	;;
esac
}
sudo mount -o remount,rw /
pwf=/etc/dmrgwpass
if [ ! /etc/dmrgwpass ]; then
 sudo cp /home/pi-star/DMRGateway-4/DMRGateway.pw /etc/dmrgwpass
fi
Menu
echo -e '\e[1;40m'

dmrgateway.service restart ; mmdvmhost.service restart

sleep 3
#	sudo reboot


