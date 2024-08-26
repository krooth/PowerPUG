function Get-PPDomain {
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
        [object]$Forest
    )

    #requires -Version 5

    begin {
        if ($null -eq $Forest) {
            $Forest = Get-PPForest
        }
    }

    process {
        $Forest.Domains | ForEach-Object {
            if ($_.Forest -and $_.DomainControllers) {
                Write-Output $_
            } else {
                Write-Warning "$($_.Name) is not reachable. PowerPUG! will not attempt to analyze it for PUG readiness."
            }
        }
    }

    end {
    }
}
