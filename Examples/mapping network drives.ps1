<#########################
| MAPPING NETWORK DRIVES |
##########################

All Versions

PowerShell offers numerous ways to connect to SMB file shares. Here are three different approaches:

#>

# adjust path to point to your file share
$uncPath = '\\server\share'

net use * $uncPath

New-PSDrive -Name y -PSProvider FileSystem -Root $uncPath -Persist

New-SmbMapping -LocalPath 'x:' -RemotePath $uncPath

# Net.exe is the most versatile approach and available in all PowerShell versions. By providing a
# "*", it automatically picks the next available drive letter.

# New-PSDrive supports SMB shares beginning in PowerShell 3. New-SmbSharing requires the SMBShare
# module and seems to be a bit buggy at this time: the drive shows in Windows Explorer
# only after a reboot