Function New-RGObject
{

    $exobj = $null
    $exobj= New-Object PSObject 
    $exobj | Add-Member -MemberType NoteProperty -Name "SubscriptionId" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "TenantId" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "ResourceName" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "ResourceProvider" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "ResourceType" -Value " "

    $exobj | Add-Member -MemberType NoteProperty -Name "ResourceSku" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "ResourceTierSize" -Value " "

    $exobj | Add-Member -MemberType NoteProperty -Name "ResourceLocation" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "ResourceId" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "ResourceGroupName" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "ResourceGroupLocation" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "ResourceGroupTags" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "ScanDateTime" -Value "$(Get-Date -Format "MM/dd/yyyy HH:mm:ss")"

    return $exobj
}

Function New-ARMOrderObject
{

    $exobj = $null
    $exobj= New-Object PSObject 
    $exobj | Add-Member -MemberType NoteProperty -Name "ResourceId" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "ResourceName" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "ResourceProvider" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "ResourceType" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "ResourceGroupName" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "MigrationOrder" -Value " "

    return $exobj
}

Function New-ARMLogsObject
{

    $exobj = $null
    $exobj= New-Object PSObject 
    $exobj | Add-Member -MemberType NoteProperty -Name "EventId" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "CorrelationId" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "Level" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "EventName" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "EventTime" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "OperationName" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "ApiRestMethod" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "Status" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "EventBy" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "IPAddr" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "ResourceGroupName" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "ResourceType" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "ResourceId" -Value " "

    return $exobj
}

Function New-ConsumptionObject
{

    $exobj = $null
    $exobj= New-Object PSObject 
    $exobj | Add-Member -MemberType NoteProperty -Name "SubscriptionId" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "TenantId" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "ResourceId" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "ResourceName" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "ResourceProvider" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "ResourceType" -Value " "

    $exobj | Add-Member -MemberType NoteProperty -Name "ResourceSku" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "ResourceTierSize" -Value " "

    $exobj | Add-Member -MemberType NoteProperty -Name "ResourceLocation" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "ResourceGroupName" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "ResourceGroupLocation" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "UnitsConsumption" -Value " "
    $exobj | Add-Member -MemberType NoteProperty -Name "BillBeforeTax" -Value " "

    $exobj | Add-Member -MemberType NoteProperty -Name "ScanDateTime" -Value "$(Get-Date -Format "MM/dd/yyyy HH:mm:ss")"

    return $exobj
}

Function Get-RGIntoPSObject
{
param($rginfo, $subscriptionId, $tenantId)

$objlist = @(); 

     foreach($rg in $rginfo)
     {
          Write-Host "[VERBOSE]: Resource Group $($rg.ResourceGroupName) is being scanned for resources ...." 

           $resourceList = Get-AzResource -ResourceGroupName $($rg.ResourceGroupName) 

           foreach($resource in $resourceList)
           {
               Write-Host "[VERBOSE]: Resource of type: $($resource.ResourceType) has been found with name $($resource.Name) in resource group $($rg.ResourceGroupName) ...." 

               $rgobj  = New-RGObject
               $rgobj.SubscriptionId = $subscriptionId;
               $rgobj.TenantId = $tenantId;
               $rgobj.ResourceName = $($resource.Name)
               $rgobj.ResourceProvider = $($resource.ResourceType.Split('/')[0])
               $rgobj.ResourceType = $($resource.ResourceType.Split('/')[1])
               $rgobj.ResourceLocation = $($resource.Location)
               $rgobj.ResourceId = $($resource.ResourceId)
               $rgobj.ResourceGroupName = $($rg.ResourceGroupName);
               $rgobj.ResourceGroupLocation = $($rg.Location);
               $rgobj.ResourceGroupTags = $($rg.Tags)
               
               $tempobj = Get-SkuTierInfoForResource -resourceInfo $rgobj -azcommonobj $resource
               
               $rgobj.ResourceSku = $tempobj.ResourceSku;
               $rgobj.ResourceTierSize = $tempobj.ResourceTierSize;

               if($rgobj)
               {
                 $objlist+=$rgobj;
               }
           }
      }

 return $objlist;
}

Function Get-SkuTierInfoForResource{
param($resourceInfo, $azcommonobj)

$skuInfoContainer = $null;

    switch -Wildcard ($resourceInfo.ResourceType) {
        "virtualMachines" 
        { 
            $skuInfoContainer = Get-VmSkuInfo -resourceInfo $($resourceInfo); $resourceInfo.ResourceSku = $skuInfoContainer[0]; $resourceInfo.ResourceTierSize = $skuInfoContainer[1];
        }
        "storageAccounts" 
        { 
            $skuInfoContainer = Get-StorageSkuInfo -resourceInfo $($resourceInfo); $resourceInfo.ResourceSku = $skuInfoContainer[0]; $resourceInfo.ResourceTierSize = $skuInfoContainer[1]; 
        }
        Default 
        {
            if($null -ne $azcommonobj.Sku)
            {
                $resourceInfo.ResourceSku = $azcommonobj.Sku.Name;
                $resourceInfo.ResourceTierSize  = $azcommonobj.Sku.Tier; 
            }
            else {
                $resourceInfo.ResourceSku = "NA";
                $resourceInfo.ResourceTierSize  = "NA";
            }
        }
    }

 return $resourceInfo;
}

Function Get-VmSkuInfo{
    param($resourceInfo)

$skuInfo = $null; $tierInfo = $null;

    if($null -ne $resourceInfo)
    {
        $vmInfo = Get-AzVM -ResourceGroupName $($resourceInfo.ResourceGroupName) -Name $($resourceInfo.ResourceName);
       
       if($null -ne $vmInfo)
       { 
        $skuInfo = $vmInfo.hardwareProfile.VmSize + '(' + $vmInfo.StorageProfile.OsDisk.DiskSizeGB + ' GB)';
        $tierInfo= $vmInfo.StorageProfile.ImageReference.Offer + '- ' + $vmInfo.StorageProfile.ImageReference.Sku;  
       }
    }

 return $skuInfo, $tierInfo;
}

Function Get-StorageSkuInfo{
    param($resourceInfo)

$skuInfo = $null; $tierInfo = $null;

    if($null -ne $resourceInfo)
    {
        $StorageInfo = Get-AzStorageAccount  -ResourceGroupName $($resourceInfo.ResourceGroupName) -Name $($resourceInfo.ResourceName);
       
       if($null -ne $StorageInfo)
       { 
        $skuInfo = $StorageInfo.Sku.Name;
        $tierInfo= $StorageInfo.Sku.Tier;
       }
    }

 return $skuInfo, $tierInfo;
}

Function New-ARMResourceGroup
{
    param($resourceGroupName, $location, $subscriptionId)

    if(![string]::IsNullOrEmpty($resourceGroupName) -and ![string]::IsNullOrEmpty($location))
    {
        $returnContext = New-AzResourceGroup -Name $($resourceGroupName) -Location $($location) -Force
        
        if($returnContext.ProvisioningState -match "Succeeded")
        {
          Write-Host "[VERBOSE]: Successfully created resource group $($returnContext.Name) with location $($returnContext.Location) on subscriptionId $($subscriptionId) ...." -ForegroundColor Green
          return $true;
        }
        else {
            return $false;
        }
    }
}

Function Move-ResourceFromSourceToDestination{
param($destinationResourceGroup, $sourceresourceId, $destinationSubscriptionId)

    if(![string]::IsNullOrEmpty($destinationResourceGroup) -and ![string]::IsNullOrEmpty($sourceresourceId)){

        try {
            #Start-Process powershell.exe -Verb Runas -ArgumentList "Move-AzResource -DestinationResourceGroupName $($destinationResourceGroup) -DestinationSubscriptionId $($destinationSubscriptionId) -ResourceId $($sourceresourceId) -Force -Verbose"
            Move-AzResource -DestinationResourceGroupName $destinationResourceGroup -DestinationSubscriptionId $destinationSubscriptionId -ResourceId $sourceresourceId -Force -Verbose    
        }
        catch {
            Write-Host "[ERROR]: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Function Register-ARMResourceProvider{

param($namespace)

    if(![string]::IsNullOrEmpty($namespace)){

        $result = Register-AzResourceProvider -ProviderNamespace $($namespace) -Verbose
    }

return $result;
}

Function Get-MigrationOrder
{
   param($sourceResourceGroups, $destsubscriptionId , $orderconfig,$scanOutputData) 
   $resourcecontainer = @();  


   foreach($resourcegrp in $sourceResourceGroups)
    { 
      Write-Host "[VERBOSE]: Moving resource group $($resourcegrp.ResourceGroupName) ...." -ForegroundColor Green
      $iscreated = New-ARMResourceGroup -subscriptionId $destsubscriptionId -resourceGroupName $($resourcegrp.ResourceGroupName) -location $($resourcegrp.ResourceGroupLocation)

      if($iscreated){
        $rgresources = $scanOutputData | Where-Object {$_.ResourceGroupName -match $($resourcegrp.ResourceGroupName)};

        Write-Host "[VERBOSE]: Found $($rgresources.ResourceName.Count) resources within the source subscription resource group ...." -ForegroundColor Green

        foreach($item in $rgresources)
        {

          Write-Host "[VERBOSE]: Registering the resource provider $($item.ResourceProvider)  on the subscriptionId: $($destsubscriptionId)..." -ForegroundColor Green          
          $registerresult = Register-ARMResourceProvider -namespace $($item.ResourceProvider)
          $tempcontainer = $orderconfig  | Where-Object {($_.ResourceProvider -match $item.ResourceProvider) -and ($_.ResourceType -match $item.ResourceType) -and ($_.ResourceType -notmatch "networkWatchers")}

          if($null -ne $registerresult)
          {
             $ordobj = New-ARMOrderObject
             $ordobj.ResourceId = $item.ResourceId
             $ordobj.ResourceName = $item.ResourceName
             $ordobj.ResourceProvider =$item.ResourceProvider
             $ordobj.ResourceType =$item.ResourceType
             $ordobj.ResourceGroupName = $item.ResourceGroupName

             if($null -ne $tempcontainer)
             {
               $ordobj.MigrationOrder =  $tempcontainer.Order;
             }
             else {
               $ordobj.MigrationOrder =  0;
             }

             if($ordobj){
              $resourcecontainer+=$ordobj;
             } 
          }
        }
        
      }  
    }

return $resourcecontainer;
}
Function Invoke-ARMResourceMigration
{
    param($migrationorderresources, $destinationsubscriptionId)

    $sortedbyorder = $migrationorderresources | Sort-Object MigrationOrder

    foreach($item in $sortedbyorder)
    {
        Move-ResourceFromSourceToDestination -destinationResourceGroup $($item.ResourceGroupName) -sourceresourceId $($item.ResourceId) -destinationSubscriptionId $($destinationsubscriptionId)
    }
}

Function Get-AzureSubscriptionConsumption
{
    param($resourcelist)

    $billarray = @();

    $consumptionData = Get-AzConsumptionUsageDetail;

    foreach($item in $resourcelist)
    {
            $obj = New-ConsumptionObject
            $obj.SubscriptionId= $item.SubscriptionId;
            $obj.TenantId=$item.TenantId;
            $obj.ResourceId= $item.ResourceId;
            $obj.ResourceName= $item.ResourceName;
            $obj.ResourceProvider= $item.ResourceProvider;
            $obj.ResourceType= $item.ResourceType;
            $obj.ResourceSku=  $item.ResourceSku;
            $obj.ResourceTierSize= $item.ResourceTierSize;
            $obj.ResourceLocation= $item.ResourceLocation;
            $obj.ResourceGroupName= $item.ResourceGroupName;
            $obj.ResourceGroupLocation= $item.ResourceGroupLocation;
            $obj.UnitsConsumption=  (Get-CalculationOfUnitConsumptionPretax -resourceusagestats $($consumptionData | Where-Object {$_.InstanceId -match $item.ResourceId}))[0].Average;
            $obj.BillBeforeTax = (Get-CalculationOfUnitConsumptionPretax -resourceusagestats $($consumptionData | Where-Object {$_.InstanceId -match $item.ResourceId}))[1].Average;

            if($obj)
            {
                $billarray += $obj;
            }
    }

return $billarray;
}

Function Get-CalculationOfUnitConsumptionPretax
{
    param($resourceusagestats)

    if($null -ne $resourceusagestats)
    {
        $groupedByBillingPeriod = $resourceusagestats | Group-Object BillingPeriodName | Sort-Object Name -Descending

            $itemresult = $groupedByBillingPeriod[0].Group;
            
            $avgusage = $itemresult | Measure-Object UsageQuantity -Average
            $avgusagecost = $itemresult | Measure-Object PretaxCost -Average
    }

 return $avgusage, $avgusagecost;
}

Function Get-DataForJsChart
{
    param($scanoutput)

    $ar = $null;

    if($null -ne $scanoutput)
    {
        $groupbysubscription = $scanoutput | Group-Object SubscriptionId      

        foreach($item in $groupbysubscription.Name)
        {
           $groupbyresourceg = $scanoutput | Group-Object ResourceGroupName
             
           foreach($rg in $groupbyresourceg)
           {
               $ar = $item , $rg.Name;
           } 
        }
    }

   $ar
}

Function Get-LogsFromAzure
{
    param($starttime, $endtime)

    $logresults = Get-AzLog -StartTime $starttime -EndTime $endtime

    return $logresults;
}

Function Select-InputFromPowershellCLI
{

    Write-Host "1: Press 1 for last 1 hour logs:"
    Write-Host "2: Press 2 for last 8 hour logs:"
    Write-Host "3: Press 3 for last 12 hour logs:"
    Write-Host "4: Press 4 for last 24 hour logs:"
    Write-Host "5: Press 5 for last 2 days logs:"
    Write-Host "6: Press 6 for last 7 days logs:"
    Write-Host "Exit:  Press Q to Quit:"

    $inputcapture = Read-Host "Please enter your choice";

        switch ($inputcapture) {
            "1" {$start = (Get-Date).AddHours(-1) ; $end=Get-Date; }
            "2" {$start = (Get-Date).AddHours(-8) ; $end=Get-Date; }
            "3" {$start = (Get-Date).AddHours(-12); $end=Get-Date; }
            "4" {$start = (Get-Date).AddHours(-24); $end=Get-Date; }
            "5" {$start = (Get-Date).AddHours(-48); $end=Get-Date; }
            "6" {$start = (Get-Date).AddDays(-7)  ; $end=Get-Date; }
            "Q" {break;}
        }

    return $start, $end;
}

Function Get-LogsFromAzure{
    param($logscontainer)

    $logsdata = @();

    $sortedcontent = $logscontainer | Sort-Object EventTimeStamp 

    foreach($log in $sortedcontent)
    {
        
        $lobj = New-ARMLogsObject
        $lobj.EventId= $log.EventDataId;
        $lobj.CorrelationId=$log.CorrelationId;
        $lobj.Level= $log.Level;
        $lobj.EventName= $log.EventName.Value;
        $lobj.EventTime= $log.EventTimeStamp;
        $lobj.OperationName= $log.OperationName.Value;
        if($null -ne $log.HttpRequest){ $lobj.ApiRestMethod= $log.HttpRequest.Method; } else {$lobj.ApiRestMethod= "NA"; } 
        $lobj.Status= $log.Status.Value;
        $lobj.EventBy= $log.Claims.Content.name;
        $lobj.IPAddr=$log.Claims.Content.ipaddr;
        $lobj.ResourceGroupName= $log.ResourceGroupName;
        $lobj.ResourceType= $log.ResourceType;
        $lobj.ResourceId= Get-ResourceNameFromId -resourceId $log.ResourceId;

        if($lobj)
        {
            $logsdata+=$lobj;
        }
    }

    return $logsdata;
}

Function Get-ResourceNameFromId{
    param($resourceId)

    $tempname = $idarray = $null;

    if(![string]::IsNullOrEmpty($resourceId))
    {
      $idarray = $resourceId.Split('/');
      $tempname= $idarray[$($idarray.length-1)];
    }

    $tempname;
}