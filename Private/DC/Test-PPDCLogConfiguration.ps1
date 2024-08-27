function Test-PPDCLogConfiguration {
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
        [ValidateNotNullOrEmpty()]
        [object[]]$Configuration
    )

    #requires -Version 5

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand) on $env:COMPUTERNAME..."
        Write-PPHost -Type Title -Message 'Logon Auditing'
        Write-PPHost -Type Info -Message 'Proper logging is required to identify AD Admin logons using NTLM or weak Kerberos authentication.'
    }

    process { Write-Information "Starting $($MyInvocation.MyCommand) on $env:COMPUTERNAME..."
        $Configuration | ForEach-Object {
            if ( ($_.'Policy Target' -eq 'System') -and ($_.Category -eq 'Logon/Logoff') -and 
                ($_.Subcategory -eq 'Logon') -and ($_.'Inclusion Setting' -eq 'Success and Failure')
            ) {
                Write-PPHost -Type Success -Message "Logon auditing is properly configured on $($_.'Machine Name')"
            } elseif ( ($_.'Policy Target' -eq 'System') -and ($_.Category -eq 'Logon/Logoff') -and 
                ($_.Subcategory -eq 'Logon') -and ($_.'Inclusion Setting' -ne 'Success and Failure')
            ) {
                Write-PPHost -Type Error -Message "Logon auditing is not properly configured on $($_.'Machine Name')"
            }
        }
    }

    end {
        Write-Verbose "Finishing $($MyInvocation.MyCommand) on $env:COMPUTERNAME..."    }
}
