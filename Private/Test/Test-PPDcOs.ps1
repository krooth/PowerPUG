function Test-PPDcOs {
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
        [object]$DC
    )

    #requires -Version 5

    begin {
        $DcOsWithPugArray = @(
            'Windows Server 2025 Standard',
            'Windows Server 2025 Datacenter',
            'Windows Server 2022 Standard',
            'Windows Server 2022 Datacenter',
            'Windows Server 2019 Standard',
            'Windows Server 2019 Datacenter',
            'Windows Server 2016 Standard',
            'Windows Server 2016 Datacenter',
            'Windows Server 2012 R2 Standard',
            'Windows Server 2012 R2 Datacenter'
        )
    }

    process {
        $DC | ForEach-Object {
            if ($DcOsWithPugArray -contains $_.OSVersion.ToString()) {
                Write-Output $true
            } else {
                Write-Output $false
            }
        }
    }
    
    end {
    }
}
