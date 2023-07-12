function Publish-Notes
{
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [int]$Lines = 80
    )

    
    try
    {
        $condition = (git status)[1].contains("Your branch is up to date")
    } catch
    {
        throw "Directory not a git repository"
    }

        Get-ChildItem -File -Recurse | ForEach-Object{
            if ((Get-Content $_).Length -gt $Lines)
            {
                git.exe add $_.FullName
            }
        } 
        git.exe commit -m "$(Get-Date)"
        git push -u origin main

}
