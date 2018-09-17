$dockers = (Invoke-RestMethod -Uri 'https://go.microsoft.com/fwlink/?LinkID=825636&clcid=0x409')
$dockers.versions.$($dockers.channels.edge.version)
$dockers.channels

$dockers.versions.$($dockers.channels.test.version)