function Test-PPPasswordOlderThan1Year {
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
        [object[]]$User
    )

    #requires -Version 5

    begin {
    }

    process {
        $User | ForEach-Object {
            if ($_.LastPasswordSet -lt (Get-Date).AddDays(-365)) {
                Write-Output $true
            } else {
                Write-Output $false
            }
        }
    }

    end {
    }
}
