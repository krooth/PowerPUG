function Get-PPDCLogConfiguration {
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
        [object[]]$DC
    )

    #requires -Version 5

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand) on $env:COMPUTERNAME..."
         if ($null -eq $DC) {
            $DC = Get-PPDC
        }
    }

    process {
        Write-Verbose "Starting $($MyInvocation.MyCommand) on $env:COMPUTERNAME..."
        Write-Output $DC -PipelineVariable domaincontroller | ForEach-Object {
            try {
                $Session = New-PSSession -ComputerName $domaincontroller -ErrorAction Stop
            } catch {
                Write-Warning "PowerPUG! could not create a remote session on $domaincontroller"
            }

            Send-PPFunctionToRemote -FunctionName Get-PPDCAuditPolicy -Session $Session
            Invoke-Command -Session $Session -ScriptBlock { Get-PPDCAuditPolicy }
        }
    }

    end {
        Write-Verbose "Finishing $($MyInvocation.MyCommand) on $env:COMPUTERNAME..."    }
}