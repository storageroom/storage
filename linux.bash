#!/bin/bash

# Colors
RED="\e[1;31m"
REDU="\e[1;31;4m"
GREEN="\e[1;32m"
PINK="\e[1;35m"
CYAN="\e[1;36m"
NC='\033[0m'

# check dist
printf "\n${GREEN}what distribution are on on?${NC}\n"
select os in "Debian" "Arch"; do
	case $os in
	Debian)
		os=Debian
		break
		;;
	Arch)
		os=Arch
		break
		;;
	esac
done

printf "${GREEN}would you like to install standard packages?${NC}\n"
select yn in "Yes" "No"; do
	case $yn in
	Yes)
		installwhatpackages=Minimal
		yessus=yes
		break
		;;
	No)
		break
		;;
	esac
done

MINIMAL() {
	if [ "$os" = Debian ] && [ "$wgetisinstalled" = true ]; then
		wget https://raw.githubusercontent.com/joshhhhyyyy/shell/main/linux/packagelist/minimal
		sudo apt update
		sudo apt dist-upgrade -y
		sudo apt upgrade -y
		sudo apt install -y $(grep -o '^[^#]*' minimal)
		rm minimal
		pleaseinstallwgetnow=false

	elif [ "$os" = Arch ] && [ "$wgetisinstalled" = true ]; then
		wget https://raw.githubusercontent.com/joshhhhyyyy/shell/main/linux/packagelist/minimal
		sudo pacman -Syu --noconfirm
		sudo pacman -S --noconfirm --needed git base-devel
		git clone https://aur.archlinux.org/yay.git
		cd yay || printf "${RED}cd into yay failed, aborting${NC}"
		makepkg -si --noconfirm
		cd || printf "${RED}cd into home dir failed, aborting${NC}"
		sudo rm -R yay
		yay -S --noconfirm $(grep -o '^[^#]*' server)
		sleep 5
		rm server
		sleep 5
		pleaseinstallwgetnow=false
	fi
}

if which which >/dev/null; then
	whichisinstalled=true
else
	whichisinstalled=false
fi

if [ "$whichisinstalled" = true ]; then
	if which wget >/dev/null; then
		wgetisinstalled=true
	else
		wgetisinstalled=false
	fi
fi

if [ "$whichisinstalled" = false ]; then
	printf "${RED}\nwhich is not installed on this system and needed to check for installed programs.\n${NC}"
	printf "${GREEN}Install which now?${NC}"
	printf "\n\n"
	select yn in "Yes" "No"; do
		case $yn in
		Yes)
			installwhich=true
			break
			;;
		No)
			installwhich=false
			break
			;;
		esac
	done
fi

if [ "$installwhich" = true ]; then
	if [ "$os" = Debian ]; then
		sudo apt update
		sudo apt install -y which
	elif [ "$os" = Arch ]; then
		sudo pacman -Sy
		sudo pacman -S --noconfirm which
	fi
fi

# offer to install git
if which git >/dev/null; then
	gitinstalled=true
else
	printf "${RED}\ngit is not installed on this system and we reccomend you install it.\n${NC}"
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
		sudo pacman -Sy
		sudo pacman -S --noconfirm git
	fi
}

if [ "$installgit" = true ]; then
	SMH
	gitinstalled=true
fi

if [ "$installwhatpackages" = Minimal ] && [ "$wgetisinstalled" = true ]; then
	MINIMAL

elif [ "$wgetisinstalled" = false ]; then
	printf "${RED}\nwget is not installed on this system and needed to grab the packagelist.\n${NC}"
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
	sudo apt install -y wget
	wgetisinstalled=true

	if [ "$installwhatpackages" = Minimal ]; then
		MINIMAL
	fi

elif [ "$pleaseinstallwgetnow" = true ] && [ "$os" = Arch ]; then
	sudo pacman -Sy
	sudo pacman -S --noconfirm wget
	wgetisinstalled=true

	if [ "$installwhatpackages" = Minimal ]; then
		MINIMAL
	fi
fi

# install zsh plugins, zshrc and starship.toml
# install curl
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
			sudo apt install -y curl

		elif [ "$os" = Arch ]; then
			sudo pacman -Sy
			sudo pacman -S --noconfirm curl
		fi
	else
		printf "${RED}curl is needed for install${NC}"
		exit
	fi
fi

# offer to install hr
HRINSTALL() {
	if which make >/dev/null; then
		makeisinstalled=true
	else
		makeisinstalled=false
		printf "${RED}\n\nmake is not installed on this system and is needed for this step${NC}"
		printf "${GREEN}\nDo you wish to install make now?${NC}\n\n"
		select yn in "Yes" "No"; do
			case $yn in
			Yes)
				if [ "$os" = Debian ]; then
					sudo apt update
					sudo apt install -y build-essential
				elif [ "$os" = Arch ]; then
					sudo pacman -Sy
					sudo pacman -S --noconfirm base-devel
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
		printf "${GREEN}\nInstall of hr done${NC}"
		printf "${GREEN}\nremoving source files${NC}"
		sleep 5
		rm -rf hr
	fi

}

if which hr >/dev/null; then
	printf "${RED}\nhr is already installed on this system,\n${NC}\n"
	printf "${RED}or there is a conflict with the command hr\n${NC}\n"
	printf "${RED}aborting install of hr \n\n"
	sleep 5
else
	printf "${GREEN}\ninstall hr?\n${NC}"
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
		curl https://raw.githubusercontent.com/joshhhhyyyy/shell/main/universal/zshrc --output ~/.zshrc
		break
		;;
	No)
		printf "${REDU}run:${NC}\n"
		printf "curl https://raw.githubusercontent.com/joshhhhyyyy/shell/main/universal/zshrc --output ~/.zshrc\n"
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
	if [ -d ".config" ]; then
		curl https://raw.githubusercontent.com/joshhhhyyyy/shell/main/universal/starship.toml --output $HOME/.config/starship.toml
	else
		sudo mkdir .config
		curl https://raw.githubusercontent.com/joshhhhyyyy/shell/main/universal/starship.toml --output .config/starship.toml
	fi
fi

if [ "$yessus" = yes ]; then
	printf "${GREEN}\n\nWould you like to make zsh the default shell?\n${NC}"
	select yn in "Yes" "No"; do
		case $yn in
		Yes)
			if [ "$(which zsh)" = "/bin/zsh" ]; then
				chsh -s /bin/zsh
			elif [ "$(which zsh)" = "/usr/bin/zsh" ]; then
				chsh -s /usr/bin/zsh
			else
				printf "\n\n${RED}zsh could not be found"
				printf "\ncontinue anyway with path of zsh as${NC}"
				printf "\n${REDU}/bin/zsh?\n${NC}"
				select yn in "Yes" "No"; do
					case $yn in
					Yes)
						chsh -s /bin/zsh
						break
						;;
					No)
						break
						;;
					esac
				done
			fi
			break
			;;
		No) break ;;
		esac
	done
fi

printf "\n\n${PINK}have${GREEN} a ${RED}nice${CYAN} day!${NC}"
