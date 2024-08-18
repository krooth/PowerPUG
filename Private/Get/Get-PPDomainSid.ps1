function Get-PPDomainSid {
    <#
        .SYNOPSIS

        .DESCRIPTION

        .PARAMETER Parameter

        .INPUTS

        .OUTPUTS

        .EXAMPLE

        .LINK
    #>
    # TODO this is hacky. Replace krbtgt SID with the PDCe SID instead.
    [CmdletBinding()]
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
            $DomainKrbtgtSid = [System.Security.Principal.NTAccount]::New($_,'krbtgt').Translate([System.Security.Principal.SecurityIdentifier]).Value 
            $DomainSid = [System.Security.Principal.SecurityIdentifier]::New($DomainKrbtgtSid.Substring(0,$DomainKrbtgtSid.length-4))
            $DomainSid | Add-Member -NotePropertyName Domain -NotePropertyValue $_ -Force
            Write-Output $DomainSid
        }
    }

    end {
    }
}
