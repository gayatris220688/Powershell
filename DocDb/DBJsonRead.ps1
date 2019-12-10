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


$exobj= New-Object PSObject 
$exobj |Add-Member -MemberType NoteProperty -Name "CollectionOfferThroughput" -Value " "
$exobj | Add-Member -MemberType NoteProperty -Name "digitaltwindocdb-1" -Value " "
$exobj | Add-Member -MemberType NoteProperty -Name "Min" -Value "88"
$exobj | Add-Member -MemberType NoteProperty -Name "Max" -Value "88888"


$backtoJson =  $exobj  | ConvertTo-Json


