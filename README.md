# ==============================================================================
# Script Name: New-M365StandardUser.ps1
# Description: Automates the creation of a standard employee user (Ioannis Pittas)
#              in Entra ID using Microsoft Graph SDK.
# Author: Georgi Gadzhev
# Repository: https://github.com/georgigadzhev94/powershell-m365-automation
# ==============================================================================

Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
Connect-MgGraph -Scopes "User.ReadWrite.All"

$Domain = "GadzhevLTD.onmicrosoft.com"
$UserPassword = "SecurePass2026!Password"

$PasswordProfile = @{
    Password                      = $UserPassword
    ForceChangePasswordNextSignIn = $true
}

$UserParams = @{
    DisplayName       = "Ioannis Pittas"
    GivenName         = "Ioannis"
    Surname           = "Pittas"
    UserPrincipalName = "ioannis.pittas@$Domain"
    MailNickname      = "ioannispittas"
    JobTitle          = "Sales Specialist"
    Department        = "Sales"
    AccountEnabled    = $true
    PasswordProfile   = $PasswordProfile
}

Write-Host "Creating user ioannis.pittas@$Domain..." -ForegroundColor Yellow
$NewUser = New-MgUser @UserParams

Write-Host "User Ioannis Pittas created successfully! Object ID: $($NewUser.Id)" -ForegroundColor Green
