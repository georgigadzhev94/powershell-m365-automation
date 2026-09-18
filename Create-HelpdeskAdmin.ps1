$RequiredScopes = @("User.ReadWrite.All", "RoleManagement.ReadWrite.Directory")
Connect-MgGraph -TenantId "GadzhevLTD.onmicrosoft.com" -Scopes $RequiredScopes

$PasswordProfile = @{
    Password = "SecurePassword2026!"
    ForceChangePasswordNextSignIn = $true
}

$UserParams = @{
    AccountEnabled    = $true
    DisplayName       = "Fernando Karanga"
    GivenName         = "Fernando"
    SurName           = "Karanga"
    UserPrincipalName = "f.karanga@GadzhevLTD.onmicrosoft.com"
    MailNickname      = "fkaranga"
    PasswordProfile   = $PasswordProfile
}

$NewUser = New-MgUser @UserParams

$RoleTemplate = Get-MgDirectoryRoleTemplate | Where-Object {$_.DisplayName -eq "Helpdesk Administrator"}

$ActiveRole = New-MgDirectoryRole -TemplateId $RoleTemplate.Id -ErrorAction SilentlyContinue
if ($null -eq $ActiveRole) {
    $ActiveRole = Get-MgDirectoryRole | Where-Object {$_.DisplayName -eq "Helpdegk Administrator"}
}

$RoleAssignmentParams = @{
    "PrincipalId" = $NewUser.Id
    "DirectoryScopeId" = "/"
}

New-MgDirectoryRoleMemberByRef -DirectoryRoleId $ActiveRole.Id -BodyParameter $RoleAssignmentParams

Disconnect-MgGraph
