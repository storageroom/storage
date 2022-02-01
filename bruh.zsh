#!/usr/bin/zsh

# install apps (TBC)
#echo "Please select the applications you would like to install."

# install zsh plugins, zshrc and starship.toml

if which curl >/dev/null; then
else
echo "\n\ncurl is not installed on this system and is needed for later steps."
echo "Do you wish to install curl now?\n\n"
select yn in "Yes" "No"; do
  case $yn in
   Yes ) sudo apt install curl -y; break;;
    No ) break;;
 esac
done
fi

if which git >/dev/null; then
else
echo "git is not installed on this system and we reccomend you install it."
echo "Do you wish to install git now?\n\n"
select yn in "Yes" "No"; do
  case $yn in
   Yes ) sudo apt install git -y; break;;
    No ) break;;
 esac
done
fi

if [ -d "/usr/share/zsh-sudo" ] 
then
    echo "Directory zsh-sudo already exists, will not install zsh-sudo.\n\n" 
    echo "run:"
    echo "curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh --output /usr/share/zsh-sudo/sudo.plugin.zsh"
    echo "to manually install it instead"
else
    sudo mkdir /usr/share/zsh-sudo
    curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh --output /usr/share/zsh-sudo/sudo.plugin.zsh
fi

if [ -d "/usr/share/fast-syntax-highlighting" ] 
then
    echo "Directory fast-syntax-highlighting already exists, will not install fast-syntax-highlighting.\n\n" 
    echo "run:"
    echo "git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git /usr/share/fast-syntax-highlighting"
    echo "to manually install it instead"
else
    sudo mkdir /usr/share/fast-syntax-highlighting
    
    if which git >/dev/null; then
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git /usr/share/fast-syntax-highlighting
    else
    echo "git is not installed on this system and required to install this file.\n\n"
    echo "Do you wish to install git now?\n\n"
      select yn in "Yes" "No"; do
        case $yn in
         Yes ) sudo apt install git -y;git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git /usr/share/fast-syntax-highlighting; break;;
          No ) echo "run:";echo "git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git /usr/share/fast-syntax-highlighting";echo "to manually install it instead\n\n";break;;
       esac
      done
    fi
fi

echo "install zshrc. continue?\n\n"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) curl https://raw.githubusercontent.com/Joseos123/shell/main/linux/zshrc --output ~/.zshrc; break;;
    No ) echo "run:\n";echo "curl https://raw.githubusercontent.com/Joseos123/shell/main/linux/zshrc --output ~/.zshrc\n";echo "to manually install it instead\n\n";break;;
  esac
done

echo "if u need it:"
echo "\ncurl https://raw.githubusercontent.com/Joseos123/shell/main/linux/config.yml --output config.yml\n"
echo "your welcome, myself"
echo "\n\n"

echo "install starship?/n/n"
  select yn in "Yes" "No"; do
    case $yn in
      Yes ) istar=true;;
      No ) istar=false;;
    esac
  done

if [ "$istar" = true ] ; then
  stari=true
  sh -c "$(curl -fsSL https://starship.rs/install.sh)"

elif [ "$istar" = false ] ; then
  stari=false
  echo "run:\n"
  echo 'sh -c "$(curl -fsSL https://starship.rs/install.sh)"\n'
  echo "to manually install it instead\n\n"

else 
  echo "how did u break my script :/"
  echo "\n\n"
fi

if [ "$stari" = true ] ; then
  echo "install starship config. continue?\n\n"
    select yn in "Yes" "No"; do
      case $yn in
        Yes ) starc=true;;
        No ) starc=false;;
      esac
    done
else
  starc=false
fi

if [ "$starc" = true ] ; then
    if [ -d "~/.config" ] 
    then
        curl https://raw.githubusercontent.com/Joseos123/shell/main/macos/starship.toml --output ~/.config/starship.toml
    else
        mkdir ~/.config
        curl https://raw.githubusercontent.com/Joseos123/shell/main/macos/starship.toml --output ~/.config/starship.toml
    fi

elif [ "$starc" = false ] ; then
      echo "have a nice day!"
fi
