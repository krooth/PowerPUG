function Test-PPUserNtlmLogon {
    <#
        .SYNOPSIS

        .DESCRIPTION

        .PARAMETER Parameter

        .INPUTS

        .OUTPUTS

        .EXAMPLE

        .LINK
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [object[]]$User,
        [Parameter(ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [object[]]$DC
    )

    #requires -Version 5

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand) on $env:COMPUTERNAME..."
        if ($null -eq $DC -or $null -eq $DC.AuditingEnabled) {
            $DC = Get-PPDC
            $DC | ForEach-Object {
                try {
                    $AuditingConfiguration = Get-PPDCLogConfiguration -DC $_
                    $AuditingEnabled = Test-PPDCLogConfiguration -Configuration $AuditingConfiguration
                    $_ | Add-Member -NotePropertyName AuditingEnabled -NotePropertyValue $AuditingEnabled -Force
                    if ($_.AuditingEnabled) {
                        $NtlmLogons = Get-PPDCNtlmLogon -DC $_
                        $_ | Add-Member -NotePropertyName NtlmLogons -NotePropertyValue $NtlmLogons -Force
                        } else {
                        Write-Warning "Logon auditing is not enabled on $($_.Name)"
                    }
                } catch {
                }
            }
        }
    }

    process {
        Write-Verbose "Processing $($MyInvocation.MyCommand) on $env:COMPUTERNAME..."
        Write-Output $User -PipelineVariable loopuser | ForEach-Object {
            $DC | ForEach-Object {
                if ($_.NtlmLogons -match $loopuser.Sid) {
                    Write-Output $true
                } else {
                    Write-Output $false
                }
            }
        }
    }

    end {
        Write-Verbose "Finishing $($MyInvocation.MyCommand) on $env:COMPUTERNAME..."
    }
}
