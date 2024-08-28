function Get-PPDC {
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
        [object]$Domain
    )

    #requires -Version 5

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand) on $env:COMPUTERNAME..."
         if ($null -eq $Domain) {
            $Domain = Get-PPDomain
        }
    }

    process {
        Write-Verbose "Starting $($MyInvocation.MyCommand) on $env:COMPUTERNAME..."
        $Domain | ForEach-Object {
            $DirectoryContext = [System.DirectoryServices.ActiveDirectory.DirectoryContext]::New(0,$_.Name)
            [System.DirectoryServices.ActiveDirectory.DomainController]::FindAll($DirectoryContext) | ForEach-Object {
                if ($_.Forest -and $_.Domain) {
                    Write-Output $_
                } else {
                    Write-Warning "$($_.Name) is not reachable. PowerPUG! will not attempt to analyze it for PUG readiness."
                }
            }
        }
    }

    end {
        Write-Verbose "Finishing $($MyInvocation.MyCommand) on $env:COMPUTERNAME..."    }
}
