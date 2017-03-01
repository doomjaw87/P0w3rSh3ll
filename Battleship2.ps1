#requires -Version 5
class Board
{
    [array]$state = @()
    [string]$name
    Board([string] $Name)
    {
        $this.State = @('A','B','C','D','E','F','G','H','I','J'),
                      @('=','=','=','=','=','=','=','=','=','='),
                      @(0,0,0,0,0,0,0,0,0,0),
                      @(0,0,0,0,0,0,0,0,0,0),
                      @(0,0,0,0,0,0,0,0,0,0),
                      @(0,0,0,0,0,0,0,0,0,0),
                      @(0,0,0,0,0,0,0,0,0,0),
                      @(0,0,0,0,0,0,0,0,0,0),
                      @(0,0,0,0,0,0,0,0,0,0),
                      @(0,0,0,0,0,0,0,0,0,0),
                      @(0,0,0,0,0,0,0,0,0,0),
                      @(0,0,0,0,0,0,0,0,0,0)
        $this.name = $Name
    }

    [string]Display()
    {
        $output = [system.text.stringbuilder]::new()
        $output.AppendLine(("- {0,-16}-" -f $this.Name)) | Out-Null
        foreach ($row in $this.state)
        {
            $output.AppendLine(($row -join ' ')) | Out-Null
        }
        return $output.ToString()
    }
    
    Show()
    {
        $input = $this.Display()
        foreach ($line in $input)
        {
            if ($line[0] -eq '-')
            {
                $line | Write-Host -BackgroundColor Black
            }
            else
            {
                $line | Write-Host -BackgroundColor Blue
            }
        }
    }
}