# ===============================
# START POINT - Basic Installer
# ===============================

function Show-Header {
    Clear-Host
    Write-Host ""
    Write-Host "==============================" -ForegroundColor Green
    Write-Host "        STARTPOINT            " -ForegroundColor Green
    Write-Host "==============================" -ForegroundColor Green
    Write-Host ""
}

$apps = @{
    1 = @{ Name = "Google Chrome"; Id = "Google.Chrome" }
    2 = @{ Name = "Microsoft Edge"; Id = "Microsoft.Edge" }
    3 = @{ Name = "7-Zip"; Id = "7zip.7zip" }
    4 = @{ Name = "Notepad++"; Id = "Notepad++.Notepad++" }
    5 = @{ Name = "Visual Studio Code"; Id = "Microsoft.VisualStudioCode" }
    6 = @{ Name = "VLC Media Player"; Id = "VideoLAN.VLC" }
    7 = @{ Name = "Git"; Id = "Git.Git" }
    8 = @{ Name = "Python"; Id = "Python.Python.3" }
    9 = @{ Name = "Java (OpenJDK)"; Id = "EclipseAdoptium.Temurin.17.JDK" }
}

while ($true) {
    Show-Header

    Write-Host "Select software to install:" -ForegroundColor Cyan
    foreach ($key in $apps.Keys | Sort-Object) {
        Write-Host "$key. $($apps[$key].Name)"
    }
    Write-Host "0. Exit"
    Write-Host ""

    $input = Read-Host "Enter numbers (comma separated)"

    if ($input -eq "0") {
        Write-Host "Goodbye 👋" -ForegroundColor Yellow
        break
    }

    $choices = $input -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^\d+$' }

    $selected = @()
    foreach ($c in $choices) {
        if ($apps.ContainsKey([int]$c)) {
            $selected += $apps[[int]$c]
        }
    }

    if ($selected.Count -eq 0) {
        Write-Host "Invalid selection. Try again." -ForegroundColor Red
        Start-Sleep 2
        continue
    }

    Write-Host ""
    Write-Host "You selected:" -ForegroundColor Green
    foreach ($app in $selected) {
        Write-Host "✔ $($app.Name)"
    }

    $confirm = Read-Host "Proceed with installation? (Y/N)"
    if ($confirm -notmatch '^[Yy]$') {
        Write-Host "Cancelled. Returning to menu..." -ForegroundColor Yellow
        Start-Sleep 2
        continue
    }

    foreach ($app in $selected) {
        Write-Host ""
        Write-Host "Installing $($app.Name)..." -ForegroundColor Cyan
        winget install --id $app.Id -e --accept-package-agreements --accept-source-agreements
    }

    Write-Host ""
    Write-Host "Installation complete ✔" -ForegroundColor Green
    Write-Host "Returning to menu..." -ForegroundColor Yellow
    Start-Sleep 3
}
