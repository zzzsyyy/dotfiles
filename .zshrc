autoload -Uz compinit
compinit

# Completion for kitty
kitty + complete setup zsh | source /dev/stdin

export EDITOR="nvim"
export VISUAL="nvim"
export OPENCV_LOG_LEVEL=ERROR
export LANG=zh_CN.UTF-8
export MOZ_ENABLE_WAYLAND=1
export STARSHIP_CONFIG=~/.config/starship/starship.toml
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

## quelques alias
alias ls="exa"
alias tree="exa -T -D "
alias zshconfig="sudo nvim ~/.zshrc"
alias n="neofetch"
alias setproxy="export ALL_PROXY=http://127.0.0.1:20171"
alias unsetproxy="unset ALL_PROXY"
alias setwechat="/opt/apps/com.qq.weixin.deepin/files/run.sh winecfg"
alias pl="plocate"
alias yay="paru"
alias clc="clear"
alias snvim="EDITOR=nvim sudoedit"

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Plugin history-search-multi-word loaded with investigating.
zinit load zdharma-continuum/history-search-multi-word

# Snippet
zinit snippet https://gist.githubusercontent.com/hightemp/5071909/raw/

zinit ice lucid wait='1'
zinit light skywind3000/z.lua

zinit ice lucid wait='0'
zinit light zdharma-continuum/fast-syntax-highlighting

zinit ice lucid wait="0" atload='_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

zinit ice lucid wait='0'
zinit light zsh-users/zsh-completions

eval "$(starship init zsh)"
