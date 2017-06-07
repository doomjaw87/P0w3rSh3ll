$schemeGuid   = (powercfg -q | find "Power Scheme GUID").Split(' ').Where{$_ -like '*-*'}
$subgroupGuid = (powercfg -q | find " (Display)").Split(' ').Where{$_ -like '*-*'}
$settingGuid  = (powercfg -q | find " (Display brightness)").Split(' ').Where{$_ -like '*-*'}

powercfg -SetDcValueIndex $schemeGuid $subgroupGuid $settingGuid 1
powercfg -SetAcValueIndex $schemeGuid $subgroupGuid $settingGuid 1
powercfg -S $schemeGuid