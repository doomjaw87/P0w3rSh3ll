<#####################################
| DISPLAYING ARRAY MEMBERS IN OUTPUT |
######################################

ALL VERSIONS

When you output objects that have arrays in their properties, only 4 array elements are
displayed, then an ellipsis truncates the rest:

#>

Get-Process | Select-Object -Property Name, Threads -First 6

# Name                     Threads                       
# ----                     -------                       
# aesm_service             {3036, 4824}                  
# AppleMobileDeviceService {5316, 5900, 5924, 5932...}   
# ApplicationFrameHost     {16784, 6708}                 
# AppVShNotify             {8852}                        
# armsvc                   {5284, 5808}                  
# audiodg                  {18928, 16444, 2124, 18980...}



# To show more (or all) array elements, use the internal $FormatEnumerationLimit variable. It
# defaults to 4, but you can change it to the number of elements you want to display, or set it to -1
# to show all elements:

$FormatEnumerationLimit = 1
Get-Process | Select-Object -Property Name, Threads -First 6
# Name                     Threads   
# ----                     -------   
# aesm_service             {3036...} 
# AppleMobileDeviceService {5316...} 
# ApplicationFrameHost     {16784...}
# AppVShNotify             {8852}    
# armsvc                   {5284...} 
# audiodg                  {18928...}


$FormatEnumerationLimit = 2
Get-Process | Select-Object -Property Name, Threads -First 6
# Name                     Threads          
# ----                     -------          
# aesm_service             {3036, 4824}     
# AppleMobileDeviceService {5316, 5900...}  
# ApplicationFrameHost     {16784, 6708}    
# AppVShNotify             {8852}           
# armsvc                   {5284, 5808}     
# audiodg                  {18928, 18980...}


$FormatEnumerationLimit = -1
Get-Process | Select-Object -Property Name, Threads -First 6
# Name                     Threads                                                                  
# ----                     -------                                                                  
# aesm_service             {3036, 4824}                                                             
# AppleMobileDeviceService {5316, 5900, 5924, 5932, 6988, 7012, 8848, 4964, 13952}                  
# ApplicationFrameHost     {16784, 6708}                                                            
# AppVShNotify             {8852}                                                                   
# armsvc                   {5284, 5808}                                                             
# audiodg                  {18928, 18980, 2372, 9984, 13716, 2624, 22460, 22040, 19684, 19172, 5276}


# When you set it to -1, the list is truncated only when the available space is consumed. To still
# see all values, explicitly use Format-Table and its -Wrap parameter
Get-Process | Select-Object -Property Name, Threads -First 6 | Format-Table -Wrap
# Name                     Threads                                                                                
# ----                     -------                                                                                
# aesm_service             {3036, 4824}                                                                           
# AppleMobileDeviceService {5316, 5900, 5924, 5932, 6988, 7012, 8848, 4964, 13952}                                
# ApplicationFrameHost     {16784, 6708}                                                                          
# AppVShNotify             {8852}                                                                                 
# armsvc                   {5284, 5808}                                                                           
# audiodg                  {18928, 18980, 2372, 9984, 13716, 2624, 22460, 22040, 19684, 19172, 5276, 18744, 20524}