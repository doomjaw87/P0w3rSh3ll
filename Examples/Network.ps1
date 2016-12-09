BREAK

<##############################
| Get GeoLocation of Computer |
###############################

Here is another free source of geolocation information, exposing your current
public IP and location information.

#>

Invoke-RestMethod -Uri 'http://ipinfo.io'



<###############################
| Geolocating your IP on a Map |
################################

You can get the latitude and longitude of your current public Internet IP

#>

$ip  = Invoke-RestMethod -Uri 'http://checkip.amazonaws.com/'
$geo = Invoke-RestMethod -Uri ('http://geoip.nekudo.com/api/{0}' -f $ip)
$lat = $geo.Location.Latitude
$lon = $geo.Location.Longitude
'Lat: {0}, Long: {1}' -f $lat, $lon

# If you want to see where that actually is, connect this information with Google Maps
$url = 'https://www.google.com/maps/preview/@{0},{1},8z' -f $lat, $lon
Start-Process -FilePath $url



<############################
| Finding Public IP Address |
#############################

Want to know what your public IP address is that you are currently using while being
connected to the Internet? One-liner:

#>

Invoke-RestMethod -Uri http://checkip.amazonaws.com/

# With an IP, you can ask the Internet where you are geographically located
Invoke-RestMethod -Uri ('http://geoip.nekudo.com/api/{0}' -f $(Invoke-RestMethod -Uri http://checkip.amazonaws.com)) |
    Select-Object Country



<######################################
| Finding IP Address Assigned by DHCP |
#######################################

#>

Get-NetIPAddress -PrefixOrigin Dhcp -AddressFamily IPv4 | 
    Select-Object -Property PrefixOrigin, InterfaceIndex, InterfaceAlias, IPv4Address