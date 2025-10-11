param(
  [string]$User = "mYthicGloryy"
)

# Cek apakah gh CLI sudah terinstall
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  Write-Error "gh CLI tidak ditemukan. Install gh dan login terlebih dahulu."
  exit 1
}

Write-Host "Mengambil daftar repository untuk user '$User' ..."

# Ambil daftar repos dari GitHub dalam format JSON
$json = gh repo list $User --limit 1000 --json name
$repos = $json | ConvertFrom-Json

# Tampilkan nama-nama repository
foreach ($r in $repos) {
  Write-Output $r.name
}
