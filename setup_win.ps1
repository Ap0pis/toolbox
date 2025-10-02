# setup_win.ps1
# Script PowerShell per Windows nativo
# Installa Git, GitHub CLI e lancia lo script bash remoto

# --- Configurazione ---
$ScriptURL = "https://raw.githubusercontent.com/Ap0pis/toolbox/main/setup-toolbox.sh"

# Funzione helper per output colorato
function Write-Info($msg) { Write-Host "[INFO] $msg" -ForegroundColor Green }
function Write-Warn($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-ErrorMsg($msg) { Write-Host "[ERROR] $msg" -ForegroundColor Red }

# --- Controllo Git ---
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Warn "Git non trovato. Scarica e installa Git for Windows da https://git-scm.com/download/win"
    Write-Warn "Dopo l'installazione riapri PowerShell e rilancia questo script"
    exit 1
} else {
    Write-Info "Git trovato"
}

# --- Controllo GitHub CLI ---
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Warn "GitHub CLI non trovato. Scarica e installa da https://github.com/cli/cli/releases"
    Write-Warn "Dopo l'installazione riapri PowerShell e rilancia questo script"
    exit 1
} else {
    Write-Info "GitHub CLI trovato"
}

# --- Controllo Bash ---
$bashPath = $null

# Verifica Git Bash
$possibleGitBash = "C:\Program Files\Git\bin\bash.exe","C:\Program Files (x86)\Git\bin\bash.exe"
foreach ($path in $possibleGitBash) {
    if (Test-Path $path) { $bashPath = $path; break }
}

# Verifica WSL
if (-not $bashPath) {
    if (Get-Command wsl -ErrorAction SilentlyContinue) {
        $bashPath = "wsl"
        Write-Info "Useremo WSL per eseguire lo script bash"
    }
}

if (-not $bashPath) {
    Write-ErrorMsg "Nessun interprete Bash trovato. Installa Git Bash o WSL."
    exit 1
}

Write-Info "Bash disponibile: $bashPath"

# --- Esecuzione script remoto ---
Write-Info "Scarico ed eseguo lo script setup-toolbox.sh da remoto..."
& $bashPath -c "bash -c '$(curl -fsSL $ScriptURL)'"

Write-Info "Setup completato!"
