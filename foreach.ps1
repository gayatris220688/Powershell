
#https://www.youtube.com/watch?v=AGAtubSAoCg

$services = Get-Service

foreach ($allservices in $services) { 
  if ( $allservices.Status -imatch "Running" ) { Write-Host " All services are running" -ForegroundColor Green    }
  if ( $allservices.Status -imatch "Stopped") {Write-Host "All services are stopped"   -BackgroundColor DarkRed }
 }

 
 #for each prgram for Directory :

 $stuff = Get-ChildItem C:\LOGS\test -Recurse

 foreach ($item in $stuff)
{   
    $parent = $item.directory

    if ($item.extension -ilike ".php") 
    { Remove-Item $parent\$item}  # delete .php file from given folder 

}



