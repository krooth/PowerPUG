function Get-PugAdaGroupSid {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [object]$PugDomains
    )

    #requires -Version 5

    begin {
        if ($null -eq $PugDomains) {
            $PugDomains = Get-PugDomain
        }

        $RootDomainSid = (Get-PugForest).RootDomain | Get-PugDomainSid
        $RootDomainName = (Get-PugForest).RootDomain
        @("$RootDomainSid-518","$RootDomainSid-519") | ForEach-Object {
            $AdaGroupSid = [System.Security.Principal.SecurityIdentifier]::New($_)
            $AdaGroupSid | Add-Member -NotePropertyName Domain -NotePropertyValue $RootDomainName -Force
            Write-Output $AdaGroupSid
        }
    }

    process {
        $PugDomains | ForEach-Object {
            $DomainName = $_.Name
            $DomainSid = $_ | Get-PugDomainSid
            @('S-1-5-32-544',"$DomainSid-512") | ForEach-Object {
                $AdaGroupSid = [System.Security.Principal.SecurityIdentifier]::New($_)
                $AdaGroupSid | Add-Member -NotePropertyName Domain -NotePropertyValue $DomainName -Force
                Write-Output $AdaGroupSid
            }
        }
    }

    end {
    }
}
