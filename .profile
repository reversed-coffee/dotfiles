export TERMINAL="alacritty"
export PATH="$HOME/.local/bin:$HOME/.bun/bin:$PATH"
alias dot='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'

fetch

# if we in tty
if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    echo "epic tty whats ur choice"
    echo "1) be normal and start sway"
    echo "2) be a nerd and use the terminal"
    read -r choice
    if [ "$choice" -eq 2 ]; then
        echo "ok piss off then you fucking nerd"
    else
        swaystart
    fi
fi