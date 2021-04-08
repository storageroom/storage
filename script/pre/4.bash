pacstrap /mnt base base-devel linux linux-firmware micro nano wget git
genfstab -U /mnt >> /mnt/etc/fstab
read -t 2
echo
echo "arch-chroot /mnt /bin/bash"