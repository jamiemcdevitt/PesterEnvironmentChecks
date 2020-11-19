BeforeAll { 
    function Get-DiskTotalSpace {
        param (
            [parameter(Mandatory)]
            $DiskName
        )
        $diskInfo = Get-WmiObject win32_logicaldisk |
                Where-Object DeviceId -eq $DiskName
        $diskInfo.Size    
    }
    function Get-DiskFreeSpace {
        param (
            [parameter(Mandatory)]
            $DiskName
        )
        $diskInfo = Get-WmiObject win32_logicaldisk |
                Where-Object DeviceId -eq $DiskName
        $diskInfo.FreeSpace    
    }
    function Get-PercentFreeRAMSpace {
        $os = Get-CimInstance Win32_OperatingSystem
        [math]::Round(($os.FreePhysicalMemory/$os.TotalVisibleMemorySize)*100,2)   
    }
}
Describe -Name 'Disk health checks' -Tags @("CoreChecks"){
    It 'Has at least 10% of free space' {

        $diskSize = Get-DiskTotalSpace -DiskName 'C:'
        $freeSpace = Get-DiskFreeSpace -DiskName 'C:'

        $expectedFreeSpace = $diskSize * 0.1  #10% of the total size

        $expectedFreeSpaceInGigabytes = [Math]::Round(
            $expectedFreeSpace / 1GB, 2)
        $freeSpaceInGigabytes = [Math]::Round($freeSpace / 1GB, 2)

        $freeSpaceInGigabytes |
            Should -BeGreaterThan $expectedFreeSpaceInGigabytes
    }
}
Describe -Name 'RAM health checks' -Tags @("CoreChecks"){
    It 'Has at least 20% of free memory' {
        $freeMemoryPercentage = Get-PercentFreeRAMSpace          

        $freeMemoryPercentage |
            Should -BeGreaterThan 20
    }
}