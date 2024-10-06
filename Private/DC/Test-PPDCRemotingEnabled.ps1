function Test-PPDCRemotingEnabled {
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
        [ValidateNotNullOrEmpty()]
        [object[]]$DC
    )

    #requires -Version 5

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand) on $env:COMPUTERNAME..."
    }

    process {
        Write-Verbose "Processing $($MyInvocation.MyCommand) on $env:COMPUTERNAME..."
        $DC | ForEach-Object {
            Test-WSMan -ComputerName $_
            $?
        }
    }

    end {
        Write-Verbose "Finishing $($MyInvocation.MyCommand) on $env:COMPUTERNAME..."
    }
}
