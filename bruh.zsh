#!/usr/bin/zsh
sudo mkdir /usr/share/zsh-sudo
curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh --output /usr/share/zsh-sudo/sudo.plugin.zsh
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git /usr/share/
curl https://github.com/Joseos123/shell/blob/main/linux/zshrc --output ~/.zshrc
curl https://raw.githubusercontent.com/Joseos123/shell/main/macos/starship.toml --output ~/.config/starship.toml
