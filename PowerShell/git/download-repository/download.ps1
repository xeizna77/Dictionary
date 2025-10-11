# ==============================
# Script: Download-Repos.ps1
# Fungsi: Download semua repository dari akun GitHub lama
# Dibaca dari file repos.txt
# ==============================

# --- Konfigurasi ---
$SourceUser = "mYthicGloryy"    # ganti dengan username GitHub lama
$RepoListPath = "repos.txt"      # daftar repo, 1 baris = 1 nama repo
$DownloadDir = "downloaded_repos"

# --- Cek file repos.txt ---
if (-not (Test-Path $RepoListPath)) {
    Write-Host "❌ File repos.txt tidak ditemukan di folder ini!" -ForegroundColor Red
    exit
}

# --- Pastikan folder download ada ---
if (-not (Test-Path $DownloadDir)) {
    New-Item -ItemType Directory -Path $DownloadDir | Out-Null
}

Set-Location $DownloadDir

# --- Loop setiap repository ---
$repos = Get-Content "../$RepoListPath" | Where-Object { $_.Trim() -ne "" }

foreach ($repo in $repos) {
    Write-Host "=== Mengunduh repository: $repo ===" -ForegroundColor Cyan

    # Coba clone via GitHub CLI (lebih cepat & support privat)
    $cloneResult = & gh repo clone "$SourceUser/$repo" -- --depth=1 2>&1

    if ($LASTEXITCODE -ne 0) {
        Write-Host "⚠️  Gagal clone via gh, coba pakai git biasa..." -ForegroundColor Yellow
        $gitUrl = "https://github.com/$SourceUser/$repo.git"
        git clone $gitUrl --depth=1
        if ($LASTEXITCODE -ne 0) {
            Write-Host "❌ Gagal clone $repo" -ForegroundColor Red
            continue
        }
    }

    Write-Host "✅ Selesai: $repo" -ForegroundColor Green
    Write-Host ""
}

Write-Host "🎉 Semua repository sudah diunduh ke folder '$DownloadDir'." -ForegroundColor Green
