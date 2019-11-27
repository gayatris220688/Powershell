




param(
    [Parameter(Mandatory=$true, Position=1)]
    [string] $subscriptionId,

    [Parameter(Mandatory=$true, Position=2)]
    [string] $envNamePrefix,

    [Parameter(Mandatory=$false)]
    [switch] $notPreview
)

#Load the PS library module
Import-Module "$PSScriptRoot\lib.psm1" -Verbose -Force

Set-AzureSubscription -subscriptionId "2db1b828-b94e-4c59-87ae-cc9d0f19baaf"

#get Service bus Namespace 

try {
     $resources = @()

    $sbNamespace = Get-Resource -resourceNameSubstring "$($envNamePrefix)-" -resourceType "Microsoft.ServiceBus/namespaces"    
    if($sbNamespace -ne $null) {
        $resources += $sbNamespace
    }

    $sbNamespace = Get-Resource -resourceNameSubstring "$($envNamePrefix)sbnamespace" -resourceType "Microsoft.ServiceBus/namespaces"    
    if($sbNamespace -ne $null) {
        $resources += $sbNamespace
    }

    if($notPreview) {
        $resources | foreach {
            $svchubname = $_.Name
            $svchubrgname = $_.ResourceGroupName
            Write-Host "Get service bus namespace" $svchubname
            Get-ServiceBusNamespace -sbName $svchubname -rgName $svchubrgname -Force
            Write-Host "Get service bus namespace -" $svchubname    
        }
    }
    else { $resources | Format-Table -Property Name, Location, ResourceGroupName, ResourceType }
}
catch {
   Write-Host $_.Exception.Message
}


#Get Service Bus Queues

$queues= Get-AzureRmServiceBusQueue -ResourceGroup Default-ServiceBus-CentralUS -NamespaceName intcus01sbnamespace 



foreach ($queue in $queues) {

Write-Host $queue.name

}

 | Export-Csv "C:\AzureIoTLive\build\enggSys\AzureEnvScripts\Topic.csv"



 # Get Service Bus Namespace Topics

$topics= Get-AzureRmServiceBusTopic -ResourceGroup $resourceGroup -NamespaceName $sbNamespace

foreach ($topic in $topics)
{ 
    if((!$topic.Name.StartsWith("connrun")) -and `
        (!$topic.Name.StartsWith("prerelrun")) -and`
         (!$topic.Name.StartsWith("relrun")))
        {

        $topicDateDiff = New-TimeSpan -Start $queue.AccessedAt -End $currentDate

        if($topicDateDiff.Days -ge 14)
        {
            Write-Host "Removing $($topic.Name) $($topicDateDiff.Days) days..."

            #Remove-AzureRmServiceBusTopic -ResourceGroup $resourceGroup -NamespaceName $sbNamespace -TopicName $topic.Name
            
        }
        else
        {
            Write-Host "$($topic.Name) is in use and its not older that 14 days"
        }
    } 
}
