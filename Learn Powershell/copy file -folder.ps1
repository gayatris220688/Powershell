Copy-Item 'C:\Learn Powershell\create file.ps1' 'C:\Learn Powershell\create file1.ps1' 

Remove-Item 'C:\Learn Powershell\create file1.ps1' 

Copy-Item 'C:\Learn Powershell\create file.ps1' -Destination 'C:\LOGS'

