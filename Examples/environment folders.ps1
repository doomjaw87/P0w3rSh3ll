#[enum]::GetNames([System.Environment+specialfolder])

[enum]::getnames([system.environment+specialfolder]) |
    Select-Object @{Name       = 'Name'
                    Expression = {$_}},

                  @{Name       = 'Path'
                    Expression = {[Environment]::GetFolderPath($_)}}

$myDocuments = [Environment]::GetFolderPath('MyDocuments')


