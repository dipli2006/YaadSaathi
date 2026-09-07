$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$backendPath = Join-Path $projectRoot 'backend'
$frontendPath = Join-Path $projectRoot 'frontend'
$pythonPath = (Get-Command python -ErrorAction SilentlyContinue).Source

if (-not $pythonPath) {
    $pythonPath = 'C:\Users\divya\AppData\Local\Programs\Python\Python313\python.exe'
}

if (-not (Test-Path $pythonPath)) {
    Write-Host 'Python was not found. Install Python 3.13 and try again.' -ForegroundColor Red
    exit 1
}

if (-not (Test-Path (Join-Path $frontendPath 'pubspec.yaml'))) {
    Write-Host 'Flutter project was not found in frontend/.' -ForegroundColor Red
    exit 1
}

$env:DATABASE_URL = 'sqlite:///./yaadsaathi_presentation.db'
$env:SECRET_KEY = 'presentation-local-secret-change-before-production'

Write-Host 'Starting YaadSaathi backend...' -ForegroundColor Cyan
$backendProcess = Start-Process `
    -FilePath $pythonPath `
    -ArgumentList '-m', 'uvicorn', 'app.main:app', '--host', '127.0.0.1', '--port', '8000' `
    -WorkingDirectory $backendPath `
    -PassThru

try {
    Write-Host 'Starting YaadSaathi Flutter app in Chrome...' -ForegroundColor Green
    Push-Location $frontendPath
    flutter pub get
    flutter run -d chrome
}
finally {
    Pop-Location
    if ($backendProcess -and -not $backendProcess.HasExited) {
        Write-Host 'Stopping YaadSaathi backend...' -ForegroundColor DarkGray
        Stop-Process -Id $backendProcess.Id -Force
    }
}
