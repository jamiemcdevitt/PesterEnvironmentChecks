Param(
    [string]$DriveCheck = 'C:'
)

Install-Module -Name Pester -Scope CurrentUser

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
Describe -Name 'Disk health checks' -Tags @("CoreChecks"){

    $diskSize = Get-DiskTotalSpace -DiskName $DriveCheck
    $freeSpace = Get-DiskFreeSpace -DiskName $DriveCheck

    $expectedFreeSpace = $diskSize * 0.1  #10% of the total size

    $expectedFreeSpaceInGigabytes = [Math]::Round(
        $expectedFreeSpace / 1GB, 2)

    $freeSpaceInGigabytes = [Math]::Round($freeSpace / 1GB, 2)
    $freeSpaceInGigabytes |
        Should -BeGreaterThan $expectedFreeSpaceInGigabytes    
}
Describe -Name 'RAM health checks' -Tags @("CoreChecks"){
    $freeMemoryPercentage = Get-PercentFreeRAMSpace

    $freeMemoryPercentage |
        Should -BeGreaterThan 20

}