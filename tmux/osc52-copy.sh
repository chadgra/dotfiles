#!/usr/bin/env bash
# Copy stdin to the Mac clipboard via OSC 52, writing directly to the
# tmux client's TTY to bypass tmux's escape sequence handling.
input=$(cat)
encoded=$(printf '%s' "$input" | base64 | tr -d '\n')
client_tty=$(tmux display-message -p '#{client_tty}')
printf '\033]52;c;%s\033\\' "$encoded" > "$client_tty"
