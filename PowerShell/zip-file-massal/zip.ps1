# Path folder utama
$rootPath = "D:\!. STV\1git\downloaded_repos"

# Ambil semua subfolder di dalam folder utama
$folders = Get-ChildItem -Path $rootPath -Directory

# Loop setiap subfolder dan buat file zip-nya
foreach ($folder in $folders) {
    $zipPath = "$rootPath\$($folder.Name).zip"
    Compress-Archive -Path $folder.FullName -DestinationPath $zipPath -Force
    Write-Host "Berhasil zip: $($folder.Name)"
}
