function tmux-window-name() {
	if [ -x "$TMUX_PLUGIN_MANAGER_PATH/tmux-window-name/scripts/rename_session_windows.py" ]; then
		("$TMUX_PLUGIN_MANAGER_PATH/tmux-window-name/scripts/rename_session_windows.py" &)
	fi
}

add-zsh-hook chpwd tmux-window-name
