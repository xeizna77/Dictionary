$USER = "mYthicGloryy"
Get-Content repos.txt | ForEach-Object {
    if ($_ -ne "") {
        $repo = $_
        Write-Output "Menghapus repo: $USER/$repo ..."
        gh repo delete "$USER/$repo" --confirm
    }
}
