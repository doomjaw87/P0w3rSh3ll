#requires -Version 5
class Board
{
    $board_enemy    = @()
    $board_friendly = @()

    Board()
    {
        $this.board_enemy = @('A','B','C','D','E','F','G','H','I','J'),
                            @('-','-','-','-','-','-','-','-','-','-'),
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

        $this.board_friendly = @('A','B','C','D','E','F','G','H','I','J'),
                               @('-','-','-','-','-','-','-','-','-','-'),
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
    }

    [string]Display()
    {
        $output = [System.Text.StringBuilder]::new()
        foreach ($row in $this.board_enemy)
        {
            $output.AppendLine(($row -join ' ')) | Out-Null
        }
        return $output.ToString()
    }

    Display([string]$Board)
    {
        switch ($Board)
        {
            'enemy'
            {
                foreach ($row in $this.board_enemy)
                {
                    $row -join ' ' | Write-Output
                }
            }

            'friendly'
            {
                foreach ($row in $this.board_friendly)
                {
                    foreach ($r in $row)
                    {
                        ' {0} ' -f $r | Write-Output
                    }
                }
            }
            
            default
            {
                'Invalid board type for Display method'
            }
        }
    }
}