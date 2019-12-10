Function Set-LibraryValidationOnHost{

param($listOflib)

Write-Host "#################### STARTING SCRIPT PRE-REQUISITES CHECK ########################" -ForegroundColor Yellow

    foreach($lib in $listOflib)
    {
        if((Get-InstalledModule -Name $($lib.Library) -MinimumVersion $($lib.Version) -ErrorAction SilentlyContinue ).Name.Count -ge 1){$isInstalled = $true}else{$isInstalled=$false}

        if($isInstalled -eq $false)
        {
          Write-Host "[WARNING]: Library: $($lib.Library) with version :  $($lib.Version) missing on host machine. Looking up the library in Powershell Gallery for installation..." -ForegroundColor Red
          
          Write-Host "[WARNING]: Library: $($lib.Library) with version :  $($lib.Version) is being installed on this host machine ! PLEASE WAIT ! ..." -ForegroundColor Red
          Start-Process powershell.exe -Verb Runas -ArgumentList "Install-Module -Name $($lib.Library) -MinimumVersion $($lib.Version) -Force" -Wait -WindowStyle Hidden
          Write-Host "[VERBOSE]: Installed library: $($lib.Library) with version :  $($lib.Version) ..." -ForegroundColor Yellow    
        }
        else {
            Write-Host "[VERBOSE]: Library: $($lib.Library) with version :  $($lib.Version) present on your host machine & is ready to be used ..." -ForegroundColor Green      
        }
    }

    Write-Host "#################### COMPLETED SCRIPT PRE-REQUISITES CHECK ########################" -ForegroundColor Yellow
}