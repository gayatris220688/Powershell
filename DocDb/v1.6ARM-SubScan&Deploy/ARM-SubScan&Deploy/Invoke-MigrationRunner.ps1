Function AzMigrationDriver{
param($scanOutputData)

    $orderconfig = Import-Csv -Path "$currDir\Config\DependencyConfig.csv";
    
    Write-Host "#################### STARTING PRE-MIGRATION CHECKS ########################" -ForegroundColor Yellow
    Write-Host "[INPUT]: Please enter destination subscription Id ...." -ForegroundColor Yellow  
    $destsubscriptionId = Read-Host
    AuthenticateLoginToAzureServiceSubscription -subscriptionId $destsubscriptionId

    $sourceResourceGroups = $scanOutputData | Select-Object ResourceGroupName,ResourceGroupLocation -Unique

    $orderedmigrationlist = Get-MigrationOrder -sourceResourceGroups $sourceResourceGroups -destsubscriptionId $destsubscriptionId -orderconfig $orderconfig -scanOutputData $scanOutputData

    Invoke-ARMResourceMigration -migrationorderresources $orderedmigrationlist -destinationsubscriptionId $destsubscriptionId

}

$currDir = split-path -parent $MyInvocation.MyCommand.Definition
Set-Location $currDir
$currDir

Remove-Module "Authentication" -ErrorAction SilentlyContinue
Remove-Module "Common" -ErrorAction SilentlyContinue

Import-Module "$($currDir)\Helpers\Authentication.ps1" -Scope Global -Force
Import-Module "$($currDir)\Common\Common.psm1" -Scope Global -Force

