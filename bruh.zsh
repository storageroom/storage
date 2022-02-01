#!/usr/bin/zsh

# install apps (TBC)
#echo "Please select the applications you would like to install."

# install zsh plugins, zshrc and starship.toml

if which curl >/dev/null; then
break
else
echo "curl is not installed on this system and is needed for later steps."
echo "Do you wish to install curl now?"
select yn in "Yes" "No"; do
  case $yn in
   Yes ) sudo apt install curl -y; break;;
    No ) break;;
 esac
done
fi

if which git >/dev/null; then
break
else
echo "git is not installed on this system and we reccomend you install it."
echo "Do you wish to install git now?"
select yn in "Yes" "No"; do
  case $yn in
   Yes ) sudo apt install git -y; break;;
    No ) break;;
 esac
done
fi

if [ -d "/usr/share/zsh-sudo" ] 
then
    echo "Directory zsh-sudo already exists, will not install zsh-sudo." 
    echo "run:"
    echo "curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh --output /usr/share/zsh-sudo/sudo.plugin.zsh"
    echo "to manually install it instead"
else
    sudo mkdir /usr/share/zsh-sudo
    curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh --output /usr/share/zsh-sudo/sudo.plugin.zsh
fi

if [ -d "/usr/share/fast-syntax-highlighting" ] 
then
    echo "Directory fast-syntax-highlighting already exists, will not install fast-syntax-highlighting." 
    echo "run:"
    echo "git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git /usr/share/fast-syntax-highlighting"
    echo "to manually install it instead"
else
    sudo mkdir /usr/share/fast-syntax-highlighting
    
    if which git >/dev/null; then
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git /usr/share/fast-syntax-highlighting
    else
    echo "git is not installed on this system and required to install this file."
    echo "Do you wish to install git now?"
      select yn in "Yes" "No"; do
        case $yn in
         Yes ) sudo apt install git -y;git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git /usr/share/fast-syntax-highlighting; break;;
          No ) echo "run:";echo "git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git /usr/share/fast-syntax-highlighting";echo "to manually install it instead";;
       esac
      done
    fi
fi

echo "install zshrc. continue?"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) curl https://raw.githubusercontent.com/Joseos123/shell/main/linux/zshrc --output ~/.zshrc; break;;
    No ) break;;
  esac
done

echo "if u need it:"
echo "curl https://raw.githubusercontent.com/Joseos123/shell/main/linux/config.yml --output config.yml"
echo "your welcome, myself"

echo "install starship config. continue?"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) break;;
    No ) exit;;
  esac
done

if [ -d "~/.config" ] 
then
    curl https://raw.githubusercontent.com/Joseos123/shell/main/macos/starship.toml --output ~/.config/starship.toml
else
    mkdir ~/.config
    curl https://raw.githubusercontent.com/Joseos123/shell/main/macos/starship.toml --output ~/.config/starship.toml
fi
