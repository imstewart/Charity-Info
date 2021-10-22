$regfile = Import-Csv -Path reg.xml
$regfile | fl
$regfile | where reg -Like "$*"