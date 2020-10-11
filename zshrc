export PATH="/usr/local/bin:$PATH"

if which nvim 2>&1 >/dev/null; then
	alias vim='nvim'
	export EDITOR=nvim
elif which vim 2>&1 >/dev/null; then
	export EDITOR=vim
else
	export EDITOR=nano
fi

autoload -U colors && colors

# Show all 256 colors with color number
function spectrum_ls() {
	for code in {000..255}; do
		print -P -- "$code: %{$FG[$code]%}$ZSH_SPECTRUM_TEXT%{$reset_color%}"
	done
}

# autocompletion
fpath=($HOME/.config/zsh/zshfuncs $fpath)
autoload -U compinit

setopt COMPLETE_ALIASES

# Prettier autocompletion
zstyle ':completion:*' menu select
#zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
#zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
#zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|*' 'l:|=* r:|=*'

autoload -U promptinit
promptinit
getCodeSymbol() {
	# ✔✘
	[ "$?" = "0" ] && echo "%F{#070}%f" || echo "%F{#A00}%f"
}

function preexec() {
	timer=$(($(date +%s%0N )/1000000))
}

function _timer_precmd() {
	if [ $timer ]; then
		now=$(( $(date +%s%0N )/1000000 ))
		elapsed=$(($now-$timer))
		_exec_time="${elapsed}ms "
		unset timer
	fi
}

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_STATESEPERATOR=' '
source "${HOME}/configs/scripts/git-prompt.sh"
__git_prompt=''
function _git_prompt() {
	tmp=$(printf '%s' "$(__git_ps1 "%s" )")
	branch=$(echo $tmp | awk '{print $1}')
	[ "$branch" = '' ] && __git_prompt='' && return
	branch=" $branch "
	stats=$(echo $tmp | awk '{print $2}')
	stash_txt=''; untracked_txt=''; __git_col='#70ce12'; #'#35ce12'
	echo $stats | grep -q '\$' && stash_txt='♻ '
	echo $stats | grep -q '%' && untracked_txt='👁 '
	echo $stats | grep -q '\*' && __git_col='#ceb512'
	__git_prompt="%F{white}%K{$__git_col}%F{#000000}%B$branch$stash_txt$untracked_txt%b%F{$__git_col}%K{white}%f%k"
}

setopt PROMPT_SUBST

PS1='%F{black}%B%K{blue}    %F{black}%K{blue}%B%n@%m%b%F{blue}█%K{white}%F{white}%K{black}%K{black}%B %D{%a %b %d} %D{%I:%M:%S%P} %F{black}%K{white}%K{cyan}%F{white} %F{black}${_exec_time}%k%F{cyan}
%}%F{blue}%K{black}%B %~ %b%K{white}%F{black}${__git_prompt}%F{white}%k '

RPS1='%F{white}%f%K{white}$(getCodeSymbol)%k%F{white}%f'


HISTSIZE=500000
SAVEHIST=$HISTSIZE
setopt hist_ignore_space
setopt inc_append_history
setopt share_history

setopt extendedglob

zmodload zsh/complist
compinit
_comp_options+=(globdots)


# vi mode
bindkey -v
export KEYTIMEOUT=1

# Enable searching through history
bindkey '^R' history-incremental-pattern-search-backward

# Edit line in vim buffer ctrl-v
autoload edit-command-line; zle -N edit-command-line
bindkey '^v' edit-command-line
bindkey -a '^[l' clear-screen
bindkey '^[l' clear-screen
# Enter vim buffer from normal mode
autoload -U edit-command-line && zle -N edit-command-line && bindkey -M vicmd "^v" edit-command-line

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'left' vi-backward-char
bindkey -M menuselect 'down' vi-down-line-or-history
bindkey -M menuselect 'up' vi-up-line-or-history
bindkey -M menuselect 'right' vi-forward-char
# Fix backspace bug when switching modes
bindkey '^[[3~' delete-char
bindkey -a '^[[3~' delete-char
bindkey -v '^?' backward-delete-char
# bindkey '^k' up-line-or-search
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[k' up-line-or-beginning-search
bindkey '^[j' down-line-or-beginning-search

# Change cursor with support for inside/outside tmux
function _set_cursor() {
	if [[ $TMUX = '' ]]; then
		echo -ne $1
	else
		echo -ne "\ePtmux;\e\e$1\e\\"
	fi
}

function _set_block_cursor() { _set_cursor '\e[2 q' }
function _set_beam_cursor() { _set_cursor '\e[6 q' }

# Change cursor shape for different vi modes.
function zle-keymap-select {
	if [[ ${KEYMAP} == vicmd ]] ||
		[[ $1 = 'block' ]]; then
		_set_block_cursor
	elif [[ ${KEYMAP} == main ]] ||
		[[ ${KEYMAP} == viins ]] ||
		[[ ${KEYMAP} = '' ]] ||
		[[ $1 = 'beam' ]]; then
		_set_beam_cursor
	fi
}
zle -N zle-keymap-select

# ci", ci', ci`, di", etc
autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
	for c in {a,i}{\',\",\`}; do
		bindkey -M $m $c select-quoted
	done
done

# ci{, ci(, ci<, di{, etc
autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
	for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
		bindkey -M $m $c select-bracketed
	done
done

zle-line-init() {
	zle -K viins
	_set_beam_cursor
}
zle -N zle-line-init
_set_beam_cursor
precmd_functions+=( _set_beam_cursor )
precmd_functions+=( _git_prompt )
precmd_functions+=( _timer_precmd )

# fzf instead of menuselect - Not sure wether I like this
# source "$HOME/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"
# bindkey '^T' toggle-fzf-tab

# Autocomplete - I don't think I want this
# source "$HOME/.config/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh"

# source "$HOME/.config/zsh/plugins/hackerquotes/hackerquotes.plugin.zsh"
# source "$HOME/.config/zsh/plugins/linus-rants/linus-rants.plugin.zsh"

# Suggest aliases for commands
source /usr/share/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh

# Search repos for programs that can't be found
source /usr/share/doc/pkgfile/command-not-found.zsh 2>/dev/null

# autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#77845e'
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=True
ZSH_AUTOSUGGEST_HISTORY_IGNORE='cd *'
bindkey -v '^ ' autosuggest-accept
bindkey -v '^A' autosuggest-toggle

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

setopt AUTO_CD
setopt INTERACTIVE_COMMENTS

MOUNTS="/run/media/$USER"

[ -f "${ZDOTDIR}/zsh_aliases" ] && source "${ZDOTDIR}/zsh_aliases"
[ -f "$HOME/.config/zsh/local_aliases" ] && source "$HOME/.config/zsh/local_aliases"

# Load zsh-syntax-highlighting
typeset -A ZSH_HIGHLIGHT_STYLES
# Defined aliases
ZSH_HIGHLIGHT_STYLES[alias]='fg=#00FF7B,bold'
# Defined suffix aliases
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#00FF7B,bold'
# Defined global aliases
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#00FF7B,bold'
# Defined Functions
ZSH_HIGHLIGHT_STYLES[function]='fg=#00FF7B,bold'
# Doesn't exist
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#CC0000,bold'
# if, for, while, do, done, etc.
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#FFC405,bold'
# history-expansion
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#FFC405,bold,underline'
# pwd, which, cd
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#C8FF05,bold'
# normal command, find, firefox, etc.
ZSH_HIGHLIGHT_STYLES[command]='fg=#37A500,bold'
# sudo, builtin, noglob
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#9DC489,bold'
# ; && || etc.
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#FFFFFF'
# Hashed commands? I don't know what this is.
# ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#FFFFFF'
# paths
ZSH_HIGHLIGHT_STYLES[path]='fg=#7FE9FF, bold'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#7FE9FF, bold'
# Seperators in paths
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#4C6AFF,bold'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#4C6AFF,bold'
# Globbing expressions like *.txt
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#FFFF32,bold,underline'
# Process/Command substitution
ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=#FF8C19,bold'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#FF19A3,bold'
ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=#FF8C19,bold'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#FF19A3,bold'
# Arithmetic expressions (doesn't work for me)
ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]='fg=#82F2EA'
# single hyphen options
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#B2FFBA'
# double hyphen options
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#B2E5FF'
# backticks
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#F6FFB2'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=#CC0000,bold'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#EA32FF,bold'
# single/double/dollar quotes
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#FFB2D4'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#CC0000,bold'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#FFB2D4'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#CC0000,bold'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#C77FFF'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#CC0000,bold'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#54FF00,bold'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#DDB2FF,bold'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#FFCCE2,bold'
# Assign a value like x=5
ZSH_HIGHLIGHT_STYLES[assign]='fg=#FFDD32,bold'
# Redirect streams: >, <, etc.
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#BA0003,bold'
# Comments
ZSH_HIGHLIGHT_STYLES[comment]='fg=#7F7F7F,bold'
# Doesn't do anything for me
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#66E5FF,bold'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#66E5FF,bold'
