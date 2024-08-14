function Get-PPAuditPolicy {
    <#
        .SYNOPSIS

        .DESCRIPTION

        .PARAMETER

        .INPUTS

        .OUTPUTS

        .EXAMPLE

        .LINK
    #>
    [CmdletBinding()]
    param (
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
        $CsvTemp = New-TemporaryFile
    }

    process {
        $Category | ForEach-Object {
            $cat = $_
            auditpol /get /category:$_ /r | Out-File $CsvTemp -Force
            $Auditpol = Import-Csv -Path $CsvTemp
            $Auditpol | ForEach-Object {
                $_ | Add-Member -NotePropertyName Category -NotePropertyValue $cat -Force
                Write-Output $_
            }
        }
    }

    end {
        Remove-Item $CsvTemp
    }
}
