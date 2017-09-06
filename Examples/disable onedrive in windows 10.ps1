<#################################
| DISABLE ONEDRIVE IN WINDOWS 10 |
##################################

ALL VERISONS

Are you also irritated by the OneDrive icon found in the navigation tree in explorer? If you never 
use OneDrive, here are two easy-to-use PowerShell functions that let you hide (and show again) 
the OneDrive icons in explorer:

#>


function Disable-OneDrive
{
    $regkey1 = 'Registry::HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}'
    $regkey2 = 'Registry::HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}'
    Set-ItemProperty -Path $regkey1, $regkey2 -Name System.IsPinnedToNameSpaceTree -Value 0
}
 



function Enable-OneDrive
{
    $regkey1 = 'Registry::HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}'
    $regkey2 = 'Registry::HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}'    
    Set-ItemProperty -Path $regkey1, $regkey2 -Name System.IsPinnedToNameSpaceTree -Value 1
} 
