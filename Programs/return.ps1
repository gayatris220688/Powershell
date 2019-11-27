function MultiplyEven
{
    param($number)

    if ($number % 2) { return "$number is not even" }
    $number * 2
}

1..10 | ForEach-Object {MultiplyEven -Number $_}

function Test-Return
{
    $array = 1,2,3
    return $array
}
Test-Return | Measure-Object

try { NonsenseString }
catch { "An error occurred." }