function Get-PPEnvironment {
    <#
        .SYNOPSIS

        .DESCRIPTION

        .PARAMETER Paramter

        .INPUTS

        .OUTPUTS

        .EXAMPLE

        .LINK
    #>
    [CmdletBinding()]
    param (
    )

    #requires -Version 5

    #region collection and enrichment
    #region collect forest environmental info
    $Forest = Get-PPForest
    $Domains = Get-PPDomain -Forest $Forest
    #endregion collect forest evniromental info

    #region collect domain environmental info
    $Dcs = Get-PPDc -Domain $Domains
    #endregion collect domain environmental info

    #region expand group membership
    $ForestAdmins = Get-PPForestAdminGroupSid -Forest $Forest | Expand-PPGroupMembership
    $DomainAdmins = Get-PPDomainAdminGroupSid -Domain $Domains| Expand-PPGroupMembership
    #endregion expand group membership

    #region enrich collected info
    $Forest | ForEach-Object {
        $_ | Add-Member -NotePropertyName PugFFL -NotePropertyValue ($_ | Test-PPForestFL) -Force
    }
    $Domains | ForEach-Object {
        $_ | Add-Member -NotePropertyName PugDFL -NotePropertyValue ($_ | Test-PPDomainFL) -Force
        $_ | Add-Member -NotePropertyName PugExists -NotePropertyValue ($_ | Test-PPDomainPugExists) -Force
    }
    $Dcs | ForEach-Object {
        $_ | Add-Member -NotePropertyName PugOs -NotePropertyValue ($_ | Test-PPDCOS) -Force
    }
    $ForestAdmins | ForEach-Object {
        $_ | Add-Member -NotePropertyName PugMember -NotePropertyValue ($_ | Test-PPUserIsPugMember) -Force
        $_ | Add-Member -NotePropertyName PasswordOlderThan1Year -NotePropertyValue ($_ | Test-PPUserPasswordOlderThan1Year) -Force
        $_ | Add-Member -NotePropertyName PasswordOlderThanPug -NotePropertyValue ($_ | Test-PPUserPasswordOlderThanPug) -Force
    }
    $DomainAdmins | ForEach-Object {
        $_ | Add-Member -NotePropertyName PugMember -NotePropertyValue ($_ | Test-PPUserIsPugMember) -Force
        $_ | Add-Member -NotePropertyName PasswordOlderThan1Year -NotePropertyValue ($_ | Test-PPUserPasswordOlderThan1Year) -Force
        $_ | Add-Member -NotePropertyName PasswordOlderThanPug -NotePropertyValue ($_ | Test-PPUserPasswordOlderThanPug) -Force
    }
    #endregion enrich collected info
    #endregion collection and enrichment

    $Environment = @{
        Forest       = $Forest
        Domains      = $Domains
        Dcs          = $Dcs
        ForestAdmins = $ForestAdmins
        DomainAdmins = $DomainAdmins
    }

    Write-Output $Environment
    
}
