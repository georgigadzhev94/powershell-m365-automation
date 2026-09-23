<#
==============================================================================
Script Name: Create-HelpdeskAdmin.ps1
Description: Automates the creation of Joel Zwartz and assigns him the 
             Helpdesk Administrator role in Entra ID using Microsoft Graph SDK.
Author: Georgi Gadzhev
Repository: https://github.com/georgigadzhev94/powershell-m365-automation
==============================================================================
#>

# 1. Connect to Microsoft Graph with required scopes
Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
Connect-MgGraph -Scopes "User.ReadWrite.All", "RoleManagement.ReadWrite.Directory"

# 2. Define environment variables
$Domain = "GadzhevLTD.onmicrosoft.com"
$UserPassword = "SecurePass2026!Joel"

$PasswordProfile = @{
    Password = $UserPassword
    ForceChangePasswordNextSignIn = $true
}

# 3. User parameters for Joel Zwartz
$UserParams = @{
    DisplayName       = "Joel Zwartz"
    GivenName         = "Joel"
    Surname           = "Zwartz"
    UserPrincipalName = "joel.zwartz@$Domain"
    MailNickname      = "joelzwartz"
    JobTitle          = "Helpdesk Specialist"
    Department        = "IT Support"
    AccountEnabled    = $true
    PasswordProfile   = $PasswordProfile
}

# 4. Create the user in Entra ID
Write-Host "Creating user joel.zwartz@$Domain..." -ForegroundColor Yellow
$NewUser = New-MgUser @UserParams
Write-Host "User Joel Zwartz created successfully! Object ID: $($NewUser.Id)" -ForegroundColor Green

# 5. Assign "Helpdesk Administrator" role
Write-Host "Assigning Helpdesk Administrator role to Joel Zwartz..." -ForegroundColor Yellow

# Retrieve directory role template
$HelpdeskRoleTemplate = Get-MgDirectoryRoleTemplate | Where-Object { $_.DisplayName -eq "Helpdesk Administrator" }

# Activate role in tenant if not already activated
$DirectoryRole = Get-MgDirectoryRole | Where-Object { $_.TemplateId -eq $HelpdeskRoleTemplate.Id }
if (-not $DirectoryRole) {
    $DirectoryRole = New-MgDirectoryRole -TemplateId $HelpdeskRoleTemplate.Id
}

# Assign user to role via directory object URI
$UserUri = @{
    "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$($NewUser.Id)"
}

New-MgDirectoryRoleMemberByRef -DirectoryRoleId $DirectoryRole.Id -BodyParameter $UserUri

Write-Host "Joel Zwartz has been successfully promoted to Helpdesk Administrator!" -ForegroundColor Green
