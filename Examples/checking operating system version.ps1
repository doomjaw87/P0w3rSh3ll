<####################################
| CHECKING OPERATING SYSTEM VERSION |
#####################################

Here is a simple and fast way of checking the operating system version:

#>

[Environment]::OSVersion

# So now it's a snap checking whether a script runs on the intended operating system.
# To check for Windows 10, try this:
[Environment]::OSVersion.Version.Major -eq 10


# OSVersions: https://msdn.microsoft.com/en-us/library/windows/desktop/ms724832(v=vs.85).aspx