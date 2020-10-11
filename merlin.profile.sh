
# Set our umask
umask 022

# Append our default paths
appendpath () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}

export XDG_CONFIG_DIR="$HOME/.config"
export XDG_CONFIG_HOME="$XDG_CONFIG_DIR"
export GTK_THEME="Adwaita:dark"
export configsdir="$HOME/configs"
export XDG_CACHE_DIR="$HOME/.cache"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export ZDOTDIR="$HOME/.config/zsh"
export HISTFILE="$XDG_CACHE_HOME/history"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
#export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority
export QEMU_AUDIO_DRV=pa
export GOPATH="$XDG_DATA_HOME/go"
export LESSHISTFILE='-'
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export ANDROID_SDK_HOME="$XDG_CONFIG_HOME/android"
export ADB_VENDOR_KEY="$XDG_CONFIG_HOME/android"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
export BOOST_ROOT='/usr'

appendpath "$HOME/.mam"
appendpath "$CARGO_HOME/bin"
appendpath "$HOME/bin"
appendpath "$HOME/.local/bin"
unset appendpath
export PATH
