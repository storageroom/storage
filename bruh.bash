#!/bin/bash

# Colour Definitions
RED="\e[1;31m"
REDU="\e[1;31;4m"
GREEN="\e[1;32m"
PINK="\e[1;35m"
NC='\033[0m'

# check os
printf "\n${GREEN}what operating system are on on?${NC}\n"
select os in "Debian" "Macos"; do
	case $os in
	Debian)
		os=Debian
		arch=Linux
		break
		;;
	Macos)
		os=Macos
		break
		;;
	Arch)
		os=Arch
		arch=Linux
		break
		;;
	esac
done

# offer to install homebrew if on mac
if [ "$os" = Macos ]; then
	printf "${GREEN}would you like to install homebrew?${NC}\n"
	select yn in "Yes" "No"; do
		case $yn in
		Yes)
			installhomebrew=true
			break
			;;
		No)
			installhomebrew=false
			break
			;;
		esac
	done
fi

# if not on mac, offer to install standard packages
if [ "$arch" = Linux ]; then
	printf "${GREEN}would you like to install standard packages?${NC}\n"
	select yn in "Yes" "No"; do
		case $yn in
		Yes)
			installpackages=true
			yessus=yes
			break
			;;
		No)
			installpackages=false
			break
			;;
		esac
	done
else
	installpackages=false
fi

MINIMAL() {
	if [ "$os" = Debian ] && [ "$wgetisinstalled" = true ]; then
		wget https://raw.githubusercontent.com/Joseos123/shell/main/linux/packagelist/minimal
		sudo apt update
		sudo apt dist-upgrade -y
		sudo apt upgrade -y
		sudo apt install $(grep -o '^[^#]*' minimal)
		rm minimal
		pleaseinstallwgetnow=false

	elif [ "$os" = Arch ] && [ "$wgetisinstalled" = true ]; then
		wget https://raw.githubusercontent.com/Joseos123/shell/main/linux/packagelist/minimal
		yes | sudo pacman -Syu
		yes | sudo pacman -S --needed git base-devel
		git clone https://aur.archlinux.org/yay.git
		cd yay || printf "${RED}cd into yay failed, aborting${NC}"
		yes | makepkg -si
		cd || printf "${RED}cd into home dir failed, aborting${NC}"
		sudo rm -R yay
		yay -S $(grep -o '^[^#]*' server)
		rm server
		pleaseinstallwgetnow=false
	fi
}

SERVER() {
	if [ "$os" = Debian ] && [ "$wgetisinstalled" = true ]; then
		wget https://raw.githubusercontent.com/Joseos123/shell/main/linux/packagelist/server
		sudo apt update
		sudo apt dist-upgrade -y
		sudo apt upgrade -y
		echo "deb [trusted=yes] https://deb.jesec.io/ devel main" | sudo tee /etc/apt/sources.list.d/jesec.list
		apt update
		sudo apt install $(grep -o '^[^#]*' server)
		sudo systemctl stop transmission-daemon
		rm server
		pleaseinstallwgetnow=false

	elif [ "$os" = Arch ] && [ "$wgetisinstalled" = true ]; then
		printf "${RED} Note that server on arch is experimental and most likely will not work"
		sleep 10
		wget https://raw.githubusercontent.com/Joseos123/shell/main/linux/packagelist/server
		yes | sudo pacman -Syu
		yes | sudo pacman -S --needed git base-devel
		git clone https://aur.archlinux.org/yay.git
		cd yay || printf "${RED}cd into yay failed, aborting${NC}"
		yes | makepkg -si
		cd || printf "${RED}cd into home dir failed, aborting${NC}"
		sudo rm -R yay
		yay -S nodejs-flood
		yay -S $(grep -o '^[^#]*' server)
		rm server
		sudo systemctl stop transmission-daemon
		pleaseinstallwgetnow=false
	fi
}

if [ "$installpackages" = true ]; then
	printf "${GREEN}would you like to install server packages or minimal?${NC}\n"
	select bruh in "Server" "Minimal"; do
		case $bruh in
		Server)
			installwhatpackages=Server
			break
			;;
		Minimal)
			installwhatpackages=Minimal
			break
			;;
		esac
	done
fi

if which wget >/dev/null; then
	wgetisinstalled=true
else
	wgetisinstalled=false
fi

if [ "$installwhatpackages" = Server ] && [ "$wgetisinstalled" = true ]; then
	SERVER

elif [ "$installwhatpackages" = Minimal ] && [ "$wgetisinstalled" = true ]; then
	MINIMAL

elif [ "$arch" = Linux ] && [ "$wgetisinstalled" = false ]; then
	printf "${RED}wget is not installed on this system and needed to grab the packagelist.${NC}"
	printf "${GREEN}Install wget now?${NC}"
	printf "\n\n"
	select yn in "Yes" "No"; do
		case $yn in
		Yes)
			pleaseinstallwgetnow=true
			break
			;;
		No)
			pleaseinstallwgetnow=false
			break
			;;
		esac
	done
fi

if [ "$pleaseinstallwgetnow" = true ] && [ "$os" = Debian ]; then
	sudo apt update
	sudo apt install wget
	wgetisinstalled=true

	if [ "$installwhatpackages" = Server ]; then
		SERVER
	elif [ "$installwhatpackages" = Minimal ]; then
		MINIMAL
	fi

elif [ "$pleaseinstallwgetnow" = true ] && [ "$os" = Arch ]; then
	yes | sudo pacman -Syu
	yes | sudo pacman -S wget
	wgetisinstalled=true

	if [ "$installwhatpackages" = Server ]; then
		SERVER
	elif [ "$installwhatpackages" = Minimal ]; then
		MINIMAL
	fi
fi

if [ "$installhomebrew" = true ]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	homebrewinstalled=true
else
	homebrewinstalled=false
fi

# Offer to install Brewfile
if [ "$homebrewinstalled" = true ]; then
	printf "${GREEN}Do you want to install from Brewfile?${NC}\n\n"
	select yn in "Yes" "No"; do
		case $yn in
		Yes)
			brewfileinstall=true
			break
			;;
		No)
			brewfileinstall=false
			break
			;;
		esac
	done
else
	brewfileinstall=false
fi

if [ "$brewfileinstall" = true ]; then
	curl https://raw.githubusercontent.com/Joseos123/shell/main/macos/Brewfile --output Brewfile
	brew bundle
fi

# install zsh plugins, zshrc and starship.toml
if which curl >/dev/null; then
	curlisinstalled=true
else
	curlisinstalled=false
	printf "${RED}\n\ncurl is not installed on this system and is needed for later steps.${NC}"
	printf "${GREEN}Do you wish to install curl now?${NC}\n\n"
	select yn in "Yes" "No"; do
		case $yn in
		Yes)
			installcurl=true
			break
			;;
		No)
			installcurl=false
			break
			;;
		esac
	done
fi

if [ "$curlisinstalled" = false ]; then
	if [ "$installcurl" = true ]; then
		if [ "$os" = Debian ]; then
			sudo apt update
			sudo apt install curl -y

		elif [ "$os" = Arch ]; then
			yes | sudo pacman -Syu
			yes | sudo pacman -S curl

		elif [ "$os" = Macos ]; then
			printf "${RED}why tf do u not have curl bro ur on a MAC${NC}\n"
			printf "${RED}but fr tho...${NC}"
			exit
		fi
	else
		printf "${RED}curl is needed for install${NC}"
		exit
	fi
fi

# offer to install git
if which git >/dev/null; then
	gitinstalled=true
else
	printf "${RED}git is not installed on this system and we reccomend you install it.${NC}"
	printf "${GREEN}Do you wish to install git now?${NC}\n\n"
	select yn in "Yes" "No"; do
		case $yn in
		Yes)
			installgit=true
			break
			;;
		No)
			installgit=false
			break
			;;
		esac
	done
fi

SMH() {
	if [ "$os" = Debian ]; then
		sudo apt update
		sudo apt install git -y

	elif [ "$os" = Arch ]; then
		yes | sudo pacman -Syu
		yes | sudo pacman -S git
	fi

	if [ "$os" = Macos ]; then
		printf "${GREEN}would you like to install macos cli tools?${NC}\n\n"
		select yn in "Yes" "No"; do
			case $yn in
			Yes)
				clitoolsinstalled=true
				xcode-select --install
				break
				;;
			No)
				clitoolsinstalled=false
				isstupid=true
				break
				;;
			esac
		done

		if [ "$isstupid" = true ]; then
			if [ "$homebrewinstalled" = true ]; then
				dumbbruh=true
			else
				printf "proceeding without installing git"
				gitinstalled=false
			fi
		fi

		if [ "$dumbbruh" = true ]; then
			printf "${GREEN}would you then perhaps to install git via brew?${NC}"
			select yn in "Yes" "No"; do
				case $yn in
				Yes)
					brew install git
					break
					;;
				No) break ;;
				esac
			done
		fi
	fi
}

if [ "$installgit" = true ]; then
	SMH
	gitinstalled=true
fi

# offer to install hr
# on mac systems, hr will be installed through brewfile
HRINSTALL() {
	if which make >/dev/null; then
		makeisinstalled=true
	else
		makeisinstalled=false
		printf "${RED}\n\nmake is not installed on this system and is needed for this step${NC}"
		printf "${GREEN}Do you wish to install make now?${NC}\n\n"
		select yn in "Yes" "No"; do
			case $yn in
			Yes)
				if [ "$os" = Debian ]; then
					sudo apt update
					sudo apt install -y build-essential
				elif [ "$os" = Arch ]; then
					yes | sudo pacman -Syu
					yes | sudo pacman -S base-devel
				fi
				makeisinstalled=true
				break
				;;
			No) break ;;
			esac
		done
	fi

	if [ "$makeisinstalled" = true ]; then
		git clone https://github.com/LuRsT/hr.git
		cd hr || exit
		lmaolmaolmao="PREFIX=/usr/share"
		sed -i "4s/.*/$lmaolmaolmao/" Makefile
		sudo make install
		printf "${GREEN}Install of hr done${NC}"
		printf "${GREEN}removing source files${NC}"
		sleep 5
		sudo rm -R hr
	fi

}

if [ "$arch" = Linux ]; then
	if which hr >/dev/null; then
		printf "${RED}hr is already installed on this system,${NC}\n"
		printf "${RED}or there is a conflict with the command hr${NC}\n"
		printf "${RED}aborting install of hr \n\n"
		sleep 5
	else
		printf "${GREEN}install hr?${NC}"
		select yn in "Yes" "No"; do
			case $yn in
			Yes)
				HRINSTALL
				break
				;;
			No) break ;;
			esac
		done
	fi
fi

printf "\n\n${GREEN}install zsh-sudo?${NC}\n\n"
select yn in "Yes" "No"; do
	case $yn in
	Yes)
		zsudo=true
		break
		;;
	No)
		zsudo=false
		break
		;;
	esac
done

printf "\n\n${GREEN}install fast-syntax-highlighting?${NC}\n\n"
select yn in "Yes" "No"; do
	case $yn in
	Yes)
		fsyn=true
		break
		;;
	No)
		fsyn=false
		break
		;;
	esac
done

if [ "$zsudo" = true ]; then
	if [ -d "/usr/share/zsh-sudo" ]; then
		printf "${RED}Directory zsh-sudo already exists, will not install zsh-sudo.${NC}\n\n"
		printf "${REDU}run:${NC}"
		printf "\ncurl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh --output /usr/share/zsh-sudo/sudo.plugin.zsh\n"
		printf "${REDU}to manually install it instead${NC}\n\n"
	else
		sudo mkdir /usr/share/zsh-sudo
		sudo curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh --output /usr/share/zsh-sudo/sudo.plugin.zsh
	fi
fi

if [ "$fsyn" = true ]; then
	if [ -d "/usr/share/fast-syntax-highlighting" ]; then
		printf "${RED}Directory fast-syntax-highlighting already exists, will not install fast-syntax-highlighting.${NC}\n\n"
		printf "${REDU}run:${NC}"
		printf "git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git /usr/share/fast-syntax-highlighting"
		printf "${REDU}to manually install it instead${NC}\n\n"
	else
		sudo mkdir /usr/share/fast-syntax-highlighting

		if [ "$gitinstalled" = true ]; then
			sudo git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git /usr/share/fast-syntax-highlighting
		else
			printf "${RED}git is not installed on this system and required to install this file.${NC}\n\n"
			printf "${GREEN}Do you wish to install git now?${NC}\n\n"
			select yn in "Yes" "No"; do
				case $yn in
				Yes)
					SMH
					break
					;;
				No)
					printf "${REDU}run:${NC}"
					printf "\ngit clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git /usr/share/fast-syntax-highlighting"
					printf "${REDU}to manually install it instead${NC}\n\n"
					break
					;;
				esac
			done
		fi
	fi
fi

printf "${GREEN}install zshrc. continue?${NC}\n\n"
select yn in "Yes" "No"; do
	case $yn in
	Yes)
		curl https://raw.githubusercontent.com/Joseos123/shell/main/linux/zshrc --output ~/.zshrc
		break
		;;
	No)
		printf "${REDU}run:${NC}\n"
		printf "curl https://raw.githubusercontent.com/Joseos123/shell/main/linux/zshrc --output ~/.zshrc\n"
		printf "${REDU}to manually install it instead${NC}\n\n"
		break
		;;
	esac
done

printf "${GREEN}install starship?${NC}\n\n"
select yn in "Yes" "No"; do
	case $yn in
	Yes)
		istar=true
		break
		;;
	No)
		istar=false
		break
		;;
	esac
done

if [ "$istar" = true ]; then
	stari=true
	sh -c "$(curl -fsSL https://starship.rs/install.sh)"

elif [ "$istar" = false ]; then
	stari=false
	printf "${REDU}run:${NC}\n"
	echo "sh -c '$(curl -fsSL https://starship.rs/install.sh)'"
	printf "\n${REDU}to manually install it instead${NC}\n\n"
fi

if [ "$stari" = true ]; then
	printf "${GREEN}install starship config. continue?${NC}\n\n"
	select yn in "Yes" "No"; do
		case $yn in
		Yes)
			starc=true
			break
			;;
		No)
			starc=false
			break
			;;
		esac
	done
else
	starc=false
fi

if [ "$starc" = true ]; then
	if [ -d "$HOME/.config" ]; then
		curl https://raw.githubusercontent.com/Joseos123/shell/main/macos/starship.toml --output $HOME/.config/starship.toml
	else
		sudo mkdir $HOME/.config
		curl https://raw.githubusercontent.com/Joseos123/shell/main/macos/starship.toml --output $HOME/.config/starship.toml
	fi
fi

printf "${PINK}are you on torrentbox?${NC}"
select yn in "Yes" "No"; do
	case $yn in
	Yes)
		torrentbox=true
		break
		;;
	No)
		torrentbox=false
		break
		;;
	esac
done

if [ "$torrentbox" = true ]; then
	printf "\n\n${GREEN}do you want the flexget config file?${NC}"
	select yn in "Yes" "No"; do
		case $yn in
		Yes)
			flexgetfile=true
			break
			;;
		No)
			flexgetfile=false
			break
			;;
		esac
	done

	printf "\n\n${GREEN}do you want the transmission config file?${NC}"
	select yn in "Yes" "No"; do
		case $yn in
		Yes)
			transmissionfile=true
			break
			;;
		No)
			transmissionfile=false
			break
			;;
		esac
	done

	printf "\n\n${GREEN}do you want the fstab file?${NC}"
	select yn in "Yes" "No"; do
		case $yn in
		Yes)
			fstabfile=true
			break
			;;
		No)
			fstabfile=false
			break
			;;
		esac
	done
fi

if [ "$flexgetfile" = true ]; then
	printf "\n\n${GREEN}use this command in the flexget server.${NC} ${REDU}we use /etc/flexget${NC}\n\n"
	printf "\ncurl https://raw.githubusercontent.com/Joseos123/shell/main/linux/config.yml --output config.yml\n"
fi

if [ "$transmissionfile" = true ]; then
	printf "\n\n${GREEN}use this command in the flexget server.${NC} ${REDU}we use ~/.config/transmission-daemon/${NC}\n\n"
	printf "\ncurl https://raw.githubusercontent.com/Joseos123/shell/main/linux/settings.json --output settings.json\n"
fi

if [ "$fstabfile" = true ]; then
	printf "\n\n${GREEN}shove this into your fstab:${NC}\n\n"
	printf "\ncurl https://raw.githubusercontent.com/Joseos123/shell/main/linux/fstab\n"
fi

if [ "$yessus" = yes ]; then
	printf "${GREEN}Would you like to make zsh the default shell?${NC}"
	select yn in "Yes" "No"; do
		case $yn in
		Yes)
			chsh -s $(which zsh)
			break
			;;
		No) break ;;
		esac
	done
fi

# offer to install iterm2 shell integration
if [ "$os" = Macos ]; then
	printf "${GREEN}Would you like to install iterm2 shell integration?${NC}"
	select yn in "Yes" "No"; do
		case $yn in
		Yes)
			curl -L https://iterm2.com/shell_integration/install_shell_integration.sh | zsh
			break
			;;
		No) break ;;
		esac
	done
fi

# offer to install cli tools as last step
# this is as cli tools take awhile to install and often requires the user to restart their system
if [ "$os" = Macos ] && [ "$clitoolsinstalled" = false ]; then
	xcode-select --install
	printf "\n\nhave a nice day!"
else
	printf "\n\nhave a nice day!"
fi
