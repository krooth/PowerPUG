function Test-PPGroupExists {
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
        [object]$GroupSid
    )

    #requires -Version 5

    begin {
        Add-Type -AssemblyName 'System.DirectoryServices.AccountManagement'
    }

    process {
        $GroupSid | ForEach-Object {
            $PrincipalContext = [System.DirectoryServices.AccountManagement.PrincipalContext]::New('Domain',$_.Domain)
            $PugExists = $false
            try {
                $GroupPrincipal = [System.DirectoryServices.AccountManagement.GroupPrincipal]::FindByIdentity($PrincipalContext,$_.Value)
                $GroupPrincipal.GetMembers() | Out-Null
                $PugExists = $true
            } catch {
            }

            $Return = [PSCustomObject]@{
                Name  = $_.Domain
                Value = $PugExists
            }

            Write-Output $Return
        }
    }

    end {
    }
}
