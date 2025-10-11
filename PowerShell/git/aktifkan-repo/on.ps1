# Bersihkan file error sebelumnya
$errorFile = "error-repos.txt"
if (Test-Path $errorFile) { Remove-Item $errorFile }

Get-Content repos.txt | ForEach-Object {
    $repo = $_.Trim()
    if ($repo -ne "") {
        Write-Host "=== Proses repo: $repo ===" -ForegroundColor Cyan
        try {
            # Coba POST
            gh api repos/Nguyen-Ortminte/$repo/pages `
              -X POST `
              -H "Accept: application/vnd.github+json" `
              -f source[branch]=main `
              -f source[path]=/ | Out-Null

            Write-Host "✅ Pages berhasil diaktifkan untuk $repo (POST)"
        }
        catch {
            Write-Host "⚠️ POST gagal, coba update dengan PUT..."
            try {
                # Coba PUT
                gh api repos/Nguyen-Ortminte/$repo/pages `
                  -X PUT `
                  -H "Accept: application/vnd.github+json" `
                  -f source[branch]=main `
                  -f source[path]=/ | Out-Null

                Write-Host "✅ Pages berhasil diupdate untuk $repo (PUT)"
            }
            catch {
                Write-Host "❌ Gagal total: $repo" -ForegroundColor Red
                # Simpan nama repo yang error
                Add-Content $errorFile $repo
            }
        }
    }
}

Write-Host "`n=== Proses selesai ==="
if (Test-Path $errorFile) {
    Write-Host "❌ Beberapa repo gagal. Cek daftar di $errorFile" -ForegroundColor Yellow
} else {
    Write-Host "✅ Semua repo berhasil diproses" -ForegroundColor Green
}
