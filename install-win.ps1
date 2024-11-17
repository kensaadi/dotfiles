# Script di installazione per Windows
# Installa WezTerm, WSL con Tmux, Neovim, e il font Rec Mono Casual, poi configura i dotfiles.

# Impostazioni globali
$DotfilesRepo = "https://github.com/<tuo-utente>/<nome-repo-dotfiles>.git" # Sostituisci con il tuo repo
$DotfilesDir = "$HOME\dotfiles"
$RecMonoFontUrl = "https://github.com/arrowtype/recursive/releases/download/v1.085/RecMonoCasual-ttf.zip"
$TempFontZip = "$HOME\RecMonoCasual.zip"
$FontInstallDir = "$HOME\AppData\Local\Microsoft\Windows\Fonts"

# Funzione per verificare se un comando è disponibile
function CommandExists($command) {
    Get-Command $command -ErrorAction SilentlyContinue
}

# Funzione per creare link simbolici
function Create-Symlink($source, $target) {
    if (Test-Path $target) {
        Write-Host "Esiste già: $target, lo salto..."
    } else {
        New-Item -ItemType SymbolicLink -Path $target -Target $source -Force | Out-Null
        Write-Host "Creato link simbolico: $target -> $source"
    }
}

# Funzione per verificare se un font è installato
function Is-FontInstalled($fontName) {
    $InstalledFonts = Get-ChildItem -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" | Where-Object { $_.Name -like "*$fontName*" }
    return $InstalledFonts.Count -gt 0
}

# 1. Installa il font Rec Mono Casual
Write-Host "Installazione del font Rec Mono Casual..."
if (!(Is-FontInstalled "Rec Mono Casual")) {
    Invoke-WebRequest -Uri $RecMonoFontUrl -OutFile $TempFontZip
    Expand-Archive -Path $TempFontZip -DestinationPath $HOME\RecMonoCasual -Force
    New-Item -ItemType Directory -Force -Path $FontInstallDir | Out-Null
    Copy-Item "$HOME\RecMonoCasual\*.ttf" -Destination $FontInstallDir -Force
    Remove-Item -Recurse -Force $HOME\RecMonoCasual
    Remove-Item $TempFontZip
    Write-Host "Font Rec Mono Casual installato con successo. Potrebbe essere necessario un riavvio."
} else {
    Write-Host "Il font Rec Mono Casual è già installato."
}

# 2. Installa WezTerm
Write-Host "Installazione di WezTerm..."
$WezTermInstaller = "https://github.com/wez/wezterm/releases/latest/download/WezTerm-windows-installer.exe"
$WezTermPath = "$env:ProgramFiles\WezTerm"
if (!(Test-Path $WezTermPath)) {
    Invoke-WebRequest -Uri $WezTermInstaller -OutFile "$HOME\WezTermInstaller.exe"
    Start-Process -FilePath "$HOME\WezTermInstaller.exe" -ArgumentList "/quiet" -Wait
    Remove-Item "$HOME\WezTermInstaller.exe"
    Write-Host "WezTerm installato con successo."
} else {
    Write-Host "WezTerm è già installato."
}

# 3. Installa WSL e Tmux
Write-Host "Installazione di WSL e Tmux..."
if (!(CommandExists "wsl")) {
    wsl --install -d Ubuntu
    Write-Host "WSL installato con successo. Riavvia il sistema prima di continuare."
    exit
}
wsl -e bash -c "sudo apt update && sudo apt install -y tmux"
Write-Host "Tmux installato con successo."

# 4. Installa Neovim
Write-Host "Installazione di Neovim..."
$NeovimInstaller = "https://github.com/neovim/neovim/releases/latest/download/nvim-win64.zip"
$NeovimPath = "$env:LOCALAPPDATA\nvim"
if (!(Test-Path $NeovimPath)) {
    Invoke-WebRequest -Uri $NeovimInstaller -OutFile "$HOME\nvim.zip"
    Expand-Archive -Path "$HOME\nvim.zip" -DestinationPath "$HOME\nvim" -Force
    Move-Item "$HOME\nvim" $NeovimPath
    Remove-Item "$HOME\nvim.zip"
    Write-Host "Neovim installato con successo."
} else {
    Write-Host "Neovim è già installato."
}

# 5. Clona i dotfiles
Write-Host "Clonazione dei dotfiles..."
if (!(Test-Path $DotfilesDir)) {
    git clone $DotfilesRepo $DotfilesDir
} else {
    Write-Host "Dotfiles già clonati."
}

# 6. Configura i link simbolici
Write-Host "Configurazione dei file di configurazione..."
# WezTerm
Create-Symlink "$DotfilesDir\wezterm.lua" "$HOME\.wezterm.lua"
# Tmux (da WSL)
wsl -e bash -c "ln -sf $DotfilesDir/tmux.conf ~/.tmux.conf"
# Neovim
Create-Symlink "$DotfilesDir\nvim" "$HOME\AppData\Local\nvim"

Write-Host "Installazione completata!"

