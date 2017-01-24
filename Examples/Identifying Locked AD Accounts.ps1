<#################################
| IDENTIFYING LOCKED AD ACCOUNTS |
##################################

When searching for specific AD accounts, you may have used Get-AdUser in the past, and
filtered results with a filter parameter. Such filters can grow quite complex, though.

That's why there is a shortcut for most common AD searches. Simply use Search-AdAccount:

#>

#requires -Modules ActiveDirectory
Search-AdAccount -AccountDisabled
Search-ADAccount -AccountExpired
Search-ADAccount -AccountInactive