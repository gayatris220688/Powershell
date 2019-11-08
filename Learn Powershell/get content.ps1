#Get-Content 'C:\Learn Powershell\move file.ps1'

$result =Get-Content 'C:\Learn Powershell\move file.ps1'

$path = 'C:\AzureIoTLive\test\Microsoft.Azure.Devices.Common.Test\AmqpSelectorFilter.cs'

$res = Get-Content -Path $path

foreach($item in $res)
{
    Write-Host $item
}

Write-Host $result

