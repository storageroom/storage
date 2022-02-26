#!/bin/bash

# ASCII Colors
RED="\e[1;31m"
REDU="\e[1;31;4m"
GREEN="\e[1;32m"
PINK="\e[1;35m"
CYAN="\e[1;36m"
NC='\033[0m'

printf "${GREEN}Install homebrew?${NC}\n"
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

if [ "$installhomebrew" = true ]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	homebrewinstalled=true
else
	homebrewinstalled=false
fi

# Offer to install Brewfile
if [ "$homebrewinstalled" = true ]; then
	printf "${GREEN}Install from Brewfile?${NC}\n\n"
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
	curl https://raw.githubusercontent.com/storageroom/storage/main/macos/Brewfile --output Brewfile
	brew bundle
	yessus=yes
fi

# offer to install git
if which git >/dev/null; then
	gitinstalled=true
else
	printf "${RED}\nGit is not installed on this system.\n${NC}"
	printf "${GREEN}Install git now?${NC}\n\n"
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
	printf "${GREEN}Would you like to install macos cli tools?${NC}\n\n"
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
}

if [ "$installgit" = true ]; then
	SMH
	gitinstalled=true
fi

# install zsh plugins, zshrc and starship.toml
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
		curl https://raw.githubusercontent.com/storageroom/storage/main/universal/zshrc --output ~/.zshrc
		break
		;;
	No)
		printf "${REDU}run:${NC}\n"
		printf "curl https://raw.githubusercontent.com/storageroom/storage/main/universal/zshrc --output ~/.zshrc\n"
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
		curl https://raw.githubusercontent.com/storageroom/storage/main/universal/starship.toml --output $HOME/.config/starship.toml
	else
		sudo mkdir .config
		curl https://raw.githubusercontent.com/storageroom/storage/main/universal/starship.toml --output .config/starship.toml
	fi
fi

if [ "$yessus" = yes ]; then
	printf "${GREEN}Would you like to make zsh the default shell?${NC}"
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
	printf "\n\n${PINK}have${GREEN} a ${RED}nice${CYAN} day!${NC}"
else
	printf "\n\n${PINK}have${GREEN} a ${RED}nice${CYAN} day!${NC}"
fi
