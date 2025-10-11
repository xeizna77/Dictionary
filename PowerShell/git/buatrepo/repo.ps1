# Script PowerShell: create-repos.ps1
# Pastikan sudah login ke GitHub CLI (gh auth login)
# dan sudah ada file repos.txt di folder yang sama dengan script ini

# Path file list repositori
$reposFile = "repos.txt"

# Username GitHub kamu
$githubUser = "hyidrax"

# Baca semua nama repo dari file
$repos = Get-Content $reposFile

foreach ($repo in $repos) {
    $repo = $repo.Trim()
    if ([string]::IsNullOrWhiteSpace($repo)) {
        continue
    }

    Write-Host "Membuat repository: $repo"

    # Buat repository di GitHub (private)
    gh repo create "$githubUser/$repo" --private --confirm

    # Buat folder lokal untuk repo
    if (-not (Test-Path $repo)) {
        New-Item -ItemType Directory -Path $repo | Out-Null
    }

    Set-Location $repo

    # Buat index.html dengan isi nama repository
    Set-Content -Path "index.html" -Value $repo

    # Git init, commit, push
    git init
    git add .
    git commit -m "Initial commit with index.html"
    git branch -M main
    git remote add origin "https://github.com/$githubUser/$repo.git"
    git push -u origin main

    # Balik ke folder awal
    Set-Location ..
}
