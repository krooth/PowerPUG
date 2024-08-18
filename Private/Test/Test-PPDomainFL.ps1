function Test-PPDomainFL {
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
        [object]$Domain
    )

    #requires -Version 5

    begin {
    }
    
    process {
        $Domain | ForEach-Object {
            if ($_.DomainModeLevel -ge 6) {
                Write-Output $true 
            } else {
                Write-Output $false
            }
        }
    }

    end {}
}
