Clear-Host
Write-Host "START POINT" -ForegroundColor Green
Write-Host "Welcome to Start Point Installer" -ForegroundColor Green
# =====================================================
# START POINT v1
# Fast • Clean • winget-powered
# =====================================================

# ---------- Admin Check ----------
$IsAdmin = ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $IsAdmin) {
    Write-Host "Please run START POINT as Administrator." -ForegroundColor Red
    Write-Host "Right-click PowerShell → Run as administrator." -ForegroundColor Red
    Read-Host "Press ENTER to exit"
    exit
}

# ---------- UI Helpers ----------
function Clear-Screen { Clear-Host }
function Green($t) { Write-Host $t -ForegroundColor Green }
function Pause { Write-Host ""; Read-Host "Press ENTER to continue" }

# ---------- Header ----------
function Show-Header {
    Clear-Screen
    Green "███████╗████████╗ █████╗ ██████╗ ████████╗    ██████╗  ██████╗ ██╗███╗   ██╗████████╗"
    Green "██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝    ██╔══██╗██╔═══██╗██║████╗  ██║╚══██╔══╝"
    Green "███████╗   ██║   ███████║██████╔╝   ██║       ██████╔╝██║   ██║██║██╔██╗ ██║   ██║   "
    Green "╚════██║   ██║   ██╔══██║██╔══██╗   ██║       ██╔═══╝ ██║   ██║██║██║╚██╗██║   ██║   "
    Green "███████║   ██║   ██║  ██║██║  ██║   ██║       ██║     ╚██████╔╝██║██║ ╚████║   ██║   "
    Green "╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝       ╚═╝      ╚═════╝ ╚═╝╚═╝  ╚═══╝   ╚═╝   "
    Green "--------------------------------------------------------------------------------------"
    Green " Fast • Clean • Open-source • No bloat"
    Green "--------------------------------------------------------------------------------------"
    Write-Host ""
}

# ---------- About ----------
function Show-About {
    Show-Header
    Green "START POINT installs trusted software using winget."
    Green "You choose what to install. Nothing hidden."
    Green ""
    Pause
}

# ---------- Catalog ----------
$Catalog = @{
    "Essentials" = @{
        1 = @{ Name="Google Chrome"; Id="Google.Chrome" }
        2 = @{ Name="7-Zip"; Id="7zip.7zip" }
        3 = @{ Name="VLC Media Player"; Id="VideoLAN.VLC" }
        4 = @{ Name="WhatsApp Desktop"; Id="WhatsApp.WhatsApp" }
        5 = @{ Name="Google Drive"; Id="Google.Drive" }
        6 = @{ Name="qBittorrent"; Id="qBittorrent.qBittorrent" }
        7 = @{ Name="Windows Terminal"; Id="Microsoft.WindowsTerminal" }
        8 = @{ Name="PowerShell 7"; Id="Microsoft.PowerShell" }
    }
    "Media Tools" = @{
        1 = @{ Name="OBS Studio"; Id="OBSProject.OBSStudio" }
        2 = @{ Name="Spotify"; Id="Spotify.Spotify" }
        3 = @{ Name="Audacity"; Id="Audacity.Audacity" }
    }
    "Dev Tools" = @{
        1 = @{ Name="Visual Studio Code"; Id="Microsoft.VisualStudioCode" }
        2 = @{ Name="Git"; Id="Git.Git" }
        3 = @{ Name="Python"; Id="Python.Python.3" }
        4 = @{ Name="Node.js LTS"; Id="OpenJS.NodeJS.LTS" }
    }
}

# ---------- Menus ----------
function Main-Menu {
    Show-Header
    Green "[1] Start Installation"
    Green "[2] About"
    Green "[X] Exit"
    Write-Host ""
    Read-Host "Enter choice"
}

function Category-Menu {
    Show-Header
    Green "Select a category:"
    Green ""
    Green "[1] Essentials"
    Green "[2] Media Tools"
    Green "[3] Dev Tools"
    Green "[0] Back"
    Green "[X] Exit"
    Write-Host ""
    Read-Host "Enter choice"
}

function Software-Menu($category) {
    Show-Header
    Green "$category:"
    Write-Host ""
    foreach ($k in $Catalog[$category].Keys) {
        Green "[$k] $($Catalog[$category][$k].Name)"
    }
    Write-Host ""
    Green "[0] Back"
    Green "[X] Exit"
    Write-Host ""
    Read-Host "Select software (comma separated)"
}

# ---------- Install ----------
function Install-Selected($ids) {
    Show-Header
    Green "Installing selected software..."
    Write-Host ""
    foreach ($id in $ids) {
        Green "Installing $id"
        winget install --id $id -e --accept-source-agreements --accept-package-agreements
        Write-Host ""
    }
    Green "Installation complete."
    Write-Host ""
    Green "[1] Return to Main Menu"
    Green "[X] Exit"
    Write-Host ""
    Read-Host "Enter choice"
}

# ---------- App Loop ----------
while ($true) {
    $m = Main-Menu
    if ($m -eq "X") { exit }
    if ($m -eq "2") { Show-About; continue }
    if ($m -ne "1") { continue }

    while ($true) {
        $c = Category-Menu
        if ($c -eq "X") { exit }
        if ($c -eq "0") { break }

        switch ($c) {
            "1" { $cat = "Essentials" }
            "2" { $cat = "Media Tools" }
            "3" { $cat = "Dev Tools" }
            default { continue }
        }

        $sel = Software-Menu $cat
        if ($sel -eq "X") { exit }
        if ($sel -eq "0") { continue }

        $nums = $sel -split "," | ForEach-Object { $_.Trim() }
        $ids = @()

        foreach ($n in $nums) {
            if ($Catalog[$cat].ContainsKey([int]$n)) {
                $ids += $Catalog[$cat][[int]$n].Id
            }
        }

        if ($ids.Count -gt 0) {
            Show-Header
            Green "You selected:"
            foreach ($i in $ids) { Green "✔ $i" }
            Write-Host ""
            $ok = Read-Host "Proceed? (Y/N)"
            if ($ok -match "^[Yy]$") {
                $after = Install-Selected $ids
                if ($after -eq "X") { exit }
                break
            }
        }
    }
}
