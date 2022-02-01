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
   Yes ) sudo apt update;sudo apt install curl -y; break;;
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
   Yes ) sudo apt update;sudo apt install git -y; break;;
    No ) break;;
 esac
done
fi

echo "\n\ninstall zsh-sudo?\n\n"
  select yn in "Yes" "No"; do
    case $yn in
      Yes ) export zsudo=true;;
      No ) export zsudo=false;;
    esac
  done

echo "\n\ninstall fast-syntax-highlighting?\n\n"
  select yn in "Yes" "No"; do
    case $yn in
      Yes ) export fsyn=true;;
      No ) export fsyn=false;;
    esac
  done

if [ "$zsudo" = true ] ; then
    if [ -d "/usr/share/zsh-sudo" ] 
    then
        echo "Directory zsh-sudo already exists, will not install zsh-sudo.\n\n" 
        echo "run:"
        echo "\ncurl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh --output /usr/share/zsh-sudo/sudo.plugin.zsh\n"
        echo "to manually install it instead\n\n"
    else
        sudo mkdir /usr/share/zsh-sudo
        curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh --output /usr/share/zsh-sudo/sudo.plugin.zsh
    fi

elif [ "$zsudo" = false ] ; then
else 
  echo "how did u break my script :/"
  echo "\n\n"
fi

if [ "$fsyn" = true ] ; then
    if [ -d "/usr/share/fast-syntax-highlighting" ] 
    then
        echo "Directory fast-syntax-highlighting already exists, will not install fast-syntax-highlighting.\n\n" 
        echo "run:"
        echo "git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git /usr/share/fast-syntax-highlighting"
        echo "to manually install it instead\n\n"
    else
        sudo mkdir /usr/share/fast-syntax-highlighting
        
        if which git >/dev/null; then
        git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git /usr/share/fast-syntax-highlighting
        else
        echo "git is not installed on this system and required to install this file.\n\n"
        echo "Do you wish to install git now?\n\n"
          select yn in "Yes" "No"; do
            case $yn in
            Yes ) sudo apt update;sudo apt install git -y;git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git /usr/share/fast-syntax-highlighting; break;;
            No ) echo "run:";echo "git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git /usr/share/fast-syntax-highlighting";echo "to manually install it instead\n\n";break;;
          esac
        done
      fi
    fi
elif [ "$fsyn" = false ] ; then
else 
  echo "how did u break my script :/"
  echo "\n\n"
fi

echo "install zshrc. continue?\n\n"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) curl https://raw.githubusercontent.com/Joseos123/shell/main/linux/zshrc --output ~/.zshrc; break;;
    No ) echo "run:\n";echo "curl https://raw.githubusercontent.com/Joseos123/shell/main/linux/zshrc --output ~/.zshrc\n";echo "to manually install it instead\n\n";break;;
  esac
done

echo "install starship?/n/n"
  select yn in "Yes" "No"; do
    case $yn in
      Yes ) export istar=true;;
      No ) export istar=false;;
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
        Yes ) export starc=true;;
        No ) export starc=false;;
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
else
fi

echo "are you on torrentbox?"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) export torrentbox=true;;
    No ) export torrentbox=false;;
  esac
done

if [ "$torrentbox" = true ] ; then
    echo "\n\ndo you want the flexget config file?"
    select yn in "Yes" "No"; do
    case $yn in
      Yes ) export flexgetfile=true;;
      No ) export flexgetfile=false;;
    esac
    done
    
    echo "\n\ndo you want the transmission config file?"
    select yn in "Yes" "No"; do
    case $yn in
      Yes ) export transmissionfile=true;;
      No ) export transmissionfile=false;;
    esac
     done
else
fi

if [ "$flexgetfile" = true ] ; then
    echo "\n\nuse this command in the flexget server. we use /etc/flexget \n\n"
    echo "\ncurl https://raw.githubusercontent.com/Joseos123/shell/main/linux/config.yml --output config.yml\n"
else
fi

if [ "$transmissionfile" = true ] ; then
    echo "\n\nuse this command in the flexget server. we use ~/.config/transmission-daemon/ \n\n"
    echo "\ncurl https://raw.githubusercontent.com/Joseos123/shell/main/linux/transmission%20settings.json --output settings.json\n"
else
fi

echo "\n\nhave a nice day!"