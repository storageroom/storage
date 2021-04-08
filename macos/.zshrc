# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/powerlevel10k/powerlevel10k.zsh-theme

eval $(thefuck --alias)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Super
alias upgrade="brew update;brew upgrade"

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
alias pipupgrade="s -H pip_upgrade_outdated -3 -p"
alias checkrain="sudo /private/etc/racoon/9ec5be08a8790d5d9a080166dfccc82da0997ce5b487df69273ca6e2643f164fa3d1824800f4df2a07d5a2082178d30592663ad5e4548c89a72c2b12b47d5fda"

# SSH Stuffs
alias pi='ssh pi@pimusicplayer'
alias pilocal='ssh pi@PiMusicplayer.local'

alias iphone="ssh mobile@joshys-iphone"

# Autocorrect
alias shit='fuck'
alias python='python3'
alias google='googler'

# Vagrant
alias vmstatus="vagrant global-status"

alias archup="vagrant up 28e5289;vagrant ssh 28e5289"
alias arch="vagrant ssh 28e5289"
alias archdown="vagrant halt 28e5289"

alias ubuntuup="vagrant up 742b363;vagrant ssh 742b363"
alias ubuntu=";vagrant ssh 742b363"
alias ubuntudown="vagrant halt 742b363"

# ASCII Art fun
alias shrek="/Users/joshy/shrek.txt"



# MISC
export PATH="/usr/local/sbin:$PATH"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
