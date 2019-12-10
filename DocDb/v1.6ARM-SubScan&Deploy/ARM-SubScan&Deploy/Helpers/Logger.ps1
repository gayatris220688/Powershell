Function Invoke-Logger {
    param
    (
       $string
    )
    $timestring = (get-date -DisplayHint DateTime -Format "dd-MM-yyyy hh:mm:ss")
    $filepath = $((Get-Location).Path) +"\Logs\ARMScanner-LogFile_" + $(get-date -DisplayHint DateTime -Format "dd-MM-yyyy-hh-mm") + ".txt"
    $writemsg = $timestring +"  ->  "+ $string
    $writemsg | Out-File -Append $filepath
    Write-Host $writemsg -ForegroundColor Green
}