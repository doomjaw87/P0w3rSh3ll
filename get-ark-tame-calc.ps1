$t = Invoke-WebRequest https://www.dododex.com/taming/rex/200?taming=8 -usebasicparsing
$bow = ((($t.Content -Split 'alt="bow"')[1] -split '<div class="knockCount">')[1] -split '</div>')[0]
"bow: $bow"

$cbow = ((($t.Content -Split 'alt="crossbow"')[1] -split '<div class="knockCount">')[1] -split '</div>')[0]
"cbow: $cbow"

$tdart = ((($t.Content -Split 'alt="Tranquilizer Dart"')[1] -split '<div class="knockCount">')[1] -split '</div>')[0]
"tdart: $tdart"

$sdart = ((($t.Content -Split 'alt="Shocking Tranquilizer Dart"')[1] -split '<div class="knockCount">')[1] -split '</div>')[0]
"sdart: $sdart"

$kibble = (((($t.Content -split 'img src="/media/item/Kibble.png"')[1] -split '/>')[0] -split 'alt="')[1]) -split ('"')[0]
"kibble: $kibble"

$kqty   = (($t.Content -split '<td class="center">')[1] -split '</td>')[0]
"kqty: $kqty"

$ktime = (((($t.Content -split 'img src="/media/item/Kibble.png"')[1] -split '<td class="centerImg">')[0] -split '<td class="center">')[2] -split '</td>')[0]
"ktime: $ktime"

BREAK
CLS

