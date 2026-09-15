# ==============================================================================
# Script Name: New-M365BillingAdminUser.ps1
# Description: Automates the creation of a new user in Entra ID and assigns
#              the Billing Administrator Directory Role using Microsoft Graph.
# Author: Georgi Gadzhev
# Repository: https://github.com/georgigadzhev94/powershell-m365-automation
# ==============================================================================

Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
Connect-MgGraph -Scopes "User.ReadWrite.All", "RoleManagement.ReadWrite.Directory"

$Domain = "GadzhevLTD.onmicrosoft.com"
$UserPassword = "SecurePass2026!Password"
$PasswordProfile = @{
    Password = $UserPassword
    ForceChangePasswordNextSignIn = $true
}

$UserParams = @{
    DisplayName       = "Finance Test User"
    GivenName         = "Finance"
    Surname           = "User"
    UserPrincipalName = "finance.user@$Domain"
    MailNickname      = "financeuser"
    AccountEnabled    = $true
    PasswordProfile   = $PasswordProfile
}

Write-Host "Creating new user finance.user@$Domain..." -ForegroundColor Yellow
$NewUser = New-MgUser @UserParams
Write-Host "User created successfully! Object ID: $($NewUser.Id)" -ForegroundColor Green

$RoleName = "Billing Administrator"
$Role = Get-MgDirectoryRole | Where-Object { $_.DisplayName -eq $RoleName }

if (-not $Role) {
    $RoleTemplate = Get-MgDirectoryRoleTemplate | Where-Object { $_.DisplayName -eq $RoleName }
    $Role = New-MgDirectoryRole -RoleTemplateId $RoleTemplate.Id
}

Write-Host "Assigning '$RoleName' role to user..." -ForegroundColor Yellow
New-MgDirectoryRoleMemberByRef -DirectoryRoleId $Role.Id -OdataId "https://graph.microsoft.com/v1.0/directoryObjects/$($NewUser.Id)"

Write-Host "Role successfully assigned! User is now a Billing Administrator." -ForegroundColor Green
