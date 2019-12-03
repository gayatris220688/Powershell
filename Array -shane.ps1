$array = @()

$array

$processes = Get-Process

foreach ($proc in $processes)
{
    If ($proc.ws/1mb -gt 100)
    {
        $array  += New-Object psobject -Property @{'ProcessName' = $proc.name ; 'Workingset' = $proc.ws }
    }
}