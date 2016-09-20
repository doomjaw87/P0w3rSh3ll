<#
.SYNOPSIS

.DESCRIPTION
    
.EXAMPLE

.EXAMPLE

.EXAMPLE

#>

function New-d00mMathAdditionWorksheet
{
    [CmdletBinding()]
    param
    (
        #Number of questions to generate
        [parameter()]
        [int]$QuestionAmount = 10,

        #Directory path to save generated worksheet
        [parameter()]
        [string]$FilePath = (Get-Location)
    )

    begin
    {
        $cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
        $start      = Get-Date
        Write-Verbose -Message ('{0} : Begin execution : {1}' -f $cmdletName, $start)
        $counter = 1
    }

    process
    {
        Write-Verbose -Message ('{0} : Generating {1} questions' -f $cmdletName, $QuestionAmount)
        $html = New-Object -TypeName System.Text.StringBuilder
        $html.AppendLine('
            <html>
                <head>
                    <title>
                        Addition
                    </title>
                    <style>
                        body {
                            font-family: calibri;
                        }
                        table, tr, td {
                            font-size: 16pt;
                        }
                    </style>
                </head>
                <body>
                    <table>') | Out-Null

        while ($counter -le $QuestionAmount)
        {
            Write-Verbose -Message ('{0} : Generating question {1}' -f $cmdletName, $counter)
            $html.AppendLine(('
                        <tr>
                            <td>{0}</td>
                            <td>+</td>
                            <td>{1}</td>
                            <td> = </td>
                            <td>______</td>
                        </tr>
                        <tr>
                            <td></br></td>
                        </tr>' -f (Get-Random -Minimum 0 -Maximum 10),
                                  (Get-Random -Minimum 0 -Maximum 10))) | Out-Null
            $counter++
        }
        $filename = 'Addition.html'
        $html.ToString() | Out-File -FilePath ('{0}\{1}' -f $FilePath, $filename) -Force
    }

    end
    {
        $end = ($(Get-Date) - $start).TotalMilliseconds
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $end)
    }
}