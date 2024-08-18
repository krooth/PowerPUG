function Test-PPIsPugMember {
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
        [Parameter(Mandatory, ValueFromPipeline)]
        [object[]]$Users,
        [object[]]$PugMembership
    )

    #requires -Version 5

    begin {
        if ($null -eq $PugMembership) {
            $PugMembership = Get-PPPugSid | Expand-PPGroupMembership
        } 
    }

    process {
        $Users | ForEach-Object {
            if ($PugMembership -contains $_) {
                Write-Output $true
            } else {
                Write-Output $false
            }
        }
    }

    end {
    }
}
