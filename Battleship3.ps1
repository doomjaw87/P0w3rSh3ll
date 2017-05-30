function Create-Board
{
    (0,0,0,0,0,0,0,0,0,0),
    (0,0,0,0,0,0,0,0,0,0),
    (0,0,0,0,0,0,0,0,0,0),
    (0,0,0,0,0,0,0,0,0,0),
    (0,0,0,0,0,0,0,0,0,0),
    (0,0,0,0,0,0,0,0,0,0),
    (0,0,0,0,0,0,0,0,0,0),
    (0,0,0,0,0,0,0,0,0,0),
    (0,0,0,0,0,0,0,0,0,0),
    (0,0,0,0,0,0,0,0,0,0)
}

function Get-Color ($ColorInt)
{
    $(switch ($ColorInt)
    {
        0 {'DarkBlue'}
        1 {'White'}
        2 {'Red'}
    }) | Write-Output
}

function Draw-Board ($InputBoard)
{
    Write-Host "   1 2 3 4 5 6 7 8 9 0"
    
    Write-Host "A: " -NoNewline
        Write-Host "$($InputBoard[0][0])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[0][1])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[0][2])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[0][3])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[0][4])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[0][5])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[0][6])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[0][7])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[0][8])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[0][9])" -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
    
    Write-Host "B: " -NoNewline
        Write-Host "$($InputBoard[1][0])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[1][1])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[1][2])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[1][3])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[1][4])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[1][5])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[1][6])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[1][7])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[1][8])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[1][9])" -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])

    Write-Host "C: " -NoNewline
        Write-Host "$($InputBoard[2][0])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[2][1])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[2][2])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[2][3])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[2][4])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[2][5])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[2][6])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[2][7])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[2][8])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[2][9])" -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])

    Write-Host "D: " -NoNewline
        Write-Host "$($InputBoard[3][0])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[3][1])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[3][2])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[3][3])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[3][4])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[3][5])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[3][6])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[3][7])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[3][8])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[3][9])" -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])

    Write-Host "E: " -NoNewline
        Write-Host "$($InputBoard[4][0])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[4][1])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[4][2])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[4][3])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[4][4])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[4][5])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[4][6])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[4][7])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[4][8])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[4][9])" -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])

    Write-Host "F: " -NoNewline
        Write-Host "$($InputBoard[5][0])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[5][1])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[5][2])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[5][3])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[5][4])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[5][5])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[5][6])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[5][7])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[5][8])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[5][9])" -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
    
    Write-Host "G: " -NoNewline
        Write-Host "$($InputBoard[6][0])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[6][1])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[6][2])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[6][3])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[6][4])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[6][5])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[6][6])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[6][7])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[6][8])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[6][9])" -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])

    Write-Host "H: " -NoNewline
        Write-Host "$($InputBoard[7][0])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[7][1])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[7][2])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[7][3])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[7][4])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[7][5])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[7][6])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[7][7])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[7][8])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[7][9])" -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])

    Write-Host "I: " -NoNewline
        Write-Host "$($InputBoard[8][0])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[8][1])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[8][2])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[8][3])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[8][4])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[8][5])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[8][6])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[8][7])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[8][8])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[8][9])" -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])

    Write-Host "J: " -NoNewline
        Write-Host "$($InputBoard[9][0])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[9][1])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[9][2])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[9][3])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[9][4])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[9][5])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[9][6])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[9][7])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[9][8])" -NoNewline -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
        Write-Host " " -NoNewline -BackgroundColor Black
        Write-Host "$($InputBoard[9][9])" -BackgroundColor (Get-Color -ColorInt $InputBoard[0][0])
}