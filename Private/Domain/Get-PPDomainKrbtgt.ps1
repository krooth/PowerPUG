function Get-PPDomainKrbtgt {
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
         Add-Type -AssemblyName 'System.DirectoryServices.AccountManagement'
        if ($null -eq $Domain) {
            $Domain = Get-PPDomain
        }
    }

    process {
        Write-Verbose "Starting $($MyInvocation.MyCommand) on $env:COMPUTERNAME..."
        $Domain | ForEach-Object {
            $PrincipalContext = [System.DirectoryServices.AccountManagement.PrincipalContext]::New('Domain',$_.Name)
            $DomainSid = $_ | Get-PPDomainSid
            $KrbtgtSid = [System.Security.Principal.SecurityIdentifier]::New("$DomainSid-502")
            [System.DirectoryServices.AccountManagement.UserPrincipal]::FindByIdentity($PrincipalContext,$KrbtgtSid)
        }
    }

    end {
        Write-Verbose "Finishing $($MyInvocation.MyCommand) on $env:COMPUTERNAME..."    }
}
