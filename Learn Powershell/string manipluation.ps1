$cow = "My name is Gayatri "

$cow

#to print in lower case
$cow.ToLower()

#to print in upper case
$cow.ToUpper()

#if it containes same word output will be true 
$cow.Contains("is")


#get item with name array from directory

Get-ChildItem | Where-Object{$_.Name.Contains("array")}

#get all items from directory 

Get-ChildItem

dir

Get-ChildItem |Where-Object{$_.Name.Tolower().Contains("file")}

Get-ChildItem
$result= Get-Content -Path "C:\GithubPersonal\Learn Powershell\name & copy.txt"

$result


Get-ChildItem |Where-Object{$_.Name.Contains("&")}
Get-ChildItem | Where-Object {$_.Name.Contains("&")} | ForEach-Object {Rename-Item $_ -NewName $_.Name.Replace("&","AND")}

Get-ChildItem

$cow | Get-Member
