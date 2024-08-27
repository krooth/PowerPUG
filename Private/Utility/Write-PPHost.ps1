function Write-PPHost {
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
        [Parameter(Mandatory,Position=0)]
        [ValidateSet('Info','Warning','Success','Error','Code','Remediation','Title','Subtitle')]
        $Type,
        [Parameter(Mandatory,Position=1)]
        $Message
    )

    #requires -Version 5

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand) on $env:COMPUTERNAME..."
         $ForegroundColor = [System.Console]::ForegroundColor
        $BackgroundColor = [System.Console]::BackgroundColor
    }

    process { Write-Information "Starting $($MyInvocation.MyCommand) on $env:COMPUTERNAME..."
        $Status = switch($Type) {
            'Info' {
                @{
                    Decoration      = '-'
                    ForegroundColor = 'Cyan'
                    BackgroundColor = $BackgroundColor
                }
            }
            'Warning' {
                @{
                    Decoration      = '!'
                    ForegroundColor = 'DarkYellow'
                    BackgroundColor = $BackgroundColor
                }
            }
            'Success' {
                @{
                    Decoration      = '+'
                    ForegroundColor = 'Green'
                    BackgroundColor = $BackgroundColor
                }
            }
            'Error' {
                @{
                    Decoration      = 'X'
                    ForegroundColor = 'Red'
                    BackgroundColor = $BackgroundColor
                }
            }
            'Code' {
                @{
                    Decoration = '>'
                    ForegroundColor = 'Black'
                    BackgroundColor = 'Gray'
                }
            }
            'Prompt' {
                @{
                    Decoration = '?'
                    ForegroundColor = 'Blue'
                    BackgroundColor = 'Gray'
                }
            }
            'Remediation' {
                @{
                    Decoration = '~'
                    ForegroundColor = 'DarkCyan'
                    BackgroundColor = 'Gray'
                }
            }
            'Title' {
                @{
                    Decoration = '>'
                    ForegroundColor = 'White'
                    BackgroundColor = $BackgroundColor
                }
            }
            'Subtitle' {
                @{
                    Decoration = '>'
                    ForegroundColor = 'DarkGray'
                    BackgroundColor = $BackgroundColor
                }
            }
        }

        if ($Type -eq 'Prompt') {
            Read-Host -Prompt $(Write-Host "[$($Status.Decoration)] $Message`n> " -ForegroundColor $Status.ForegroundColor -BackgroundColor $Status.BackgroundColor -NoNewLine)
        } else {
            Write-Host "[$($Status.Decoration)] $Message" -ForegroundColor $Status.ForegroundColor -BackgroundColor $Status.BackgroundColor -NoNewline
            Write-Host -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
        }

    }
}
