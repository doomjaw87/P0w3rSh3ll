$dino = 'rex'
$level = 200
$tmultiplier = 8

$allDinos = @(
    @{name='achatina';         type='h'; method='k'},
    @{name='allosaurus';       type='c'; method='k'},
    @{name='anglerfish';       type='c'; method='k'},
    @{name='ankylosaurus';     type='h'; method='k'},
    @{name='araneo';           type='s'; method='p'},
    @{name='archaeopteryx';    type='s'; method='k'},
    @{name='argentavis';       type='c'; method='k'},
    @{name='arthropluera';     type='s'; method='p'},
    @{name='baryonyx';         type='p'; method='k'},
    @{name='basilisk';         type='s'; method='p'},
    @{name='basilosaurus';     type='c'; method='p'},
    @{name='beelzebufo';       type='c'; method='k'},
    @{name='brontosaurus';     type='h'; method='k'},
    @{name='bulbdog';          type='c'; method='p'},
    @{name='carbonemys';       type='h'; method='k'},
    @{name='carnotaurus';      type='c'; method='k'},
    @{name='castoroides';      type='h'; method='k'},
    @{name='chalicotherium';   type='s'; method='p'},
    @{name='compy';            type='c'; method='k'},
    @{name='daeodon';          type='c'; method='k'},
    @{name='dilophosaur';      type='c'; method='k'},
    @{name='dimetrodon';       type='c'; method='k'},
    @{name='dimorphodon';      type='c'; method='k'},
    @{name='diplocaulus';      type='c'; method='k'},
    @{name='diplodocus';       type='h'; method='p'},
    @{name='direbear';         type='c'; method='k'},
    @{name='direwolf';         type='c'; method='k'},
    @{name='dodo';             type='h'; method='k'},
    @{name='doedicurus';       type='h'; method='k'},
    @{name='dung beetle';      type='s'; method='p'},
    @{name='dunkleosteus';     type='c'; method='k'},
    @{name='electrophorus';    type='s'; method='p'},
    @{name='equus';            type='h'; method='p'},
    @{name='featherlight';     type='c'; method='p'},
    @{name='gallimimus';       type='h'; method='k'},
    @{name='giant bee';        type='s'; method='p'},
    @{name='giganotosaurus';   type='c'; method='k'},
    @{name='gigantopithecus';  type='h'; method='p'},
    @{name='glowtail';         type='c'; method='p'},
    @{name='griffin';          type='c'; method='k'},
    @{name='hesperonis';       type='s'; method='p'},
    @{name='hyaenodon';        type='s'; method='p'},
    @{name='ichthyornis';      type='f'; method='k'},
    @{name='ichthyosaurus';    type='c'; method='p'},
    @{name='iguanodon';        type='h'; method='k'},
    @{name='jerboa';           type='h'; method='k'},
    @{name='kairuku';          type='f'; method='k'},
    @{name='kaprosuchus';      type='c'; method='k'},
    @{name='karkinos';         type='s'; method='k'},
    @{name='kentrosaurus';     type='h'; method='k'},
    @{name='lymantria';        type='h'; method='k'},
    @{name='lystrosaurus';     type='h'; method='p'},
    @{name='mammoth';          type='h'; method='k'},
    @{name='manta';            type='s'; method='p'},
    @{name='mantis';           type='s'; method='k'},
    @{name='megalania';        type='c'; method='k'},
    @{name='megaloceros';      type='h'; method='k'},
    @{name='megalodon';        type='c'; method='k'},
    @{name='megalosaurus';     type='c'; method='k'},
    @{name='megatherium';      type='c'; method='k'},
    @{name='mesopithecus';     type='h'; method='p'},
    @{name='microraptor';      type='c'; method='k'},
    @{name='morellatops';      type='h'; method='k'},
    @{name='mosasaurus';       type='c'; method='k'},
    @{name='moschops';         type='s'; method='p'},
    @{name='onyc';             type='c'; method='p'},
    @{name='otter';            type='f'; method='p'},
    @{name='oviraptor';        type='s'; method='k'},
    @{name='ovis';             type='h'; method='p'},
    @{name='pachy';            type='h'; method='k'},
    @{name='pachyrhinosaurus'; type='h'; method='k'},
    @{name='paraceratherium';  type='h'; method='k'},
    @{name='parasaur';         type='h'; method='k'},
    @{name='pegomastax';       type='s'; method='p'},
    @{name='pelagornis';       type='f'; method='k'},
    @{name='phiomia';          type='h'; method='k'},
    @{name='plesiosaur';       type='c'; method='k'},
    @{name='procoptodon';      type='h'; method='k'},
    @{name='pteranodon';       type='c'; method='k'},
    @{name='pulmonoscorpius';  type='s'; method='k'},
    @{name='purlovia';         type='c'; method='k'},
    @{name='quetzal';          type='c'; method='k'},
    @{name='raptor';           type='c'; method='k'},
    @{name='ravager';          type='c'; method='k'},
    @{name='rex';              type='c'; method='k'},
    @{name='rock elemental';   type='s'; method='k'},
    @{name='roll rat';         type='s'; method='p'},
    @{name='sabertooth';       type='c'; method='k'},
    @{name='sarco';            type='c'; method='k'},
    @{name='shinehorn';        type='h'; method='p'},
    @{name='spinosaur';        type='c'; method='k'},
    @{name='stegosaurus';      type='h'; method='k'},
    @{name='tapejara';         type='c'; method='k'},
    @{name='tek raptor';       type='c'; method='k'},
    @{name='tek rex';          type='c'; method='k'},
    @{name='tek stegosaurus';  type='h'; method='k'},
    @{name='terror bird';      type='c'; method='k'},
    @{name='therizinosaur';    type='h'; method='k'},
    @{name='thorny dragon';    type='c'; method='k'},
    @{name='thylacoleo';       type='c'; method='k'},
    @{name='titanoboa';        type='s'; method='p'},
    @{name='triceratops';      type='h'; method='k'},
    @{name='troodon';          type='s'; method='p'},
    @{name='tusoteuthis';      type='s'; method='p'},
    @{name='vulture';          type='s'; method='p'},
    @{name='woolly rhino';     type='h'; method='k'},
    @{name='yutyrannus';       type='c'; method='k'}
)

$dinoObj = $allDinos | where {$_.name -eq $dino}

if ($dinoObj)
{
    $data = New-Object -TypeName System.Text.StringBuilder
    $data.Append("$($dinoObj.name)|Level: $($level)|Taming: $($tmultiplier)|")
    $uri = "https://www.dododex.com/taming/$($dinoObj.name)/$($level.ToString())?taming=$($tmultiplier.ToString())"
    $response = Invoke-WebRequest -Uri $uri -UseBasicParsing

    switch ($dinoObj.method)
    {
        'p'
        {

        }

        'k'
        {
            $bow    = ((($t.Content -Split 'alt="bow"')[1] -split '<div class="knockCount">')[1] -split '</div>')[0]
            $cbow   = ((($t.Content -Split 'alt="crossbow"')[1] -split '<div class="knockCount">')[1] -split '</div>')[0]
            $tdart  = ((($t.Content -Split 'alt="Tranquilizer Dart"')[1] -split '<div class="knockCount">')[1] -split '</div>')[0]
            $sdart  = ((($t.Content -Split 'alt="Shocking Tranquilizer Dart"')[1] -split '<div class="knockCount">')[1] -split '</div>')[0]
            $kibble = (((($t.Content -split 'img src="/media/item/Kibble.png"')[1] -split '/>')[0] -split 'alt="')[1]) -split ('"')[0]
            $kqty   = (($t.Content -split '<td class="center">')[1] -split '</td>')[0]
            $ktime  = (((($t.Content -split 'img src="/media/item/Kibble.png"')[1] -split '<td class="centerImg">')[0] -split '<td class="center">')[2] -split '</td>')[0]
            $data.Append("Bow: $($bow)|Crossbow: $($cbow)|Tranq Dart: $($tdart)|Shocking Tranq Dart: $($sdart)|Favorite Kibble: $($kibble)|Kibble Qty: $($kqty)|Kibble Tame Time: $($ktime)")
        }
    }
}
else
{
    "did not find source dino data"
}


BREAK

if ($dino -in $allDinos.name)
{
    
}
else
{
    $false
}



$t = Invoke-WebRequest "https://www.dododex.com/taming/$($dino)/$($level.ToString())?taming=$($tmultiplier.ToString())" -usebasicparsing
$bow = ((($t.Content -Split 'alt="bow"')[1] -split '<div class="knockCount">')[1] -split '</div>')[0]
"bow: $bow"


"cbow: $cbow"


"tdart: $tdart"


"sdart: $sdart"


"kibble: $kibble"


"kqty: $kqty"


"ktime: $ktime"

BREAK
CLS

