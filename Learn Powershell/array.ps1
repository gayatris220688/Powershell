$array = 1,2,3,4

$subarray = 1..4

$subarray

$array

$array.GetType()

$intA

$A = 1,2,3,4,5,6
Write-Host "display array"

$A.getType()
Write-Host "Display array type"

$A.Length
Write-Host " Get length of array "

$A.Count
Write-Host "Total count of array "

$A[1]
Write-Host "Get second element of array "

$subarray=$A[1,2,3,4]

Write-Host "Get partial array "
$subarray

Write-Host "Using for loop"

for ($i=0; $i -le ($A.Length -1); $i +=1) {
   $A[$i]
}
