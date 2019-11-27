
$var =  "5"

if ( $var -eq 5) 

{write-host "This is true "}



$var = 2

if ($var -ne 2)
{ Write-Host "This is correct"}

else { Write-Host "This is not correct" }


$var = "MONDAY"

if ($var -eq "Wednsady") 

       { Write-Host "Data is correct"}

    elseif ($var -ne "Tuesday")
    
      { write-host "Data may be correct"}

    elseif ($var -ceq "MONDAY")
       {write-host " May be its wrong"}

    else {Write-Host " All vale varies"}

