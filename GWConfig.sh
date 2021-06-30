#!/bin/bash
############################################################
#  This script will automate the process of                #
#  Installing and Configuring The DMRGateway-4 	           #
#							   #
#  VE3RD                                      2020/10/04   #
############################################################
set -o errexit
set -o pipefail
sudo mount -o remount,rw /

if [ ! "$1" ]; then
	echo "Please Provide  a HotSpot Number 0-9"
	echo "Syntax:   ./GWConfig.sh 4   to configure hotspot number 4"
	exit
fi
  
HS="$1"

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
echo " BASIC INSTRUCTIONS"
echo " "
echo " Item 1:"
echo "	This will create and/or edit a password file. (Required for a new Install)"
echo " "
echo " Item 2, 3 and 4 Common:"
echo " 	This will overwrite the /etc/dmrgateway file with a default version and"
echo " 	will compile a new Binary if required and"
echo "	will install the Binary DMRGateway File"
echo " "
echo " Item 2"
echo " 	will proceed with a limited configuration Using Basic Mode"
echo " 	In the Radio CPS use basic 31665 for 31665 on the Server"
echo "	Key on Tg 9001 to 9006 to select Network 1 to 6"
echo " "
echo " Item 3"
echo " 	will proceed with a limited configuration Using 8 Digit Translation Mode"
echo "	In the Radio CPS use 14031665 for TG 31665 on Network 4 etc."
echo " "
echo " Item 4"
echo " 	will proceed with a limited configuration Using 7 Digit Translation Mode"
echo "	In the Radio CPS use 4031665 for TG 31665 on Network 4 etc."
echo " "
echo " Item 5:"
echo "	will Ignore the existing Configuration File and"
echo "	will Compile a new Binary if Required and "
echo "	will Install the Binary File"
echo " "
echo " Item 6:"
echo "	will Restore the Original DMRGateway from /usr/local/bin/DMRGateway.orig"
echo "	( If it exists )"
echo " "
echo " CAUTION: This script can not possibly handle all users special situations"
echo " Use nano /etc/dmrgateway to check and configure what the script misses"
echo " "
#sleep 3
read -n 1 -s -r -p "Press any key to Continue"

function TurnOnGW()
{
 sudo sed -i '/^\[/h;G;/DMR Network/s/\(Address=\).*/\1'"127.0.0.1"'/m;P;d' /etc/mmdvmhost
}

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
sudo mount -o remount,rw /

 sudo sed -i '/^\[/h;G;/Info/s/\(Latitude=\).*/\1'"$LAT"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/Info/s/\(Longitude=\).*/\1'"$LON"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/Info/s/\(Id=\).*/\1'"$ID"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/Info/s/\(RXFrequency=\).*/\1'"$RXF"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/Info/s/\(TXFrequency=\).*/\1'"$TXF"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/Info/s/\(Location=\).*/\1'"$LOC"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/Info/s/\(Description=\).*/\1'"$DES"'/m;P;d' /etc/dmrgateway

SN=$(sed -nr "/^\[General\]/ { :l /^StartNet[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
if [ ! "$SN" ]; then 
sed -i 's/\[General\]/\[General\]\nStartNet=4/g' /etc/dmrgateway 
fi

GWM=$(sed -nr "/^\[General\]/ { :l /^GWMode[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/dmrgateway)
if [ ! "$GWM" ]; then 
sed -i 's/\[General\]/\[General\]\nGWMode=8/g' /etc/dmrgateway 
fi

URL1="HTTP:\/\/www.qrz.com\/db\/$CALL"
echo "URL $URL1"

 sudo sed -i '/^\[/h;G;/Info/s/\(URL=\).*/\1'"$URL1"'/m;P;d' /etc/dmrgateway
}

function SetNetworks()
{
echo "Running SetNetworks"

TurnOnGW

#[DMR Network 1]
SRCRW="2,9990,2,$CALL,1"
Id1="$ID""$HS""1"
 PWD=$(sed -nr "/^\[DMR Network 1\]/ { :l /^PWD[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $pwf)
 ENAB=$(sed -nr "/^\[DMR Network 1\]/ { :l /^Enabled[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $pwf)
 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(URL=\).*/\1'"$Id"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(Password=\).*/\1'"$PWD"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(SRCRewrite=\).*/\1'"$SRCRW"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(Id=\).*/\1'"$Id1"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(Enabled=\).*/\1'"$ENAB"'/m;P;d' /etc/dmrgateway
 

#[DMR Network 2]
Id1="$ID""$HS""2"
 PWD=$(sed -nr "/^\[DMR Network 2\]/ { :l /^PWD[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $pwf)
 ENAB=$(sed -nr "/^\[DMR Network 2\]/ { :l /^Enabled[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $pwf)
 sudo sed -i '/^\[/h;G;/DMR Network 2/s/\(URL=\).*/\1'"$Id"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 2/s/\(Password=\).*/\1'"$PWD"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 2/s/\(SRCRewrite=\).*/\1'"$SRCRW"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 2/s/\(Id=\).*/\1'"$Id1"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 2/s/\(Enabled=\).*/\1'"$ENAB"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/General/s/\(GWMode=\).*/\10/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/General/s/\(GWMode=\).*/\10/m;P;d' /etc/dmrgateway

#[DMR Network 3]
Id1="$ID""$HS""3"
 PWD=$(sed -nr "/^\[DMR Network 3\]/ { :l /^PWD[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $pwf)
 ENAB=$(sed -nr "/^\[DMR Network 3\]/ { :l /^Enabled[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $pwf)
 sudo sed -i '/^\[/h;G;/DMR Network 3/s/\(URL=\).*/\1'"$Id"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 3/s/\(Password=\).*/\1'"$PWD"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 3/s/\(SRCRewrite=\).*/\1'"$SRCRW"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 3/s/\(Id=\).*/\1'"$Id1"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 3/s/\(Enabled=\).*/\1'"$ENAB"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/General/s/\(GWMode=\).*/\18/m;P;d' /etc/dmrgateway


#[DMR Network 4]
Id1="$ID""$HS""4"
 PWD=$(sed -nr "/^\[DMR Network 4\]/ { :l /^PWD[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $pwf)
 ENAB=$(sed -nr "/^\[DMR Network 4\]/ { :l /^Enabled[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $pwf)
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(URL=\).*/\1'"$Id"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(Password=\).*/\1'"$PWD"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(SRCRewrite=\).*/\1'"$SRCRW"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(Id=\).*/\1'"$Id1"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(Enabled=\).*/\1'"$ENAB"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/General/s/\(GWMode=\).*/\17/m;P;d' /etc/dmrgateway


#[DMR Network 5]
Id1="$ID""$HS""5"
 PWD=$(sed -nr "/^\[DMR Network 5\]/ { :l /^PWD[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $pwf)
 ENAB=$(sed -nr "/^\[DMR Network 5\]/ { :l /^Enabled[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $pwf)
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(URL=\).*/\1'"$Id"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(Password=\).*/\1'"$PWD"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(SRCRewrite=\).*/\1'"$SRCRW"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(Id=\).*/\1'"$Id1"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(Enabled=\).*/\1'"$ENAB"'/m;P;d' /etc/dmrgateway


#[DMR Network 6]
Id1="$ID""$HS""6"
 PWD=$(sed -nr "/^\[DMR Network 6\]/ { :l /^PWD[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $pwf)
 ENAB=$(sed -nr "/^\[DMR Network 6\]/ { :l /^Enabled[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" $pwf)
 sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(URL=\).*/\1'"$Id"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(Password=\).*/\1'"$PWD"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(SRCRewrite=\).*/\1'"$SCRW"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(Id=\).*/\1'"$Id1"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(Enabled=\).*/\1'"$ENAB"'/m;P;d' /etc/dmrgateway


}
function GWMode0(){
 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(TGRewrite0=\).*/\1'"2,1,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 2/s/\(TGRewrite0=\).*/\1'"2,1,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 3/s/\(TGRewrite0=\).*/\1'"2,1,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(TGRewrite0=\).*/\1'"2,1,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(TGRewrite0=\).*/\1'"2,1,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(TGRewrite0=\).*/\1'"2,1,2,1,999999"'/m;P;d' /etc/dmrgateway

}

function GWMode8(){
 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(TGRewrite0=\).*/\1'"2,11000001,2,1,9999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 2/s/\(TGRewrite0=\).*/\1'"2,12000001,2,1,9999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 3/s/\(TGRewrite0=\).*/\1'"2,13000001,2,1,9999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(TGRewrite0=\).*/\1'"2,14000001,2,1,9999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(TGRewrite0=\).*/\1'"2,15000001,2,1,9999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(TGRewrite0=\).*/\1'"2,16000001,2,1,9999999"'/m;P;d' /etc/dmrgateway
}

function GWMode7(){
 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(TGRewrite0=\).*/\1'"2,1000001,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 2/s/\(TGRewrite0=\).*/\1'"2,2000001,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 3/s/\(TGRewrite0=\).*/\1'"2,3000001,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(TGRewrite0=\).*/\1'"2,4000001,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(TGRewrite0=\).*/\1'"2,5000001,2,1,999999"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(TGRewrite0=\).*/\1'"2,6000001,2,1,999999"'/m;P;d' /etc/dmrgateway

}

function Parrot8()
{
# Net1
 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(PCRewrite0=\).*/\1'"2,11009990,2,9990,1"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(SrcRewrite0=\).*/\1'"2,11009990,2,$CALL,1"'/m;P;d' /etc/dmrgateway
# Net4
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(PCRewrite0=\).*/\1'"2,14009990,2,9990,1"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(SrcRewrite0=\).*/\1'"2,14009990,2,$CALL,1"'/m;P;d' /etc/dmrgateway
# Net5
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(PCRewrite0=\).*/\1'"2,15009999,2,9999,1"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(SrcRewrite0=\).*/\1'"2,15009999,2,$CALL,1"'/m;P;d' /etc/dmrgateway
# Net 6
 sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(PCRewrite0=\).*/\1'"2,16009990,2,9990,1"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(SrcRewrite0=\).*/\1'"2,16009990,2,$CALL,1"'/m;P;d' /etc/dmrgateway
}

function Parrot7()
{
# Net1
 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(PCRewrite0=\).*/\1'"2,1009990,2,9990,1"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 1/s/\(SrcRewrite0=\).*/\1'"2,1009990,2,$CALL,1"'/m;P;d' /etc/dmrgateway
# Net4
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(PCRewrite0=\).*/\1'"2,4009990,2,9990,1"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 4/s/\(SrcRewrite0=\).*/\1'"2,4009990,2,$CALL,1"'/m;P;d' /etc/dmrgateway
# Net5
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(PCRewrite0=\).*/\1'"2,5009999,2,9999,1"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 5/s/\(SrcRewrite0=\).*/\1'"2,5009999,2,$CALL,1"'/m;P;d' /etc/dmrgateway
# Net 6
 sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(PCRewrite0=\).*/\1'"2,6009990,2,9990,1"'/m;P;d' /etc/dmrgateway
 sudo sed -i '/^\[/h;G;/DMR Network 6/s/\(SrcRewrite0=\).*/\1'"2,6009990,2,$CALL,1"'/m;P;d' /etc/dmrgateway
}


function CopyBin()
{
echo "Running CopyBin"

if [ ! -f /home/pi-star/DMRGateway-4/DMRGateway ]; then
	sudo mount -o remount,rw /
	make clean
	echo "Compiling DMRGateway Files"
	make
fi
	sudo mount -o remount,rw /
	echo "Stopping DMRGateway and MMDVMHost"
	sudo /home/pi-star/DMRGateway-4/binupdate.sh
}

function Menu
{
HEIGHT=15
WIDTH=90
CHOICE_HEIGHT=7
BACKTITLE="This SCRIPT will Install the DMRGateway-4 by VE3RD"
TITLE="Main Menu - DMRGateway Options"
MENU="Select your Installation Mode"

OPTIONS=(1 "Create/Edit the DMRGateway Password File" 
	 2 "Install DMRGateway & Update /etc/dmrgateway - Basic Mode"
	 3 "Install DMRGateway & Update /etc/dmrgateway - 8 Digit Translation Mode"
	 4 "Install DMRGateway & Update /etc/dmrgateway - 7 Digit Translation Mode"
         5 "Install DMRGateway NO Config File Update"
	 6 "Restore Original DMRGateway Binary File"
	 7  "Quit")


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
            echo "Editing The DMRGateway Password File"		
	    if [ !  -f /etc/dmrgwpass ]; then
		cp /home/pi-star/DMRGateway-4/DMRGateway.pw /etc/dmrgwpass
	   fi
		nano /etc/dmrgwpass
		Menu
            ;;
         2)   echo "You Chose to Install DMRGateway - Basic Mode"
		sudo cp /home/pi-star/DMRGateway-4/DMRGateway.ini /etc/dmrgateway
		GetSetInfo
		SetNetworks
		CopyBin
		GWMode0
            ;;
         3)   echo "You Chose to Install DMRGateway - 8 Digit Translation Mode"
		sudo cp /home/pi-star/DMRGateway-4/DMRGateway.ini /etc/dmrgateway
		GetSetInfo
		SetNetworks
		CopyBin
		GWMode8
		Parrot8
            ;;
         4)   echo "You Chose to Install DMRGateway - 7 Digit Translation Mode"
		sudo cp /home/pi-star/DMRGateway-4/DMRGateway.ini /etc/dmrgateway
		GetSetInfo
		SetNetworks
		CopyBin
		GWMode7
		Parrot7
            ;;
         5)
            echo "You Chose to Install DMRGateway - No Config File Update"		
		CopyBin
            ;;
	6)   echo " You Chose to Restore The Original DMRGateway"
		if [ -f /usr/local/bin/DMRGateway.orig ]; then
			sudo systemctl stop dmrgateway.service
			sudo cp /usr/local/bin/DMRGateway.orig /usr/local/bin/DMRGateway
			sudo systemctl start dmrgateway.service
			echo "Restore Complete"
		else
			echo "The DMRGateway original file does NOT exist"
			echo "Unable to Restore Original DMRGateway Binary File"
		fi
		;;
	7)   echo " You Chose to Quit"
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

#dmrgateway.service restart ; mmdvmhost.service restart

sleep 3
#	sudo reboot


