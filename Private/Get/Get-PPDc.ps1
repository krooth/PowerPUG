function Get-PPDc {
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
        if ($null -eq $Domains) {
            $Domain = Get-PPDomain
        }
    }

    process {
        $Domain | ForEach-Object {
            $DirectoryContext = [System.DirectoryServices.ActiveDirectory.DirectoryContext]::New(0,$_.Name)
            [System.DirectoryServices.ActiveDirectory.DomainController]::FindAll($DirectoryContext) | ForEach-Object {
                Write-Output $_
            }
        }
    }

    end {
    }
}
