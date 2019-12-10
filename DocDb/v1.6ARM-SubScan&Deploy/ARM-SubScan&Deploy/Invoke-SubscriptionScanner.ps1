Function AzScanner
{
  $scanoutputFile = "$($currDir)\Logs\ScanOutputFile_{0}_$(Get-Date -Format "MMddyyyyHHmmss").csv";
  
  Invoke-Logger -string "[VERBOSE]: Successfully imported all common & helper modules to main module ...."

  Write-Host "[VERBOSE]: Running module updates before starting runtime flow ...." -ForegroundColor Green
  Write-Host "[VERBOSE]: Script runtime flow starting ...." -ForegroundColor Green
  
  Write-Host "[INPUT]: Please enter the subscription Id:" -ForegroundColor Yellow
  $subscriptionId = Read-Host

  if(![string]::IsNullOrEmpty($subscriptionId))
  {
     $subscriptionInformation = AuthenticateLoginToAzureService
  }
      
  #Get list of Resource Groups in the subscription# 
  $listOfresourceGroups = Get-AzResourceGroup 
  
  #Get list of Resources per resource group into an object#
  $resourceGroupList = Get-RGIntoPSObject -rginfo $listOfresourceGroups -subscriptionId $($subscriptionId) -tenantId $($subscriptionInformation.Context.Tenant.Id)
  
  # Get-DataForJsChart -scanoutput $resourceGroupList;

  $resourceGroupList | Export-Csv -Path $($scanoutputFile.Replace('{0}',$subscriptionId)) -NoTypeInformation -Force 

  Out-GridView -InputObject $resourceGroupList -Title "Subscription Resource List : $($subscriptionId)"

  Invoke-Logger -string "[VERBOSE]: Output of the scan is stored on this $($scanoutputFile.Replace('{0}',$subscriptionId)) ..." 

  return $resourceGroupList;
}

Clear-Host

$currDir = split-path -parent $MyInvocation.MyCommand.Definition
Set-Location $currDir
$currDir

$liblist = Import-Csv "$($currDir)\Config\LibraryList.csv";

Remove-Module "ValidateRequiredLibraries" -ErrorAction SilentlyContinue
Remove-Module "Authentication" -ErrorAction SilentlyContinue
Remove-Module "Common" -ErrorAction SilentlyContinue
Remove-Module "SendEmailMessage" -ErrorAction SilentlyContinue
Remove-Module "Logger" -ErrorAction SilentlyContinue

Import-Module "$($currDir)\LibraryUpdation\ValidateRequiredLibraries.ps1" -Scope Global -Force
Import-Module "$($currDir)\Helpers\Authentication.ps1" -Scope Global -Force
Import-Module "$($currDir)\Helpers\SendEmailMessage.ps1" -Scope Global -Force
Import-Module "$($currDir)\Helpers\Logger.ps1" -Scope Global -Force 
Import-Module "$($currDir)\Common\Common.psm1" -Scope Global -Force

Set-LibraryValidationOnHost -listOflib $($liblist)