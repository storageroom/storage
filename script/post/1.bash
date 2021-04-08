git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay -S --noconfirm zsh-theme-powerlevel10k-git
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc