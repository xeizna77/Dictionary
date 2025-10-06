# Download-AllRepos.ps1
param(
  [string]$User = "mYthicGloryy",
  [string]$OutDir = "$env:USERPROFILE\${User}_repos"
)

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  Write-Error "gh CLI tidak ditemukan. Install gh dan login terlebih dahulu."
  exit 1
}

New-Item -ItemType Directory -Path $OutDir -Force | Out-Null
Write-Host "Mendapatkan daftar repos untuk $User ..."

# Ambil daftar repos dalam format JSON
$json = gh repo list $User --limit 1000 --json name,defaultBranchRef
$repos = $json | ConvertFrom-Json

foreach ($r in $repos) {
  $name = $r.name
  $branch = if ($r.defaultBranchRef) { $r.defaultBranchRef.name } else { "master" }
  $out = Join-Path $OutDir ("{0}-{1}.zip" -f $name, $branch)
  Write-Host "Downloading $name (branch: $branch) -> $out"

  $url = "https://github.com/$User/$name/archive/refs/heads/$branch.zip"

  try {
    Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing -ErrorAction Stop
  } catch {
    Write-Warning "Gagal download via direct URL — mencoba gh api untuk $name"
    gh api --method GET -H "Accept: application/zip" "/repos/$User/$name/zipball/$branch" --output "$out"
  }
}

Write-Host "Selesai. Semua zip tersimpan di: $OutDir"
