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
        [ValidateNotNullOrEmpty()]
        [object]$Domain
    )

    #requires -Version 5

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand) on $env:COMPUTERNAME..."
     }
    
    process { Write-Information "Starting $($MyInvocation.MyCommand) on $env:COMPUTERNAME..."
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
