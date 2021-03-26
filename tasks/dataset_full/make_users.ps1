$lines = (gc ./u.user.txt)

$uri = "https://fakerapi.it/api/v1/persons?_quantity=943&_birthday_start=2005-01-01"
$data = ((Invoke-WebRequest -URI $uri).Content | ConvertFrom-Json).data
$n = 0
$data | ForEach-Object {
    $n++
    "$n|$($_.firstname) $($_.lastname)|$($_.email)|$($_.gender)|$($_.birthday)|$($lines[$n-1].split("|")[3])"
    }

# $lines | ForEach-Object {$occupation = $_.split("|"); $occupation[3]}
