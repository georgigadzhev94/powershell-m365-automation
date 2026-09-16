# ==============================================================================
# Script Name: New-M365BillingAdminUser.ps1
# Description: Automates the creation of a new user in Entra ID and assigns
#              the Billing Administrator Directory Role using Microsoft Graph.
# Author: Georgi Gadzhev
# Repository: https://github.com/georgigadzhev94/powershell-m365-automation
# ==============================================================================

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [string]$Domain = "GadzhevLTD.onmicrosoft.com",

    [Parameter(Mandatory = $false)]
    [string]$UserPrincipalName = "finance.user@GadzhevLTD.onmicrosoft.com",

    [Parameter(Mandatory = $false)]
    [string]$DisplayName = "Finance Test User"
)

# 1. Connect to Microsoft Graph with required scopes
Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
Connect-MgGraph -Scopes "User.ReadWrite.All", "RoleManagement.ReadWrite.Directory"

# 2. Secure Password Prompt (Best Practice)
$SecurePassword = Read-Host -Prompt "Enter temporary password for $UserPrincipalName" -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
$UnsecurePassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

$PasswordProfile = @{
    Password                      = $UnsecurePassword
    ForceChangePasswordNextSignIn = $true
}

# 3. User Parameters Splatting
$UserParams = @{
    DisplayName       = $DisplayName
    GivenName         = "Finance"
    Surname           = "User"
    UserPrincipalName = $UserPrincipalName
    MailNickname      = "financeuser"
    AccountEnabled    = $true
    PasswordProfile   = $PasswordProfile
}

# 4. Create User
Write-Host "Creating new user $UserPrincipalName..." -ForegroundColor Yellow
try {
    $NewUser = New-MgUser @UserParams
    Write-Host "User created successfully! Object ID: $($NewUser.Id)" -ForegroundColor Green
}
catch {
    Write-Host "Error creating user: $_" -ForegroundColor Red
    return
}

# 5. Assign Billing Administrator Role
$RoleName = "Billing Administrator"
$Role = Get-MgDirectoryRole | Where-Object { $_.DisplayName -eq $RoleName }

if (-not $Role) {
    Write-Host "Enabling directory role '$RoleName'..." -ForegroundColor Yellow
    $RoleTemplate = Get-MgDirectoryRoleTemplate | Where-Object { $_.DisplayName -eq $RoleName }
    $Role = New-MgDirectoryRole -RoleTemplateId $RoleTemplate.Id
}

Write-Host "Assigning '$RoleName' role to user..." -ForegroundColor Yellow
try {
    New-MgDirectoryRoleMemberByRef -DirectoryRoleId $Role.Id -OdataId "https://graph.microsoft.com/v1.0/directoryObjects/$($NewUser.Id)"
    Write-Host "Role successfully assigned! User is now a Billing Administrator." -ForegroundColor Green
}
catch {
    Write-Host "Failed to assign role: $_" -ForegroundColor Red
}
