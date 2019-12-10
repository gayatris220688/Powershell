<#.SYNOPSIS 
 Sets the throughtput to minimum for given databaseName 
  
.DESCRIPTION 
    This script reads the name of the database and its subscription ID and sets the subscription ID for it. 
    And Loads the json file which contains the mapping of the databases, sub databases, containers and its throughputput values.

.PARAMETER accountName
    The accountName used to read its content from the Json file
 #>

param(
    [Parameter(Mandatory=$true, Position=1)]
    [string] $accountName
)

# This function used to set the RUs to Minimum throughPut value 
function SetLowerThroughput ([string]$resourceGroup,[string]$containerResource, [hashtable]$property)
{
    if($containerResource -eq $null)
    {
        Write-Host("Must Pass the valid database or container")    
    }
    else 
    {
        Write-Host "Lowering RUs for $containerResource"
        $property.Keys | foreach {
            $text = $property[$_] | Out-String
            Write-Host "$_ = $text"
        }

        $cnt = 0
        $Maximum = 5

        do {
            $cnt++
            try 
            {
                #Sets the throughput to Minimum for the container         
                Set-AzureRmResource -ResourceType "Microsoft.DocumentDb/databaseAccounts/apis/databases/containers/settings" `
                -ApiVersion "2015-04-08" -ResourceGroupName $resourceGroup -Name $containerResource -PropertyObject $property `
                -Confirm:$false -ErrorAction:SilentlyContinue -Force 
                
                Write-Host "Success!"

                return

            } 
            catch 
            {
                $errorString = $_.ToString()
                Write-Error  $errorString
                if ($errorString -match "BadRequest") {
                    return
                }

                Start-Sleep -Seconds 10

            }
        } while ($cnt -lt $Maximum)
    }
    throw "Unable to set RUs for $containerResource after $Maximum tries."        
}

Import-Module "$PSScriptRoot\lib.psm1" -Verbose -Force
$global:resourceGroupName = "privatesu-docdb"
#Gets the content from the json file 
$dbContent = Get-Content -Path $PSScriptRoot\CosmosDBThroughput.json | Out-String | ConvertFrom-Json

for($i=0; $i -lt $dbContent.CosmosDBAccounts.Count ; $i++)
{
    if($dbContent.CosmosDBAccounts[$i].account -eq $accountName)
    {
        $databases = $dbContent.CosmosDBAccounts[$i].databases
        $subscriptionId = $dbContent.CosmosDBAccounts.subscriptionID[$i]
        break 
    }
}

if(($databases -eq $null) -or ($subscriptionId -eq $null))
{
    throw "Databases or Sub ID for account $accountName not found." 
}

#Sets the Azure subscription 
Set-AzureSubscription -subscriptionId $subscriptionId

#Iterating each container in the database
foreach($database in $databases)
{
    $databaseName = $database.name 
    foreach($container in $database.containers)
    {

        $containerName = $container.name
        $throuput = $container.min
        $containerResourceName = $accountName + "/sql/" + $databaseName + "/" + $containerName + "/throughput" 
        $properties = @{ "resource"=@{"throughput"=$throuput} }

        SetLowerThroughput -resourceGroup  $resourceGroupName -containerResource $containerResourceName -property $properties
    }
}
  

