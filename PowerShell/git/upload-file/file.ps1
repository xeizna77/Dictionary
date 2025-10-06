# ==============================
# Upload file ZIP ke GitHub Repo (tanpa ekstrak)
# ==============================

$Username = "hyidrax"   # Ganti dengan username GitHub barumu
$BaseDir  = "D:\!. STV\1git\downloaded_repos"
$WorkingDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Pastikan GitHub CLI login
gh auth status 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Belum login GitHub CLI. Jalankan: gh auth login" -ForegroundColor Red
    exit
}

# Ambil semua file ZIP
$zipFiles = Get-ChildItem -Path $BaseDir -Filter *.zip
if ($zipFiles.Count -eq 0) {
    Write-Host "Tidak ada file ZIP di $BaseDir" -ForegroundColor Red
    exit
}

foreach ($zipFile in $zipFiles) {
    $repoName = [System.IO.Path]::GetFileNameWithoutExtension($zipFile.Name)
    $tempPath = Join-Path $BaseDir "temp_upload_$repoName"

    Write-Host ""
    Write-Host "Proses upload: $repoName.zip" -ForegroundColor Cyan

    if (Test-Path $tempPath) { Remove-Item $tempPath -Recurse -Force }
    New-Item -ItemType Directory -Path $tempPath | Out-Null
    Copy-Item $zipFile.FullName -Destination $tempPath -Force

    Set-Location $tempPath
    if (-not (Test-Path ".git")) {
        git init | Out-Null
        git branch -M main | Out-Null
        git remote add origin "https://github.com/$Username/$repoName.git" | Out-Null
    } else {
        git remote set-url origin "https://github.com/$Username/$repoName.git" | Out-Null
    }

    git add .
    git commit -m "Upload $repoName.zip $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" 2>$null
    Write-Host "Upload ke https://github.com/$Username/$repoName.git ..."
    git push -u origin main --force 2>$null

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Berhasil upload: $repoName" -ForegroundColor Green
    } else {
        Write-Host "Gagal upload: $repoName" -ForegroundColor Red
    }

    Set-Location $WorkingDir
    Remove-Item -Path $tempPath -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "Semua file ZIP telah berhasil diupload ke repository GitHub." -ForegroundColor Green
