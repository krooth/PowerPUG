function Get-PPPugSid {
    <#
        .SYNOPSIS

        .DESCRIPTION

        .PARAMETER Parameter

        .INPUTS

        .OUTPUTS

        .EXAMPLE

        .LINK
    #>
    param (
        [Parameter(ValueFromPipeline)]
        [object]$Domain
    )

    #requires -Version 5

    begin {
        if ($null -eq $Domain) {
            $Domain = Get-PPDomain
        }
    }

    process {
        $Domain | ForEach-Object {
            $DomainName = $_.Name
            $DomainSid = $_ | Get-PPDomainSid
            @("$DomainSid-525") | ForEach-Object {
                $GroupSid = [System.Security.Principal.SecurityIdentifier]::New($_)
                $GroupSid | Add-Member -NotePropertyName Domain -NotePropertyValue $DomainName -Force
                Write-Output $GroupSid
            }
        }
    }

    end {
    }
}
