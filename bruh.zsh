#!/usr/bin/zsh

# install apps (TBC)
#echo "Please select the applications you would like to install."

# check os
echo "what operating system are on on?"
echo "note that linux refers to a debian derivative"
echo "arch, gentoo, red hat and other non debian derivatives"
echo "WILL NOT WORK"
select os in "Linux" "Macos"; do
  case $os in
   Linux ) os=Linux; break;;
   Macos ) os=Macos; break;;
 esac
done

# offer to install homebrew if on mac
if [ "$os" = Macos ] ; then
  echo "would you like to install homebrew?"
  select yn in "Yes" "No"; do
  case $yn in
   Yes ) installhomebrew=true; break;;
    No ) installhomebrew=false; break;;
  esac
  done
else
fi

# if not on mac, offer to install standard packages
if [ "$os" = Linux ] ; then
  echo "would you like to install standard packages?"
  select yn in "Yes" "No"; do
  case $yn in
   Yes ) aptinstallpackages=true; break;;
    No ) aptinstallpackages=false; break;;
  esac
  done
else
aptinstallpackages=false
fi

if [ "$aptinstallpackages" = true ] ; then
  echo "would you like to install torrentbox/server packages or standard?"
  select bruh in "Server" "Standard"; do
  case $bruh in
   Server ) aptinstallwhatpackages=server; break;;
   Standard ) aptinstallwhatpackages=standard; break;;
  esac
  done
else
fi

if [ "$aptinstallpackages" = server ] ; then
    sudo apt update
    sudo apt dist-upgrade -y
    sudo apt upgrade -y
    echo "deb [trusted=yes] https://deb.jesec.io/ devel main" | sudo tee /etc/apt/sources.list.d/jesec.list
    apt update
    sudo apt install -y transmission-daemon zsh xsel xclip sshfs neofetch micro nano mc mediainfo cron coreutils python3 python3-pip python3-venv flood linux-firmware
    sudo systemctl stop transmission-daemon

elif [ "$aptinstallpackages" = standard ] ; then
    sudo apt update
    sudo apt dist-upgrade -y
    sudo apt upgrade -y
    sudo apt install -y zsh xsel xclip neofetch micro nano mc linux-firmware python3 python3-pip
else
fi

if [ "$installhomebrew" = true ] ; then
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
homebrewinstalled=true
else
homebrewinstalled=false
fi

# Offer to install Brewfile
if [ "$homebrewinstalled" = true ] ; then
  echo "Do you want to install from Brewfile?\nnote that the brewfile is mine lol\nyouhavebeenwarned\n\n"
  select yn in "Yes" "No"; do
  case $yn in
   Yes ) brewfileinstall=true; break;;
    No ) brewfileinstall=false; break;;
  esac
  done
else
brewfileinstall=false
fi

if [ "$brewfileinstall" = true ] ; then
curl https://raw.githubusercontent.com/Joseos123/shell/main/macos/Brewfile --output Brewfile
brew bundle
else
fi

# install zsh plugins, zshrc and starship.toml
if which curl >/dev/null; then
curlisinstalled=true
else
curlisinstalled=false
echo "\n\ncurl is not installed on this system and is needed for later steps."
echo "Do you wish to install curl now?\n\n"
select yn in "Yes" "No"; do
  case $yn in
   Yes ) installcurl=true; break;;
    No ) installcurl=false; break;;
 esac
done
fi

if [ "$curlisinstalled" = false ] ; then
  if [ "$installcurl" = true ] ; then
    if [ "$os" = Linux ] ; then
      sudo apt update;sudo apt install curl -y
    else
    fi

    if [ "$os" = Macos ] ; then
      echo "why tf do u not have curl bro ur on a MAC\n\n"
    else
    fi
  else
    echo "curl is needed for install"
    exit
  fi
else
fi

if which git >/dev/null; then
gitinstalled=true
else
echo "git is not installed on this system and we reccomend you install it."
echo "Do you wish to install git now?\n\n"
select yn in "Yes" "No"; do
  case $yn in
   Yes ) installgit=true; break;;
    No ) installgit=false; break;;
 esac
done
fi

SMH () { 
if [ "$os" = Linux ] ; then
      sudo apt update;sudo apt install git -y
    else
    fi

if [ "$os" = Macos ] ; then
      echo "would you like to install macos cli tools?\n\n"
      select yn in "Yes" "No"; do
      case $yn in
          Yes ) xcode-select --install; break;;
          No ) isstupid=true;break;;
        esac
      done
      
        if [ "$isstupid" = true ] ; then
          if [ "$homebrewinstalled" = true ] ; then
          dumbbruh=true
          else
          echo "proceeding without installing git"
          gitinstalled=false
          fi
        else
        fi

        if [ "$dumbbruh" = true ] ; then
          echo "would you then perhaps to install git via brew?"
          select yn in "Yes" "No"; do
          case $yn in
              Yes ) brew install git; break;;
              No ) break;;
            esac
          done
        else
        fi
    else
    fi
}

if [ "$installgit" = true ] ; then
SMH
else
fi

echo "\n\ninstall zsh-sudo?\n\n"
  select yn in "Yes" "No"; do
    case $yn in
      Yes ) zsudo=true; break;;
      No ) zsudo=false; break;;
    esac
  done

echo "\n\ninstall fast-syntax-highlighting?\n\n"
  select yn in "Yes" "No"; do
    case $yn in
      Yes ) fsyn=true; break;;
      No ) fsyn=false; break;;
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
        
        if [ "$gitinstalled" = true ] ; then
        git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git /usr/share/fast-syntax-highlighting
        else
        echo "git is not installed on this system and required to install this file.\n\n"
        echo "Do you wish to install git now?\n\n"
          select yn in "Yes" "No"; do
            case $yn in
            Yes ) SMH; break;;
            No ) echo "run:";echo "\ngit clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git /usr/share/fast-syntax-highlighting";echo "to manually install it instead\n\n";break;;
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
      Yes ) istar=true; break;;
      No ) istar=false; break;;
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
        Yes ) starc=true; break;;
        No ) starc=false; break;;
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
    Yes ) torrentbox=true; break;;
    No ) torrentbox=false; break;;
  esac
done

if [ "$torrentbox" = true ] ; then
    echo "\n\ndo you want the flexget config file?"
    select yn in "Yes" "No"; do
    case $yn in
      Yes ) flexgetfile=true; break;;
      No ) flexgetfile=false; break;;
    esac
    done
    
    echo "\n\ndo you want the transmission config file?"
    select yn in "Yes" "No"; do
    case $yn in
      Yes ) transmissionfile=true; break;;
      No ) transmissionfile=false; break;;
    esac
     done

    echo "\n\ndo you want the fstab file?"
    select yn in "Yes" "No"; do
    case $yn in
      Yes ) fstabfile=true; break;;
      No ) fstabfile=false; break;;
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

if [ "$fstabfile" = true ] ; then
    echo "\n\nshove this into your fstab:\n\n"
    curl https://raw.githubusercontent.com/Joseos123/shell/main/linux/fstab
else
fi

echo "\n\nhave a nice day!"