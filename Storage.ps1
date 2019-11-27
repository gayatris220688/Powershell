Write-Host "`n`n Managing Storage Accounts..."

#Set-AzureSubscription -subscriptionId "e0b81f36-36ba-44f7-b550-7c9344a35893"
Get-AzureRmSubscription –SubscriptionName "IOTHUB_PERF_1" | Select-AzureRmSubscription -DefaultProfile "IOTHUB_PERF_1" 


$storageAccountName = "connectivitystressstg"
$resourceGroupName = "Default-Storage-SouthCentralUS"
$key = "ntiEznfgeOQb1micjI/Ev4gxsSyxjc7hapgRtcP1675+ZUZ9UMrhQF4Bwa/9VqYdaSRE+e2dobTRQa/JBlVmGA=="
#$key = (Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroupName -AccountName $storageAccountName).Value[0]

$classicstorage = Get-AzureRmResource -ResourceType "Microsoft.ClassicStorage/storageAccounts" -Name $storageAccountName -ResourceGroupName $resourceGroupName

# Get Storage account containers list


$context = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $key
$storageContainer = Get-AzureStorageContainer -Context $context

Get-AzureStorageBlob -Container $storageContainer 


#Get-AzureStorageKey -StorageAccountName $storageAccountName
#(Get-AzureStorageAccountKey -ResourceGroupName $resourceGroupName -AccountName $storageAccountName).Value[0]

foreach($container in $storageContainer)      
 {
    if($container.Name.StartsWith("2019.11.")) 
      
    {
        $containerDateDiff = New-TimeSpan -Start $queue.LastModified -End $containerDateDiff

        if($containerDateDiff.Days -ge 14)
        {
            Write-Host "Removing $($container.Name) $($containerDateDiff.Days) days..."
            #Remove-AzureRmServiceBusQueue -ResourceGroup $resourceGroup -NamespaceName $sbNamespace -QueueName $queue.Name
        }
        else
        {
            Write-Host "$($container.Name) is in use and its not older that 14 days"
        }
    } 
}

