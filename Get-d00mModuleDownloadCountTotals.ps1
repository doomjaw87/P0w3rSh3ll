#requires -Modules d00m
$timer = New-Object -TypeName System.Diagnostics.Stopwatch
$timer.Start()
Import-Module -Name d00m -Force
Add-Type -AssemblyName PresentationFramework
$d00mDownloads = Get-d00mModuleDownloadCount -Module d00m
$d00mReportdownloads = Get-d00mModuleDownloadCount -Module d00mReport
$timer.Stop()
$message = New-Object -TypeName System.Text.StringBuilder
$message.AppendLine(('d00m Downloads: {0}' -f $d00mDownloads.DownloadCount))
$message.AppendLine(('d00mReport Downloads: {0}' -f $d00mReportdownloads.DownloadCount))
$message.AppendLine(('Total Count: {0}' -f ([int]($d00mDownloads.DownloadCount) + [int]($d00mReportdownloads.DownloadCount))))
$message.AppendLine(' ')
$message.AppendLine(('Run time: {0} ms' -f $timer.ElapsedMilliseconds))
[Windows.MessageBox]::Show($message.ToString(), 'My Module Downloads!', [Windows.MessageBoxButton]::OK, [Windows.MessageBoxImage]::Information)