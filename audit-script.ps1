# ==============================================================================
# Script: Entra ID User Automation & Audit
# Author: Georgi
# Target Tenant: Gadzhev LTD
# Description: This script authenticates to a specific tenant, automates the 
#              creation of a new test user, and generates a final user audit table.
# ==============================================================================

# Step 1: Explicit Authentication to Gadzhev LTD Tenant
# We use the specific Tenant ID and request both Read and Write permissions
Write-Host "Initializing authentication to Gadzhev LTD..." -ForegroundColor Cyan
Connect-MgGraph -TenantId "c85378eb-9c50-4d53-bd17-7e7e1f20933a" -Scopes "User.ReadWrite.All" -NoWelcome

# Step 2: Automate New User Creation (Petar Petrov)
Write-Host "`nCreating new test user: Petar Petrov..." -ForegroundColor Yellow

# Define the password profile block
$PasswordProfile = @{ Password = "SecretPassword123!" }

# Execute the user creation command
New-MgUser -DisplayName "Petar Petrov" `
           -UserPrincipalName "petar@GadzhevLTD.onmicrosoft.com" `
           -MailNickname "petar" `
           -AccountEnabled `
           -PasswordProfile $PasswordProfile

# Step 3: Run the Final Audit to verify the changes
# The Pipeline (|) filters the users and displays them in a clean table
Write-Host "`nUser creation completed. Generating current user audit..." -ForegroundColor Green
Get-MgUser -All | Select-Object DisplayName, UserPrincipalName, AccountEnabled | Format-Table -AutoSize



