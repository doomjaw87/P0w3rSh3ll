<#################################
| COLORFUL ASCII-ART FROM IMAGES |
##################################

All Versions

In the previous tip we showed you how you can take any image or photo and turn it into a 
black and white ASCII art. Today, we have a revised Convert-ImageToAsciiArt function for you: it
takes an image and converts it to colored ASCII art.

The pixel brightness is turned into an appropriate ASCII character, and the pixel color is applied
to that character. The ASCII art is written to a HTML file since HTML is the easiest file format for
colored text.

#>


function Convert-ImageToAsciiArt {
    param(
        [Parameter(Mandatory)][String]
        $ImagePath,
        
        [Parameter(Mandatory)][String]
        $OutputHtmlPath,
        
        [ValidateRange(20,20000)]
        [int]$MaxWidth=80
    )
    
    ,
    
    # character height:width ratio
    [float]$ratio = 1.5
    
    # load drawing functionality
    Add-Type -AssemblyName System.Drawing
    
    # characters from dark to light
    $characters = '$#H&@*+;:-,. '.ToCharArray() 
    $c = $characters.count
    
    # load image and get image size
    $image = [System.Drawing.Image]::FromFile($ImagePath)
    [int]$maxheight = $image. Height / ($image.Width / $maxwidth) / $ratio
    
    # paint image on a bitmap with the desired size
    $bitmap = new-object Drawing.Bitmap($image ,$maxwidth,$maxheight)
    
    
    # use a string builder to store the characters
    [System.Text.StringBuilder]$sb = "<html><body style='font-family:""Consolas""'>"
    
    
    # take each pixel line...
    for ([int]$y=0; $y -lt $bitmap.Height; $y++) {
        # take each pixel column...
        $null = $sb.Append("<nobr>")
        for ([int]$x=0; $x -lt $bitmap.Width; $x++) {
            # examine pixel
            $color = $bitmap.GetPixel($x, $y)
            $brightness = $color.GetBrightness()
            # choose the character that best matches the pixel brightness
            [int]$offset = [Math ]::Floor($brightness*$c)
            $ch = $characters[$offset]
            if (-not $ch) { $ch = $characters[-1] }
            $col = "#{0:x2}{1:x2 }{2:x2}" -f $color.r , $color.g, $color.b
            if ($ch -eq ' ') { $ch = "&nbsp;"}
            $null = $sb.Append( "<span style=""color: $col""; ""white-space: nowrap;"">$ch</span>")
        }
        # add a new line
        $null = $sb.AppendLine("</nobr><br/>") 
    }
    
    # close html document
    $null = $sb.AppendLine("</body></html>")
    
    # clean up and return string
    $image.Dispose()
    
    Set-Content -Path $OutputHtmlPath -Value $sb.ToString() -Encoding UTF8
} 
