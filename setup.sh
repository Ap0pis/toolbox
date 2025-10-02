#!/usr/bin/env bash
#remote bootstrap per installare la repo toolbox e tutte le dependencies necessarie, per installare su windows vedi setup_win.ps1


set -euo pipefail

REPO="Ap0pis/toolbox"
TARGET_DIR="toolbox"

# --- Colori per output ---
log() { echo -e "\033[1;32m[INFO]\033[0m $*"; }
warn() { echo -e "\033[1;33m[WARN]\033[0m $*"; }
err() { echo -e "\033[1;31m[ERR]\033[0m $*"; }

# --- Rilevamento OS ---
detect_os() {
  case "$(uname -s)" in
    Linux*)     OS="linux" ;;
    Darwin*)    OS="mac" ;;
    CYGWIN*|MINGW*|MSYS*) OS="windows" ;;
    *)          OS="unknown" ;;
  esac
  echo "$OS"
}

# --- Installazione pacchetti ---
install_dependencies() {
  local os="$1"

  # Git
  if ! command -v git >/dev/null 2>&1; then
    log "Git non trovato, installazione..."
    case "$os" in
      linux) sudo apt update && sudo apt install -y git ;;
      mac) brew install git ;;
      windows) warn "Installa Git for Windows manualmente da: https://git-scm.com/download/win" ;;
      *) err "OS non supportato per installazione automatica"; exit 1 ;;
    esac
  fi

  # GitHub CLI
  if ! command -v gh >/dev/null 2>&1; then
    log "GitHub CLI non trovato, installazione..."
    case "$os" in
      linux)
        sudo apt install -y gh || (
          type -p curl >/dev/null || sudo apt install curl -y
          curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
          echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
          sudo apt update
          sudo apt install gh -y
        )
        ;;
      mac) brew install gh ;;
      windows) warn "Installa GitHub CLI manualmente da: https://github.com/cli/cli/releases" ;;
    esac
  fi
}

# --- Autenticazione GitHub ---
check_github_auth() {
  if ! gh auth status >/dev/null 2>&1; then
    log "Non sei autenticato a GitHub, apertura login..."
    gh auth login --web --hostname github.com
  else
    log "Autenticazione GitHub OK"
  fi
}

# --- Clone repo ---
clone_repo() {
  if [ -d "$TARGET_DIR" ]; then
    warn "Cartella $TARGET_DIR già esistente, non riclonata"
  else
    log "Clono la repo $REPO in $TARGET_DIR..."
    gh repo clone "$REPO" "$TARGET_DIR"
  fi
}

# --- Rende eseguibili gli script scaricati ---
make_scripts_executable() {
  if [ -d "$TARGET_DIR" ]; then
    find "$TARGET_DIR" -type f -name "*.sh" -exec chmod +x {} \;
    log "Tutti gli script .sh in $TARGET_DIR resi eseguibili"
  fi
}

# --- Windows extra setup ---
windows_setup() {
  log "Configurazione Windows:"
  if command -v wsl >/dev/null 2>&1; then
    log "WSL rilevato: puoi eseguire gli script bash direttamente da WSL"
  else
    warn "Nessun WSL rilevato. Puoi usare Git Bash o installare WSL per eseguire gli script bash"
  fi
}

# --- Lancia list.sh se possibile ---
run_list_sh() {
  LIST_SCRIPT="$TARGET_DIR/list.sh"
  if [ -f "$LIST_SCRIPT" ] && [ -x "$LIST_SCRIPT" ]; then
    log "Eseguo lo script list.sh..."
    bash "$LIST_SCRIPT"
  else
    warn "list.sh non trovato o non eseguibile in $TARGET_DIR"
  fi
}

# --- MAIN ---
OS=$(detect_os)
log "Sistema operativo rilevato: $OS"

install_dependencies "$OS"
check_github_auth
clone_repo
make_scripts_executable

if [ "$OS" = "windows" ]; then
  windows_setup
fi

run_list_sh

log "Setup completato! Vai nella cartella '$TARGET_DIR' per usare gli altri script."
