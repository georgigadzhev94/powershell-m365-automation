# ==============================================================================
# Script Name: Set-EndpointLanguagePack.ps1
# Description: Adds Polish (pl-PL) to the current Windows user's language list.
#              Designed to be launched from PowerShell 7.x.
# Author: Georgi Gadzhev
# ==============================================================================

$LanguageCode = "pl-PL"

Write-Host "============================================" -ForegroundColor Cyan
Write-Host " Windows Language Deployment" -ForegroundColor Cyan
Write-Host " Target language: $LanguageCode" -ForegroundColor Cyan
Write-Host " PowerShell 7 -> Windows PowerShell 5.1" -ForegroundColor DarkGray
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$Command = @'
$LanguageCode = "pl-PL"

Write-Host "Checking current Windows User Language configurations..." -ForegroundColor Cyan

$UserLanguages = Get-WinUserLanguageList

Write-Host ""
Write-Host "Current languages:" -ForegroundColor Yellow
$UserLanguages | Select-Object LanguageTag, EnglishName

if ($UserLanguages.LanguageTag -contains $LanguageCode) {

    Write-Host ""
    Write-Host "Polish language (pl-PL) is already configured." -ForegroundColor Green

}
else {

    Write-Host ""
    Write-Host "Polish language not found. Adding pl-PL..." -ForegroundColor Yellow

    $UserLanguages.Add($LanguageCode)

    Set-WinUserLanguageList -LanguageList $UserLanguages -Force

    Write-Host ""
    Write-Host "SUCCESS: Polish language and keyboard layout added." -ForegroundColor Green
}

Write-Host ""
Write-Host "Final language configuration:" -ForegroundColor Cyan

Get-WinUserLanguageList | Select-Object LanguageTag, EnglishName
'@

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command $Command

if ($LASTEXITCODE -eq 0) {

    Write-Host ""
    Write-Host "Deployment command completed." -ForegroundColor Green

}
else {

    Write-Host ""
    Write-Host "Deployment failed. Windows PowerShell returned exit code $LASTEXITCODE." -ForegroundColor Red
}
