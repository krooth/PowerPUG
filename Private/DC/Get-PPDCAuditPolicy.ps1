function Get-PPDCAuditPolicy {
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
        [Parameter(ValueFromPipeline)]
        [ValidateSet(
            'Account Logon',
            'Account Management',
            'Detailed Tracking',
            'DS Access',
            'Logon/Logoff',
            'Object Access',
            'Policy Change',
            'Privilege Use',
            'System'
        )]
        [string[]]$Category = 'Logon/Logoff'
    )

    #requires -Version 5

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand) on $env:COMPUTERNAME..."
         $CsvTemp = New-TemporaryFile
    }

    process { Write-Information "Starting $($MyInvocation.MyCommand) on $env:COMPUTERNAME..."
        Write-Output $Category -PipelineVariable cat | ForEach-Object {
            auditpol /get /category:$_ /r | Out-File $CsvTemp -Force
            $Auditpol = Import-Csv -Path $CsvTemp
            $Auditpol | ForEach-Object {
                $_ | Add-Member -NotePropertyName Category -NotePropertyValue $cat -Force
                Write-Output $_
            }
        }
    }

    end {
        Write-Verbose "Finishing $($MyInvocation.MyCommand) on $env:COMPUTERNAME..."
        Remove-Item $CsvTemp
    }
}
