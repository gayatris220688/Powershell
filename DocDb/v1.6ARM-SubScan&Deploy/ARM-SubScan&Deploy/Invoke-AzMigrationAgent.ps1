Function Main{
    
    Write-Host "#################### STARTING SUBSCRIPTION SCANNER ########################" -ForegroundColor Yellow
    $scanOutputData = AzScanner;
    Write-Host "#################### COMPLETED SUBSCRIPTION SCAN OPERATION ################" -ForegroundColor Yellow
       
    AzMigrationDriver -scanOutputData $scanOutputData
    
}

Clear-Host

$currDir = split-path -parent $MyInvocation.MyCommand.Definition
Set-Location $currDir
$currDir

Remove-Module "Invoke-SubscriptionScanner" -ErrorAction SilentlyContinue
Remove-Module "Invoke-MigrationRunner" -ErrorAction SilentlyContinue

Import-Module "$($currDir)\Invoke-SubscriptionScanner.ps1" -Scope Global -Force
Import-Module "$($currDir)\Invoke-MigrationRunner.ps1" -Scope Global -Force

Main