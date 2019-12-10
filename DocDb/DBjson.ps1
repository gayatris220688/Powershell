param(
    [Parameter(Mandatory=$True, Position=1)]
    [string] $PoolName,

    [Parameter(Mandatory=$True, Position=2)]
    [Int] $Max,

    [Parameter(Mandatory=$True, Position=3)]
    [Int] $Min
)


$mainJson =  "C:\GithubPersonal\DocDb\MainJson.json"
$valueJson = "C:\GithubPersonal\DocDb\ValueJson.json" 


$main = Get-Content -Path $mainJson  | ConvertFrom-Json
$value = Get-Content -Path $valueJson  | ConvertFrom-Json

foreach($doc in $main.DocDbPools)
{
    $resourcePools = $doc.resourcePools | Select CollectionOfferThroughput;

    if ($PoolName -eq "digitaltwindocdb-1")
{
    foreach($resource in $resourcePools)
    {
       $resource.CollectionOfferThroughput.Min = $Min;
       $resource.CollectionOfferThroughput.scenarios = $Max;
    }
}

}
$main | ConvertTo-Json | Out-File "C:\Users\v-gasana\Desktop\SampleOutpu43.json" 

