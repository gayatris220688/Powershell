$number = 1..100

Write-Host $number

#print odd and even number 

$number.GetType()


#---------


$a = @( "Hello world","India","Gyaatri")

Write-Host $a
Write-Host $a.Length
Write-Host $a.Count

$p = @( Get-Process )
$p

$b = 0..9

write-host $b 

Write-Host $b[0] $b[3]

$b[-3..-1]


function Get-SmallFiles {

param (
    [PSDefaultValue(Help= '100')]
    $size = 100
  )
}

function Get-Extension{

$name = $args[0] + ".txt"
$name 
}

Get-Extension myTextFile

function Switch-Item {
  param ([switch]$on)
  if ($on) { "Switch on" }
  else { "Switch off" }
}

Switch-Item -on

Switch-Item