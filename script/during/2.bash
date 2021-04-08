systemctl enable networkmanager
echo "grub-install /dev/sdX"
echo "DO NOT PUT NUMBER AFTER X"
echo "grub-mkconfig -o /boot/grub/grub.cfg"
echo "do passwd now"