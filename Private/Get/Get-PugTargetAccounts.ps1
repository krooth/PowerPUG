function Get-PugTargetAccounts {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$PugDomains
    )

    #requires -Version 5

    begin {
        $ForestObject = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
        $ForestSid = [System.Security.Principal.NTAccount]::New($ForestObject.RootDomain,"krbtgt")).Translate([System.Security.Principal.SecurityIdentifier]).Value
        $EnterpriseAdminsSID = ([string]((Get-PugForest).RootDomain | Get-PugDomain).DomainSID) + '-519'
    }

    process {
        $PugDomains | ForEach-Object {
            $ADAdminsSids = @('S-1-5-32-544')
            
        }


    }

    end {

    }
}
