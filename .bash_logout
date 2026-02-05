# ~/.bash_logout
# ========================
# Bash shell configuration
# ========================


# read all history lines not already read from the history file
# and append them to the history list
history -n
# write the current history to the history file
history -w


# clear the screen and scrollback buffer for privacy
if [ "${SHLVL}" == "1" ]; then
    clear
fi
