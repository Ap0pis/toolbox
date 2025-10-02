#!/usr/bin/env bash
#Update della directory corrente come commit alla repo toolbox


set -euo pipefail

# --- Configurazione ---
DEFAULT_MSG="Update"
REPO_REMOTE="origin"

# --- Colore output ---
log() { echo -e "\033[1;32m[INFO]\033[0m $*"; }
warn() { echo -e "\033[1;33m[WARN]\033[0m $*"; }
err() { echo -e "\033[1;31m[ERR]\033[0m $*"; }

# --- Controllo repo git ---
if [ ! -d ".git" ]; then
    err "La cartella corrente non è una repo git!"
    exit 1
fi

# --- Messaggio commit ---
COMMIT_MSG="${1:-$DEFAULT_MSG}"

log "Aggiungo tutti i file modificati..."
git add -A

log "Creo il commit con messaggio: '$COMMIT_MSG'..."
git commit -m "$COMMIT_MSG"

# --- Pusha sul branch corrente ---
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
log "Pusho le modifiche sul branch $CURRENT_BRANCH..."
git push "$REPO_REMOTE" "$CURRENT_BRANCH"

log "Update completato!"
