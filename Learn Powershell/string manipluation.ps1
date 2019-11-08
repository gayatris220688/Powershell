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