Function Main{

$outputfilePath = "$currDir\Logs\CostReportPerResource_{0}_$(Get-Date -Format 'ddMMyyyyHHmmss').csv";
[string]$htmlbodycontent= Get-Content "$currDir\Config\sendemail.html";


 Write-Host "#################### STARTING SUBSCRIPTION SCANNER ########################" -ForegroundColor Yellow
 $scanOutputData = AzScanner;
 Write-Host "#################### COMPLETED SUBSCRIPTION SCAN OPERATION ################" -ForegroundColor Yellow

 $usageinfo = Get-AzureSubscriptionConsumption -resourcelist $scanOutputData;
 $usageinfo | Export-Csv $($outputfilePath -f $($scanOutputData[0].SubscriptionId)) -NoTypeInformation

 $usageinfo | Select-Object ResourceName, ResourceType, ResourceSku, ResourceTierSize, ResourceLocation, ResourceGroupName, UnitsConsumption, BillBeforeTax | Out-GridView

 Write-Host "Output File Path: $($outputfilePath -f $($scanOutputData[0].SubscriptionId))" -ForegroundColor Yellow

 $htmcontent = Get-HtmlContentForConsumptionInfo -datatable $($usageinfo)
 
 if(![string]::IsNullOrEmpty($htmcontent))  
 {
     $emailrecp   = Import-ReceipientList -emailConfig $Global:emaillist
     $to = [string]$emailrecp[0];
     $cc = [string]$emailrecp[1];
     $bcc = [string]$emailrecp[2];

     $emailstatus = Invoke-SendEmailUsingComObj -strTo $to -strCc $cc -strBcc $bcc -subject $($Global:emailsubject -f $($scanOutputData[0].SubscriptionId)) -htmlBody $($htmlbodycontent -f $($scanOutputData[0].SubscriptionId),$htmcontent)
     Write-Host $emailstatus;
 }

}

Clear-Host

$currDir = split-path -parent $MyInvocation.MyCommand.Definition
Set-Location $currDir
$currDir

Remove-Module "Invoke-SubscriptionScanner" -ErrorAction SilentlyContinue
Remove-Module "Authentication" -ErrorAction SilentlyContinue
Remove-Module "Common" -ErrorAction SilentlyContinue
Remove-Module "HtmlHelper" -ErrorAction SilentlyContinue
Remove-Module "SendEmailUsingComObj" -ErrorAction SilentlyContinue
Remove-Module "Logger" -ErrorAction SilentlyContinue

Import-Module "$($currDir)\Invoke-SubscriptionScanner.ps1" -Scope Global -Force
Import-Module "$($currDir)\LibraryUpdation\ValidateRequiredLibraries.ps1" -Scope Global -Force
Import-Module "$($currDir)\Helpers\Authentication.ps1" -Scope Global -Force
Import-Module "$($currDir)\Helpers\HtmlHelper.ps1" -Scope Global -Force
Import-Module "$($currDir)\Helpers\SendEmailUsingComObj.ps1" -Scope Global -Force
Import-Module "$($currDir)\Helpers\Logger.ps1" -Scope Global -Force 
Import-Module "$($currDir)\Common\Common.psm1" -Scope Global -Force

$Global:emailsubject = "Azure Cost Analyser | Subscription Id: {0} | $(Get-Date -Format 'dd-MMM-yyyy HH:mm:ss')"
$Global:emaillist    = Import-Csv "$currDir\Config\emailConfig.csv"


Main
