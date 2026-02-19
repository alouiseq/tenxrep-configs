#!/bin/bash

# TenXRep development environment launcher
# Usage: ./start-dev.sh

SESSION="tenxrep"
ROOT_DIR="$HOME/code/tenxrep"

# Kill existing session if it exists
tmux kill-session -t $SESSION 2>/dev/null

# Dev window: web (left) | api (right)
tmux new-session -d -s $SESSION -n "dev" -c "$ROOT_DIR/tenxrep-web"
tmux send-keys -t $SESSION:dev 'nvm use && npm run dev' C-m
tmux split-window -h -t $SESSION:dev -c "$ROOT_DIR/tenxrep-api"
tmux send-keys -t $SESSION:dev.1 'source venv/bin/activate && python --version && python run.py' C-m

# Root window
tmux new-window -t $SESSION -n "root" -c "$ROOT_DIR"

# Key bindings: Alt+Arrow to navigate windows and panes
tmux bind-key -n M-Right next-window
tmux bind-key -n M-Left previous-window
tmux bind-key -n M-Up select-pane -t :.-
tmux bind-key -n M-Down select-pane -t :.+

# Select web window and attach
tmux select-window -t $SESSION:dev
tmux attach -t $SESSION
