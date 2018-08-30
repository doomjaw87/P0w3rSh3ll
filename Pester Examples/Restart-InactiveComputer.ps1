function TESTINGRestart-InactiveComputer
{
    if (!(Get-Process explorer -ErrorAction SilentlyContinue))
    {
        Restart-Computer -Force
    }
}