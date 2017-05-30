$MemDef = @"
[DllImport("winmm.dll", CharSet = CharSet.Ansi)]
   public static extern int mciSendStringA(
   string lpstrCommand,
   string lpstrReturnString,
   int uReturnLength,
   IntPtr hwndCallback);
"@

$winnm = Add-Type -memberDefinition $MemDef -ErrorAction SilentlyContinue -PassThru -Name mciSendString

while ($true)
{
    $winnm::mciSendStringA("set cdaudio door open", $null, 0, 0)
    #Start-Sleep -Seconds 5
    $winnm::mciSendStringA("set cdaudio door closed", $null, 0, 0)
    #Start-Sleep -Seconds 5
}