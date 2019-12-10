Function AuthenticateLoginToAzureService{

try{
    $pscredential = Get-Credential
    if($pscredential.UserName -match "@mindtree.com")
    {$subscriptionInfo = Connect-AzAccount -Credential $pscredential -TenantId "mindtreeonline.onmicrosoft.com"}
    else
    {$subscriptionInfo = Connect-AzAccount -Credential $pscredential -TenantId "akanshaagarwaloutlookcom.onmicrosoft.com"}
   }
catch
   {
    Invoke-Logger -string "[ERROR]: $($_.Exception.Message)" 
   }

return $subscriptionInfo;
}

Function AuthenticateLoginToAzureServiceSubscription{
param($subscriptionId)

   try{
       $pscredential = Get-Credential
       if($pscredential.UserName -match "@mindtree.com")
       {$subscriptionInfo = Connect-AzAccount -Credential $pscredential -TenantId "mindtreeonline.onmicrosoft.com" -Subscription $subscriptionId}
       else
       {$subscriptionInfo = Connect-AzAccount -Credential $pscredential -TenantId "microsoft.onmicrosoft.com" -Subscription $subscriptionId}
      }
   catch
      {
       Invoke-Logger -string "[ERROR]: $($_.Exception.Message)" 
      }
   
   return $subscriptionInfo;
   }