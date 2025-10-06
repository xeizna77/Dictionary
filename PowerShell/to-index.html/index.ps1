# Loop melalui semua file .html di direktori saat ini
Get-ChildItem -Filter *.html | ForEach-Object {
    $file = $_
    $folderName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    
    # Buat folder baru dengan nama file (tanpa ekstensi)
    New-Item -ItemType Directory -Force -Path $folderName
    
    # Pindahkan file .html ke dalam folder sebagai index.html
    Move-Item -Path $file.FullName -Destination (Join-Path $folderName "index.html")
}
