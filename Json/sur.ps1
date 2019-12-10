function New-TemplateParams([string] $env)
{
    $envTemplateParams = "$PSScriptRoot\..\Other\" + $env.ToLower() + ".template.parameters.json"
    $baseTemplateParams = "$PSScriptRoot\..\Other\template.parameters.json";$deployParams = "$PSScriptRoot\..\Other\deploy.parameters.json";
 
    if(!(Test-Path -Path $baseTemplateParams)) {
        throw [System.IO.FileNotFoundException] `
        "Please make sure $baseTemplateParams exists"
    }
 
    $jsonDeployParams = Get-Content $deployParams | Out-String | ConvertFrom-Json;
    $jsonBaseTemplateParams = Get-Content $baseTemplateParams | Out-String | ConvertFrom-Json
    
    Copy-Item "$PSScriptRoot\..\Other\template.parameters.json" $envTemplateParams -Force    
    $envParams = Get-Content $envTemplateParams | Out-String
 
    $params = @();
    $params = $($jsonBaseTemplateParams.parameters | Get-Member -MemberType *Property).Name    
    foreach($item in $params) {
        $value = $jsonDeployParams.$item; $parameter = "$"+$item +"$"
       
        if($item -eq "storageAccountName") {
            $res = $envParams.replace($parameter, $value.ToLower());
        }
        elseIf($item -eq "httpsTrafficOnlyEnabled" -or $item -eq "messageRetentionInDays" -or
               $item -eq "partitionCount" -or $item -eq "captureSize" -or
               $item -eq "captureTime" ) {
            $parameter = '"'+"$"+$item +"$" +'"';
            $res = $envParams.replace($parameter, $value.ToString().ToLower());
        }
        elseIf($item -eq "pmdpCosmosDbName") {
            $res = $envParams.replace($parameter, $value.ToLower());
        }
        else {
            $res = $envParams.replace($parameter, $value)
        }
        $envParams = $res
    }
    $envParams | Out-File $envTemplateParams -Force
}