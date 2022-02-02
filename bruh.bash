#!/usr/bin/bash

# install apps (TBC)
#printf "Please select the applications you would like to install."

# check os
printf "what operating system are on on?\n"
printf "note that linux refers to a debian derivative\n"
printf "arch, gentoo, red hat and other non debian derivatives\n"
printf "WILL NOT WORK\n"
select os in "Linux" "Macos"; do
  case $os in
   Linux ) os=Linux; break;;
   Macos ) os=Macos; break;;
 esac
done

# offer to install homebrew if on mac
if [ "$os" = Macos ] ; then
  printf "would you like to install homebrew?\n"
  select yn in "Yes" "No"; do
  case $yn in
   Yes ) installhomebrew=true; break;;
    No ) installhomebrew=false; break;;
  esac
  done
fi

# if not on mac, offer to install standard packages
if [ "$os" = Linux ] ; then
  printf "would you like to install standard packages?\n"
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
  printf "would you like to install torrentbox/server packages or minimal?\n"
  select bruh in "Server" "Minimal"; do
  case $bruh in
   Server ) aptinstallwhatpackages=Server; break;;
   Minimal ) aptinstallwhatpackages=Minimal; break;;
  esac
  done
fi

if [ "$aptinstallwhatpackages" = Server ] ; then
    Server=$(curl https://raw.githubusercontent.com/Joseos123/shell/main/linux/packagelist/server)
    sudo apt update
    sudo apt dist-upgrade -y
    sudo apt upgrade -y
    printf "deb [trusted=yes] https://deb.jesec.io/ devel main" | sudo tee /etc/apt/sources.list.d/jesec.list
    apt update
    sudo apt install -y "$Server"
    sudo systemctl stop transmission-daemon

elif [ "$aptinstallwhatpackages" = Minimal ] ; then
    Minimal=$(curl https://raw.githubusercontent.com/Joseos123/shell/main/linux/packagelist/minimal)
    sudo apt update
    sudo apt dist-upgrade -y
    sudo apt upgrade -y
    sudo apt install -y "$Minimal"
fi

if [ "$installhomebrew" = true ] ; then
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
homebrewinstalled=true
else
homebrewinstalled=false
fi

# Offer to install Brewfile
if [ "$homebrewinstalled" = true ] ; then
  printf "Do you want to install from Brewfile?\nnote that the brewfile is mine lol\nyouhavebeenwarned\n\n"
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
fi

# install zsh plugins, zshrc and starship.toml
if which curl >/dev/null; then
curlisinstalled=true
else
curlisinstalled=false
printf "\n\ncurl is not installed on this system and is needed for later steps."
printf "Do you wish to install curl now?\n\n"
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
    fi

    if [ "$os" = Macos ] ; then
      printf "why tf do u not have curl bro ur on a MAC\n\n"
    fi
  else
    printf "curl is needed for install"
    exit
  fi
fi

if which git >/dev/null; then
gitinstalled=true
else
printf "git is not installed on this system and we reccomend you install it."
printf "Do you wish to install git now?\n\n"
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
    fi

if [ "$os" = Macos ] ; then
      printf "would you like to install macos cli tools?\n\n"
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
          printf "proceeding without installing git"
          gitinstalled=false
          fi
        fi

        if [ "$dumbbruh" = true ] ; then
          printf "would you then perhaps to install git via brew?"
          select yn in "Yes" "No"; do
          case $yn in
              Yes ) brew install git; break;;
              No ) break;;
            esac
          done
        fi
    fi
}

if [ "$installgit" = true ] ; then
SMH
gitinstalled=true
fi

printf "\n\ninstall zsh-sudo?\n\n"
  select yn in "Yes" "No"; do
    case $yn in
      Yes ) zsudo=true; break;;
      No ) zsudo=false; break;;
    esac
  done

printf "\n\ninstall fast-syntax-highlighting?\n\n"
  select yn in "Yes" "No"; do
    case $yn in
      Yes ) fsyn=true; break;;
      No ) fsyn=false; break;;
    esac
  done

if [ "$zsudo" = true ] ; then
    if [ -d "/usr/share/zsh-sudo" ] 
    then
        printf "Directory zsh-sudo already exists, will not install zsh-sudo.\n\n" 
        printf "run:"
        printf "\ncurl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh --output /usr/share/zsh-sudo/sudo.plugin.zsh\n"
        printf "to manually install it instead\n\n"
    else
        sudo mkdir /usr/share/zsh-sudo
        sudo curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh --output /usr/share/zsh-sudo/sudo.plugin.zsh
    fi

else 
  printf "how did u break my script :/"
  printf "\n\n"
fi

if [ "$fsyn" = true ] ; then
    if [ -d "/usr/share/fast-syntax-highlighting" ] 
    then
        printf "Directory fast-syntax-highlighting already exists, will not install fast-syntax-highlighting.\n\n" 
        printf "run:"
        printf "git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git /usr/share/fast-syntax-highlighting"
        printf "to manually install it instead\n\n"
    else
        sudo mkdir /usr/share/fast-syntax-highlighting
        
        if [ "$gitinstalled" = true ] ; then
        sudo git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git /usr/share/fast-syntax-highlighting
        else
        printf "git is not installed on this system and required to install this file.\n\n"
        printf "Do you wish to install git now?\n\n"
          select yn in "Yes" "No"; do
            case $yn in
            Yes ) SMH; break;;
            No ) printf "run:";printf "\ngit clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git /usr/share/fast-syntax-highlighting";printf "to manually install it instead\n\n";break;;
          esac
        done
      fi
    fi
else 
  printf "how did u break my script :/"
  printf "\n\n"
fi

printf "install zshrc. continue?\n\n"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) curl https://raw.githubusercontent.com/Joseos123/shell/main/linux/zshrc --output ~/.zshrc; break;;
    No ) printf "run:\n";printf "curl https://raw.githubusercontent.com/Joseos123/shell/main/linux/zshrc --output ~/.zshrc\n";printf "to manually install it instead\n\n";break;;
  esac
done

printf "install starship?/n/n"
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
  printf "run:\n"
  echo "sh -c '$(curl -fsSL https://starship.rs/install.sh)'"
  printf "\nto manually install it instead\n\n"

else 
  printf "how did u break my script :/"
  printf "\n\n"
fi

if [ "$stari" = true ] ; then
  printf "install starship config. continue?\n\n"
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
    if [ -d "$HOME/.config" ] 
    then
        curl https://raw.githubusercontent.com/Joseos123/shell/main/macos/starship.toml --output ~/.config/starship.toml
    else
        mkdir ~/.config
        curl https://raw.githubusercontent.com/Joseos123/shell/main/macos/starship.toml --output ~/.config/starship.toml
    fi
fi

printf "are you on torrentbox?"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) torrentbox=true; break;;
    No ) torrentbox=false; break;;
  esac
done

if [ "$torrentbox" = true ] ; then
    printf "\n\ndo you want the flexget config file?"
    select yn in "Yes" "No"; do
    case $yn in
      Yes ) flexgetfile=true; break;;
      No ) flexgetfile=false; break;;
    esac
    done
    
    printf "\n\ndo you want the transmission config file?"
    select yn in "Yes" "No"; do
    case $yn in
      Yes ) transmissionfile=true; break;;
      No ) transmissionfile=false; break;;
    esac
     done

    printf "\n\ndo you want the fstab file?"
    select yn in "Yes" "No"; do
    case $yn in
      Yes ) fstabfile=true; break;;
      No ) fstabfile=false; break;;
    esac
     done
fi

if [ "$flexgetfile" = true ] ; then
    printf "\n\nuse this command in the flexget server. we use /etc/flexget \n\n"
    printf "\ncurl https://raw.githubusercontent.com/Joseos123/shell/main/linux/config.yml --output config.yml\n"
fi

if [ "$transmissionfile" = true ] ; then
    printf "\n\nuse this command in the flexget server. we use ~/.config/transmission-daemon/ \n\n"
    printf "\ncurl https://raw.githubusercontent.com/Joseos123/shell/main/linux/settings.json --output settings.json\n"
fi

if [ "$fstabfile" = true ] ; then
    printf "\n\nshove this into your fstab:\n\n"
    curl https://raw.githubusercontent.com/Joseos123/shell/main/linux/fstab
fi

printf "\n\nhave a nice day!"