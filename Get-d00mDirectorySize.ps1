function Get-d00mDirectorySize
{
    param
    (
        [parameter(Mandatory)]
        $Path
    )

    begin
    {
        $properties = @(
        @{Name       = 'Directory'
          Expression = {$_.Name}},
        @{Name       = 'Size'
          Expression = {(Get-ChildItem -Path $_.FullName -Recurse | Measure-Object -Property Length -Sum | Select-Object -Property $_.Size).Sum}}
        )
        
    }

    process
    {
        $files = Get-ChildItem -Path $Path | Where-Object -Property Attributes -eq 'Directory'
        foreach ($file in $files)
        {
            $file | select $properties
        }
    }

    end
    {

    }
}