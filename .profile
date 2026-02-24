# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Nice reads:
#   - https://wiki.archlinux.org/title/Xinit#Autostart_X_at_login
#   - https://askubuntu.com/questions/1411833/what-goes-in-profile-and-bashrc
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
  # If only one window manager is installed (e.g. i3wm) and it's linked via
  # /usr/bin/x-window-manager there is no need to configure user specific
  # xinitrc. Add "exec i3" to ~/.xinit if you want to have explict call to
  # specific wm.
  exec startx
fi
