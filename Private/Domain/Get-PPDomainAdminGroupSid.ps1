function Get-PPDomainAdminGroupSid {
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
        Write-Output $Domain -PipelineVariable loopdomain | ForEach-Object {
            $DomainSid = Get-PPDomainSid -Domain $loopdomain
            @('S-1-5-32-544',"$DomainSid-512") | ForEach-Object {
                $AdaGroupSid = [System.Security.Principal.SecurityIdentifier]::New($_)
                $AdaGroupSid | Add-Member -NotePropertyName Domain -NotePropertyValue $loopdomain -Force
                Write-Output $AdaGroupSid
            }
        }
    }

    end {
        Write-Verbose "Finishing $($MyInvocation.MyCommand) on $env:COMPUTERNAME..."    }
}
