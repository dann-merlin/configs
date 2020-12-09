#!/bin/sh

# TODO install pistol

CFG_DIR=$(readlink -f $(dirname "$0"))

rootAccess=false

groups | grep -q -e 'sudo' -e 'wheel' && rootAccess=true

if $rootAccess; then
	sudo sh -c "mkdir -p /etc/profile.d && ln -sf $CFG_DIR/merlin.profile.sh /etc/profile.d"
else
	ln -sf "$CFG_DIR/merlin.profile.sh" "$HOME/.zshenv"
fi

. "$CFG_DIR/merlin.profile.sh"

# vim TODO nvim
ln -sf "$CFG_DIR/vimrc" "$HOME/.vimrc"

# tmux TODO tpm
mkdir -p "$HOME/.config/tmux"
ln -sf "$CFG_DIR/tmux.conf" "$HOME/.config/tmux/tmux.conf"

# zsh
mkdir -p "$ZDOTDIR"
ln -sf "$CFG_DIR/zshrc" "$ZDOTDIR/.zshrc"
ln -sf "$CFG_DIR/zsh_aliases" "$ZDOTDIR/zsh_aliases"

# polybar
rm -rf "$HOME/.config/polybar"
ln -sf "$CFG_DIR/polybar" "$HOME/.config/polybar"

# bspwm
rm -rf "$HOME/.config/bspwm"
ln -sf "$CFG_DIR/bspwm" "$HOME/.config/bspwm"

# sxhkd
rm -rf "$HOME/.config/sxhkd"
ln -sf "$CFG_DIR/sxhkd" "$HOME/.config/sxhkd"

# rofi
rm -rf "${XDG_CONFIG_HOME}/rofi"
mkdir -p "${XDG_CONFIG_HOME}/rofi"
ln -sf "$CFG_DIR/config.rasi" "${XDG_CONFIG_HOME}/rofi"
ln -sf "$CFG_DIR/hackerman.rasi" "${XDG_CONFIG_HOME}/rofi"

# vifm TODO install pistol
mkdir -p "$XDG_CONFIG_HOME/vifm/colors"
ln -sf "$CFG_DIR/merlin.vifm" "$XDG_CONFIG_HOME/vifm/colors"
ln -sf "$CFG_DIR/vifmrc" "$XDG_CONFIG_HOME/vifm"

mkdir -p "$HOME/bin"
ln -sf \
	"$CFG_DIR/scripts/setWallpaper" \
	"$CFG_DIR/scripts/messenger" \
	"$CFG_DIR/scripts/start_compositor" \
	"$CFG_DIR/scripts/setNotifications" \
	"$CFG_DIR/scripts/setStatusbar" \
	"$CFG_DIR/scripts/moveDesktopsToMonitors.sh" \
	"$HOME/bin/"

# Install zsh plugins
. "$CFG_DIR/install.zsh.plugins.sh"

# Build st
cd "$CFG_DIR"
curl 'https://dl.suckless.org/st/st-0.8.4.tar.gz' > 'st-0.8.4.tar.gz' && \
tar xzf 'st-0.8.4.tar.gz' && \
cd "st-0.8.4/" && \
"$CFG_DIR/st_patches/patch_st" .

if $rootAccess; then
	sudo make install
else
	make && mv st "$HOME/bin"
fi

cd -
rm -rf "st-0.8.4/" "st-0.8.4.tar.gz"
