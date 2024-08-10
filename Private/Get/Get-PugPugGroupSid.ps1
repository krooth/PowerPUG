function Get-PugPugGroupSid {
    param (
        [Parameter(ValueFromPipeline)]
        [object]$PugDomains
    )

    #requires -Version 5

    begin {
        if ($null -eq $PugDomains) {
            $PugDomains = Get-PugDomain
        }
    }

    process {
        $PugDomains | ForEach-Object {
            $DomainName = $_.Name
            $DomainSid = $_ | Get-PugDomainSid
            @("$DomainSid-525") | ForEach-Object {
                $PugGroupSid = [System.Security.Principal.SecurityIdentifier]::New($_)
                $PugGroupSid | Add-Member -NotePropertyName Domain -NotePropertyValue $DomainName -Force
                Write-Output $PugGroupSid
            }
        }
    }

    end {
    }
}
