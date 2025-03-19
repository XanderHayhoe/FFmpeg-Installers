#Requires -RunAsAdministrator

New-Item -ItemType Directory -Force -Path "C:\ffmpeg"
$installDir = "C:\Program Files\FFmpeg"
$user = [System.Environment]::UserName # idk if i want to install for user or for system. likely just system for now but i'll keep this here
$ffmpegUrl = "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip"

Write-Host "Downloading FFmpeg..." -ForegroundColor Cyan
$zipFile = Join-Path $tempDir "ffmpeg.zip"
Invoke-WebRequest -Uri $ffmpegUrl -OutFile $zipFile

if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Force -Path $installDir | Out-Null
}


# blocking. extract after
if (Test-Path $zipFile) {
    Write-Host "Extracting FFmpeg..." -ForegroundColor Cyan
    Expand-Archive -Path $zipFile -DestinationPath $installDir
    Remove-Item -Path $zipFile
} else {
    Write-Host "Failed to download FFmpeg" -ForegroundColor Purple
    exit 1
}

$extractedDir = Get-ChildItem -Path $tempDir -Directory | Where-Object { $_.Name -like "ffmpeg-*" } | Select-Object -First 1

Write-Host "Installing FFmpeg..." -ForegroundColor Cyan
Copy-Item -Path "$($extractedDir.FullName)\bin\*" -Destination $installDir -Recurse -Force

$currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
if (-not $currentPath.Contains($installDir)) {
    Write-Host "Adding FFmpeg to system PATH..." -ForegroundColor Cyan
    [Environment]::SetEnvironmentVariable("Path", "$currentPath;$installDir", "Machine")
}

Write-Host "Cleaning up..." -ForegroundColor Cyan
Remove-Item -Path $tempDir -Recurse -Force

try {
    $ffmpegVersion = Invoke-Expression "& '$installDir\ffmpeg.exe' -version" # this should work
    Write-Host "FFmpeg installed successfully!" -ForegroundColor Green
    Write-Host "Version information:" -ForegroundColor Green # i love colours
    Write-Host $ffmpegVersion
} catch {
    Write-Host "Installation completed, but verification failed. You may need to restart your terminal or system." -ForegroundColor Yellow
}

Write-Host "FFmpeg is now installed at: $installDir" -ForegroundColor Green
