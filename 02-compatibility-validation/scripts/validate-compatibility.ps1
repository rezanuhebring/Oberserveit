# Pre-Deployment Compatibility Validation Script

<#
.SYNOPSIS
    Validates system compatibility for ObserveIt monitoring platform deployment

.DESCRIPTION
    This script performs comprehensive pre-deployment validation checks including:
    - Operating system compatibility
    - Hardware resource verification
    - Software dependency confirmation
    - Network configuration validation
    - Security settings verification

.PARAMETER OutputPath
    Path to save the validation report (optional)

.EXAMPLE
    .\validate-compatibility.ps1

.EXAMPLE
    .\validate-compatibility.ps1 -OutputPath "C:\Reports\validation-report.txt"
#>

param(
    [string]$OutputPath = ""
)

# Configuration
$MinimumRequirements = @{
    CPUCores = 2
    RAM_GB = 4
    Disk_GB = 20
}

$RecommendedRequirements = @{
    CPUCores = 4
    RAM_GB = 8
    Disk_GB = 50
}

$RequiredPorts = @(3000, 9090, 9093)

# Functions
function Write-Header {
    param([string]$Text)
    Write-Host "`n=== $Text ===" -ForegroundColor Cyan
    if ($OutputPath) { Add-Content -Path $OutputPath -Value "`n=== $Text ===" }
}

function Write-Result {
    param(
        [string]$Check,
        [string]$Status,
        [string]$Details = ""
    )
    $color = switch ($Status) {
        "PASS" { "Green" }
        "FAIL" { "Red" }
        "WARN" { "Yellow" }
        default { "White" }
    }
    Write-Host "[$Status] $Check" -ForegroundColor $color
    if ($Details) { Write-Host "       $Details" -ForegroundColor Gray }
    if ($OutputPath) {
        Add-Content -Path $OutputPath -Value "[$Status] $Check"
        if ($Details) { Add-Content -Path $OutputPath -Value "       $Details" }
    }
}

function Test-OperatingSystem {
    Write-Header "Operating System Validation"

    $osInfo = Get-WmiObject -Class Win32_OperatingSystem
    $osCaption = $osInfo.Caption
    $osVersion = $osInfo.Version
    $osArchitecture = $osInfo.OSArchitecture

    Write-Host "OS: $osCaption"
    Write-Host "Version: $osVersion"
    Write-Host "Architecture: $osArchitecture"

    # Check Windows version compatibility
    $supportedVersions = @("10", "11")
    $serverSupported = @("2019", "2022")

    $isSupported = $false
    $versionNumber = ""

    if ($osCaption -match "Windows 10") {
        $versionNumber = "10"
        $isSupported = $supportedVersions -contains $versionNumber
    } elseif ($osCaption -match "Windows 11") {
        $versionNumber = "11"
        $isSupported = $supportedVersions -contains $versionNumber
    } elseif ($osCaption -match "Windows Server") {
        if ($osCaption -match "2019|2022") {
            $isSupported = $true
        }
    }

    if ($isSupported) {
        Write-Result "Operating System Version" "PASS" "Compatible: $osCaption"
    } else {
        Write-Result "Operating System Version" "FAIL" "Unsupported: $osCaption"
    }

    # Check architecture
    if ($osArchitecture -eq "64-bit") {
        Write-Result "System Architecture" "PASS" "64-bit architecture confirmed"
    } else {
        Write-Result "System Architecture" "FAIL" "32-bit systems not supported"
    }
}

function Test-Hardware {
    Write-Header "Hardware Validation"

    # CPU Check
    $cpuInfo = Get-WmiObject -Class Win32_Processor
    $cpuCores = $cpuInfo.NumberOfCores
    $cpuLogical = $cpuInfo.NumberOfLogicalProcessors

    if ($cpuCores -ge $MinimumRequirements.CPUCores) {
        Write-Result "CPU Cores" "PASS" "$cpuCores cores available (minimum: $($MinimumRequirements.CPUCores))"
    } elseif ($cpuCores -ge 1) {
        Write-Result "CPU Cores" "WARN" "$cpuCores cores available (recommended: $($RecommendedRequirements.CPUCores))"
    } else {
        Write-Result "CPU Cores" "FAIL" "$cpuCores cores available (minimum: $($MinimumRequirements.CPUCores))"
    }

    # Memory Check
    $memoryInfo = Get-WmiObject -Class Win32_ComputerSystem
    $totalMemoryGB = [math]::Round($memoryInfo.TotalPhysicalMemory / 1GB, 1)

    if ($totalMemoryGB -ge $RecommendedRequirements.RAM_GB) {
        Write-Result "System Memory" "PASS" "${totalMemoryGB}GB RAM available"
    } elseif ($totalMemoryGB -ge $MinimumRequirements.RAM_GB) {
        Write-Result "System Memory" "WARN" "${totalMemoryGB}GB RAM available (recommended: $($RecommendedRequirements.RAM_GB)GB)"
    } else {
        Write-Result "System Memory" "FAIL" "${totalMemoryGB}GB RAM available (minimum: $($MinimumRequirements.RAM_GB)GB)"
    }

    # Disk Space Check
    $diskInfo = Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='C:'"
    $freeSpaceGB = [math]::Round($diskInfo.FreeSpace / 1GB, 1)

    if ($freeSpaceGB -ge $RecommendedRequirements.Disk_GB) {
        Write-Result "Disk Space" "PASS" "${freeSpaceGB}GB free on C: drive"
    } elseif ($freeSpaceGB -ge $MinimumRequirements.Disk_GB) {
        Write-Result "Disk Space" "WARN" "${freeSpaceGB}GB free on C: drive (recommended: $($RecommendedRequirements.Disk_GB)GB)"
    } else {
        Write-Result "Disk Space" "FAIL" "${freeSpaceGB}GB free on C: drive (minimum: $($MinimumRequirements.Disk_GB)GB)"
    }
}

function Test-Software {
    Write-Header "Software Dependencies"

    # Docker Desktop Check
    $dockerVersion = $null
    try {
        $dockerVersion = docker --version 2>$null
        if ($dockerVersion -match "Docker version (\d+\.\d+)") {
            $version = [version]$matches[1]
            if ($version -ge [version]"4.0") {
                Write-Result "Docker Desktop" "PASS" $dockerVersion.Trim()
            } else {
                Write-Result "Docker Desktop" "WARN" "$dockerVersion (recommended: 4.0+)"
            }
        }
    } catch {
        Write-Result "Docker Desktop" "FAIL" "Docker Desktop not found or not running"
    }

    # WSL2 Check
    $wslVersion = $null
    try {
        $wslVersion = wsl --version 2>$null
        if ($wslVersion) {
            Write-Result "WSL2" "PASS" "WSL2 available"
        }
    } catch {
        Write-Result "WSL2" "FAIL" "WSL2 not available"
    }

    # PowerShell Version
    $psVersion = $PSVersionTable.PSVersion
    if ($psVersion.Major -ge 5 -and $psVersion.Minor -ge 1) {
        Write-Result "PowerShell Version" "PASS" "PowerShell $psVersion"
    } else {
        Write-Result "PowerShell Version" "FAIL" "PowerShell $psVersion (minimum: 5.1)"
    }
}

function Test-Network {
    Write-Header "Network Configuration"

    # Port availability check
    $portsBlocked = @()
    foreach ($port in $RequiredPorts) {
        $connection = Test-NetConnection -ComputerName localhost -Port $port -WarningAction SilentlyContinue
        if ($connection.TcpTestSucceeded) {
            $portsBlocked += $port
        }
    }

    if ($portsBlocked.Count -eq 0) {
        Write-Result "Required Ports" "PASS" "Ports 3000, 9090, 9093 available"
    } else {
        Write-Result "Required Ports" "WARN" "Ports $($portsBlocked -join ', ') may be in use"
    }

    # Internet connectivity
    try {
        $internetTest = Test-NetConnection -ComputerName google.com -Port 80 -WarningAction SilentlyContinue
        if ($internetTest.TcpTestSucceeded) {
            Write-Result "Internet Connectivity" "PASS" "Internet access available"
        } else {
            Write-Result "Internet Connectivity" "FAIL" "No internet connectivity detected"
        }
    } catch {
        Write-Result "Internet Connectivity" "WARN" "Unable to verify internet connectivity"
    }
}

function Test-Security {
    Write-Header "Security Configuration"

    # Administrator check
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    $isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    if ($isAdmin) {
        Write-Result "Administrator Privileges" "PASS" "Running as administrator"
    } else {
        Write-Result "Administrator Privileges" "FAIL" "Administrator privileges required"
    }

    # Firewall status
    $firewallProfiles = Get-NetFirewallProfile
    $firewallEnabled = $false
    foreach ($profile in $firewallProfiles) {
        if ($profile.Enabled) {
            $firewallEnabled = $true
            break
        }
    }

    if ($firewallEnabled) {
        Write-Result "Windows Firewall" "PASS" "Firewall is enabled"
    } else {
        Write-Result "Windows Firewall" "WARN" "Firewall is disabled"
    }
}

# Main execution
Write-Host "ObserveIt Monitoring Platform - Compatibility Validation"
Write-Host "======================================================"
Write-Host "Validation started at $(Get-Date)"

if ($OutputPath) {
    "ObserveIt Monitoring Platform - Compatibility Validation Report" | Out-File -FilePath $OutputPath
    "Generated on $(Get-Date)" | Out-File -FilePath $OutputPath -Append
    "" | Out-File -FilePath $OutputPath -Append
}

Test-OperatingSystem
Test-Hardware
Test-Software
Test-Network
Test-Security

Write-Header "Validation Complete"
Write-Host "Validation completed at $(Get-Date)"
Write-Host "`nReview the results above and address any FAIL or WARN conditions before deployment."

if ($OutputPath) {
    "`nValidation completed at $(Get-Date)" | Out-File -FilePath $OutputPath -Append
    "`nReview the results above and address any FAIL or WARN conditions before deployment." | Out-File -FilePath $OutputPath -Append
}