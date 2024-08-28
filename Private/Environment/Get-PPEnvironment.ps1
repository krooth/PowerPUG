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
    #endregion collect forest enviromental info

    #region collect domain environmental info
    $Dcs = Get-PPDc -Domain $Domains
    #endregion collect domain environmental info

    #region expand group membership
    $ForestAdminGroupSids = Get-PPForestAdminGroupSid -Forest $Forest
    $ForestAdmins = Expand-PPGroupMembership -Sid $ForestAdminGroupSids | Select-Object -Unique
    
    $DomainAdminGroupSids = $Domains | ForEach-Object { Get-PPDomainAdminGroupSid $_ }
    $DomainAdmins = Expand-PPGroupMembership -Sid $DomainAdminGroupSids | Select-Object -Unique
    
    $PugSids = Get-PPDomainPugSid -Domain $Domains
    $PugMembers = Expand-PPGroupMembership -Sid $PugSids
    #endregion expand group membership

    #region enrich collected info
    $Forest | ForEach-Object {
        $PugFFL = Test-PPForestFL -Forest $_
        $_ | Add-Member -NotePropertyName PugFFL -NotePropertyValue $PugFFL -Force
    }
    
    $Domains | ForEach-Object {
        $PugDFL = Test-PPDomainFL -Domain $_
        $_ | Add-Member -NotePropertyName PugDFL -NotePropertyValue $PugDFL -Force
        $PugExists = Test-PPDomainPugExists -Domain $_
        $_ | Add-Member -NotePropertyName PugExists -NotePropertyValue $PugExists -Force
    }
    
    $Dcs | ForEach-Object {
        $PugOS = Test-PPDCOS -DC $_
        $_ | Add-Member -NotePropertyName PugOS -NotePropertyValue $PugOS -Force
    }
    
    $ForestAdmins | ForEach-Object {
        $PugMember = Test-PPUserPugMember -User $_ -PugMembership $PugMembers
        $_ | Add-Member -NotePropertyName PugMember -NotePropertyValue $PugMember -Force
        $PasswordOlderThan1Year = Test-PPUserPasswordOlderThan1Year -User $_
        $_ | Add-Member -NotePropertyName PasswordOlderThan1Year -NotePropertyValue $PasswordOlderThan1Year -Force
        $PasswordOlderThanPug = Test-PPUserPasswordOlderThanPug -User $_
        $_ | Add-Member -NotePropertyName PasswordOlderThanPug -NotePropertyValue $PasswordOlderThanPug -Force
    }
    
    $DomainAdmins | ForEach-Object {
        $PugMember = Test-PPUserPugMember -User $_ -PugMembership $PugMembers
        $_ | Add-Member -NotePropertyName PugMember -NotePropertyValue $PugMember -Force
        $PasswordOlderThan1Year = Test-PPUserPasswordOlderThan1Year -User $_
        $_ | Add-Member -NotePropertyName PasswordOlderThan1Year -NotePropertyValue $PasswordOlderThan1Year -Force
        $PasswordOlderThanPug = Test-PPUserPasswordOlderThanPug -User $_
        $_ | Add-Member -NotePropertyName PasswordOlderThanPug -NotePropertyValue $PasswordOlderThanPug -Force
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
