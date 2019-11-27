
#odd Number

1..20 | % { if( $_ % 2 -eq 1) { Write-Host $_ odd Numbers } }

# Even Number 

1..20 | % { if( $_ % 2 -eq 0) { Write-Host $_ even Numbers } }