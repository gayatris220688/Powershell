Function Main{

     $outputfilePath = "$currDir\Logs\CostReportPerResource_{0}_$(Get-Date -Format 'ddMMyyyyHHmmss').csv";
     [string]$htmlbodycontent= Get-Content "$currDir\Config\sendemailforlogs.html";
    
    
     Invoke-Logger -string "[VERBOSE]: Successfully imported all common & helper modules to main module ...."

     Write-Host "[VERBOSE]: Running module updates before starting runtime flow ...." -ForegroundColor Green
     Write-Host "[VERBOSE]: Script runtime flow starting ...." -ForegroundColor Green
     
     Write-Host "[INPUT]: Please enter the subscription Id:" -ForegroundColor Yellow
     $subscriptionId = Read-Host
   
     if(![string]::IsNullOrEmpty($subscriptionId))
     {
        $subscriptionInformation = AuthenticateLoginToAzureService
     }

     Write-Host "#################### STARTING LOG VIEWER ########################" -ForegroundColor Yellow
     
     Write-Host "You are now connected to the subscription - $($subcriptionInformation.Name)" -ForegroundColor Yellow

     $startenddate = Select-InputFromPowershellCLI 

     $getlogs = Get-AzLog -StartTime $startenddate[0] -EndTime $startenddate[1]

     $logsojbect = Get-LogsFromAzure -logscontainer $getlogs

     $htmlcontent = Get-HtmlContentForLogsViewer -logsdata $logsojbect

     Invoke-SendEmailUsingComObj -subject $($Global:emailsubject -f $subscriptionId) -strTo "nitin.sapru@mindtree.com" -strCc "gayatri.sanap@mindtree.com" -htmlBody $($htmlbodycontent -f $subscriptionId,$htmlcontent)

    }
    
    Clear-Host
    
    $currDir = split-path -parent $MyInvocation.MyCommand.Definition
    Set-Location $currDir
    $currDir
    
    Remove-Module "ValidateRequiredLibraries" -ErrorAction SilentlyContinue
    Remove-Module "Authentication" -ErrorAction SilentlyContinue
    Remove-Module "Common" -ErrorAction SilentlyContinue
    Remove-Module "HtmlHelper" -ErrorAction SilentlyContinue
    Remove-Module "SendEmailUsingComObj" -ErrorAction SilentlyContinue
    Remove-Module "Logger" -ErrorAction SilentlyContinue
    
    Import-Module "$($currDir)\LibraryUpdation\ValidateRequiredLibraries.ps1" -Scope Global -Force
    Import-Module "$($currDir)\Helpers\Authentication.ps1" -Scope Global -Force
    Import-Module "$($currDir)\Helpers\HtmlHelper.ps1" -Scope Global -Force
    Import-Module "$($currDir)\Helpers\SendEmailUsingComObj.ps1" -Scope Global -Force
    Import-Module "$($currDir)\Helpers\Logger.ps1" -Scope Global -Force 
    Import-Module "$($currDir)\Common\Common.psm1" -Scope Global -Force
    
    $Global:emailsubject = "Azure Log Viewer | Subscription Id: {0} | $(Get-Date -Format 'dd-MMM-yyyy HH:mm:ss')"
    $Global:emaillist    = Import-Csv "$currDir\Config\emailConfig.csv"
    Set-LibraryValidationOnHost -listOflib $($liblist)
    
    Main
    