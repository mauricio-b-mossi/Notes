function Publish-Notes
{
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [int]$Lines = 80
    )
    Get-ChildItem -File -Recurse | ForEach-Object{
        if ((Get-Content $_).Length -gt $Lines)
        {
            git.exe add $_.FullName
        }
    } 
    git.exe commit -m "$(Get-Date)"
    git push -u origin main
}
