#!/bin/sh

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
mkdir -p "${XDG_CONFIG_HOME}/tmux/plugins"
ln -sf "$CFG_DIR/tmux.conf" "${XDG_CONFIG_HOME}/tmux/tmux.conf"
git clone "https://github.com/tmux-plugins/tpm" "${XDG_CONFIG_HOME}/tmux/plugins/tpm"

# zsh
mkdir -p "$ZDOTDIR"
ln -sf "$CFG_DIR/zshrc" "$ZDOTDIR/.zshrc"
ln -sf "$CFG_DIR/zsh_aliases" "$ZDOTDIR/zsh_aliases"

# polybar
rm -rf "${XDG_CONFIG_HOME}/polybar"
ln -sf "$CFG_DIR/polybar" "${XDG_CONFIG_HOME}/polybar"

# bspwm
rm -rf "${XDG_CONFIG_HOME}/bspwm"
ln -sf "$CFG_DIR/bspwm" "${XDG_CONFIG_HOME}/bspwm"

# sxhkd
rm -rf "${XDG_CONFIG_HOME}/sxhkd"
ln -sf "$CFG_DIR/sxhkd" "${XDG_CONFIG_HOME}/sxhkd"

# rofi
rm -rf "${XDG_CONFIG_HOME}/rofi"
mkdir -p "${XDG_CONFIG_HOME}/rofi"
ln -sf "$CFG_DIR/rofi/config.rasi" "${XDG_CONFIG_HOME}/rofi"
ln -sf "$CFG_DIR/rofi/hackerman.rasi" "${XDG_CONFIG_HOME}/rofi"
ln -sf "$CFG_DIR/rofi/tempus_nord.rasi" "${XDG_CONFIG_HOME}/rofi"

mkdir -p "$HOME/bin"
ln -sf \
	"$CFG_DIR/scripts/setWallpaper" \
	"$CFG_DIR/scripts/messenger" \
	"$CFG_DIR/scripts/start_compositor" \
	"$CFG_DIR/scripts/setNotifications" \
	"$CFG_DIR/scripts/setStatusbar" \
	"$CFG_DIR/scripts/moveDesktopsToMonitors.sh" \
	"$HOME/bin/"

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

# Enable systemd services

sudo systemctl enable --now NetworkManager
sudo systemctl enable ly.service

# install vundle if necessary
if ! [ -d "${HOME}/.vim/bundle/Vundle.vim" ]; then
	mkdir -p "${HOME}/.vim/bundle/"
	git clone 'https://github.com/VundleVim/Vundle.vim.git' "${HOME}/.vim/bundle/Vundle.vim"
	vim +PluginInstall +PluginClean +qall
	cd "${HOME}/.vim/bundle/vim-hexokinase/"
	make hexokinase
	cd -
	cd "${HOME}/.vim/bundle/youcompleteme"
	./install.py --all
	cd -
fi
