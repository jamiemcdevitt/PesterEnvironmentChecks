Function Get-DiskTotalSpace {
    param (
        [parameter(Mandatory)]
        $DiskName
    )
    $diskInfo = Get-WmiObject win32_logicaldisk |
            Where-Object DeviceId -eq $DiskName
    $diskInfo.Size    
}
Function Get-DiskFreeSpace {
    param (
        [parameter(Mandatory)]
        $DiskName
    )
    $diskInfo = Get-WmiObject win32_logicaldisk |
            Where-Object DeviceId -eq $DiskName
    $diskInfo.FreeSpace    
}
Function Get-PercentFreeRAMSpace {
    $os = Get-CimInstance Win32_OperatingSystem
    [math]::Round(($os.FreePhysicalMemory/$os.TotalVisibleMemorySize)*100,2)   
}

