#!/bin/sh

rootAccess=false
groups | grep -q -e 'sudo' -e 'wheel' && rootAccess=true

plugins="zsh-autosuggestions zsh-you-should-use"

if $rootAccess; then
	if which yay >/dev/null 2>/dev/null; then
		yay -Sy
		for plugin in ${plugins}; do
			pacman -Qq "${plugin}" ||
			yay -S "${plugin}"
		done
	else
		if which apt-get >/dev/null 2>/dev/null; then
			sudo apt-get install zsh-autosuggestions
		fi
		mkdir -p /usr/share/zsh/plugins/zsh-you-should-use/
		sudo sh -c 'curl -s https://raw.githubusercontent.com/MichaelAquilina/zsh-you-should-use/master/you-should-use.plugin.zsh > /usr/share/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh'
	fi
else
	: # TODO install without root if not installed
fi

