param(
    [Parameter(Mandatory=$false, Position=1)]
    [string] $subscriptionId,

    [Parameter(Mandatory=$True, Position=2)]
    [Int] $Major,

    [Parameter(Mandatory=$True, Position=3)]
    [Int] $Minor
)


$Jsonpath = "C:\GithubPersonal\Json\test.json"

#refer - https://stackoverflow.com/questions/37558792/convertfrom-json-invalid-json-primitive

$Json = Get-Content -Path $Jsonpath  | Out-String | ConvertFrom-Json


$params = @();
$params = $($Json.PSVersion | Get-Member -MemberType *Property).Name  

Write-Host $params


