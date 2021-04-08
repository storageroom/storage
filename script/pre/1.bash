read -p "optional: curl -L archfi.sf.net/archfi > archfi" -t 3;
echo;
read -p "starting" -t 3;
timedatectl set-ntp true;
lsblk;
clear;
read -p "cfdisk /dev/sdX" -t 2;
echo;
read -p "remember to select 'dos'" -t 2;
echo;
read -p "make one 128M partition as /dev/sdX1, remember to set boot flag" -t 2;
echo;
read -p "/dev/sdX2 will be remaining free space" -t 2;
echo;
read -p "write, and quit" -t 2