# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/vagrant/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Clear aliases
alias clear="clear && printf '\e[3J'"
alias c="clear && printf '\e[3J'"
alias cl="clear && printf '\e[3J'"
alias cle="clear && printf '\e[3J'"
alias clea="clear && printf '\e[3J'"

# Sudo aliases
alias please='sudo'
alias s='sudo'
alias sd='sudo'
alias sud='sudo'

# Auto-sudo applications
alias tidal='sudo tidal-dl'
alias mc='sudo mc'
alias micro='sudo micro'
alias sn='sudo micro'
alias sm='sudo micro'
alias n='micro'
alias m='micro'
alias ch='sudo chmod'
alias fastchmod='sudo chmod -R 777'
alias fc='sudo chmod -R 777'
alias pipupgrade="for i in $(pip list -o | awk 'NR > 2 {print $1}'); do sudo pip install -U $i; done"
alias pacman="yay"
alias upgrade="sudo apt update;sudo apt upgrade"
