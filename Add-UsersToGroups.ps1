param(
    [string]$InputCsv = ".\input.csv",
    [string]$LogPath = ".\logs\tool.log",
    [string]$ReportPath = ".\reports\report.csv",
    [switch]$WhatIfMode
)

function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$timestamp] [$Level] $Message"

    Write-Host $line
    $line | Out-File -FilePath $LogPath -Append -Encoding utf8
}

# Create folders if they do not exist
$logFolder = Split-Path $LogPath
$reportFolder = Split-Path $ReportPath

if (-not (Test-Path $logFolder)) {
    New-Item -Path $logFolder -ItemType Directory | Out-Null
}

if (-not (Test-Path $reportFolder)) {
    New-Item -Path $reportFolder -ItemType Directory | Out-Null
}

# Check CSV
if (-not (Test-Path $InputCsv)) {
    Write-Log "CSV file not found: $InputCsv" "ERROR"
    exit 1
}

$rows = Import-Csv -Path $InputCsv
$requiredColumns = @("UserPrincipalName", "GroupName", "TicketNumber")
$csvColumns = ($rows | Select-Object -First 1).PSObject.Properties.Name

foreach ($column in $requiredColumns) {
    if ($column -notin $csvColumns) {
        Write-Log "Required column missing in CSV: $column" "ERROR"
        exit 1
    }
}
$results = @()

foreach ($row in $rows) {
    $user = $row.UserPrincipalName
    $group = $row.GroupName
    $ticket = $row.TicketNumber

    if ([string]::IsNullOrWhiteSpace($user) -or [string]::IsNullOrWhiteSpace($group) -or [string]::IsNullOrWhiteSpace($TicketNumber)) {
        Write-Log "Skipping row with missing data" "WARN"

        $results += [PSCustomObject]@{
            UserPrincipalName = $user
            GroupName         = $group
            TicketNumber      = $ticket
            Status            = "Skipped"
            Message           = "Missing user or group"
        }

        continue
    }

    try {
        if ($WhatIfMode) {
            Write-Log "[WHATIF] Would add $user to group $group"

            $results += [PSCustomObject]@{
                UserPrincipalName = $user
                GroupName         = $group
                TicketNumber      = $ticket
                Status            = "WhatIf"
                Message           = "Simulated successfully"
                
            }
        }
        else {
            Write-Log "Adding $user to group $group"

            # Future real command:
            # Add-ADGroupMember -Identity $group -Members $user

            $results += [PSCustomObject]@{
                UserPrincipalName = $user
                GroupName         = $group
                TicketNumber      = $ticket
                Status            = "Success"
                Message           = "Processed successfully"

            }
        }
    }
    catch {
        Write-Log "Failed to process $user / $group. Error: $($_.Exception.Message)" "ERROR"

        $results += [PSCustomObject]@{
            UserPrincipalName = $user
            GroupName         = $group
            TicketNumber      = $ticket
            Status            = "Failed"
            Message           = $_.Exception.Message
        }
    }
}

$results | Export-Csv -Path $ReportPath -NoTypeInformation -Encoding utf8
$summary = $results | Group-Object -Property Status | Select-Object Name, Count

Write-Log "Summary:"
foreach ($item in $summary) {
    Write-Log "$($item.Name): $($item.Count)"
}

Write-Log "Report saved to: $ReportPath"
Write-Log "Script finished"