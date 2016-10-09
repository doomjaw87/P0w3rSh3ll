<#########################
# GETTING UNIVERSAL TIME #
#########################>
[System.DateTime]::Now
[System.DateTime]::UtcNow.ToString("o")
[system.datetime]::Now.ToUniversalTime().ToString("o")