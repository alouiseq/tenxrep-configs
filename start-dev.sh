#!/bin/bash

# TenXRep development environment launcher
# Usage: ./start-dev.sh

SESSION="tenxrep"
ROOT_DIR="$HOME/code/tenxrep"

# Kill existing session if it exists
tmux kill-session -t $SESSION 2>/dev/null

# Web app window (with nvm)
tmux new-session -d -s $SESSION -n "web" -c "$ROOT_DIR/tenxrep-web"
tmux send-keys -t $SESSION:web 'nvm use && npm run dev' C-m

# API window
tmux new-window -t $SESSION -n "api" -c "$ROOT_DIR/tenxrep-api"
tmux send-keys -t $SESSION:api 'source venv/bin/activate && python --version && python run.py' C-m

# Marketing site window (with nvm)
tmux new-window -t $SESSION -n "marketing" -c "$ROOT_DIR/tenxrep-marketing"
tmux send-keys -t $SESSION:marketing 'nvm use && npm run dev' C-m

# Root window
tmux new-window -t $SESSION -n "root" -c "$ROOT_DIR"

# Select web window and attach
tmux select-window -t $SESSION:web
tmux attach -t $SESSION
