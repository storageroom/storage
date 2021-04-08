pacman -S --nonfirm networkmanager grub mc neofetch python python-pip python-wheel xclip xsel zsh
read -t 8
systemctl enable networkmanager
read -p -t 3
echo "grub-install /dev/sdX"
echo "DO NOT PUT NUMBER AFTER X"