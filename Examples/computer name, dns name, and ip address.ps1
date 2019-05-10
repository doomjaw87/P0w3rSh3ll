<##########################################
| COMPUTER NAME, DNS NAME, AND IP ADDRESS |
###########################################

All Versions

Here is a simple one-liner that returns your computers' current IP address and its full DNS name:
#>

[System.Net.Dns]::GetHostEntry($env:COMPUTERNAME)


# To examine a remote machine, simply submit the computer remote name:
[System.Net.Dns]::GetHostEntry("remoteComputerName")

# If you just would like to get the list of assigned IP addresses, try this:
[System.Net.Dns]::GetHostEntry($env:COMPUTERNAME).AddressList.IPAddressToString

<#
Your learning points:

- The System.Net.DNS class contains a number of useful DNS-related methods.
  GetHostEntry() is especially useful because it accepts both computer names and IP
  address and returns the corresponding DNS names and IP addresses.
- Submit an empty string to view your machines' own settings
#>