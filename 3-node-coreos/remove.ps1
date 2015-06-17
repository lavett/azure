#delete created coreos cluster
$svcname="yourcloud01"
$node01=”yournode01”
$node02="yournode02"
$node03="yournode03"
$store="yourstore01"

$disk1=Get-Azuredisk | where { $_.DiskName -match "-$node01" } | select -ExpandProperty Diskname | sort -Descending | select -First 1
$disk2=Get-Azuredisk | where { $_.DiskName -match "-$node02" } | select -ExpandProperty Diskname | sort -Descending | select -First 1
$disk3=Get-Azuredisk | where { $_.DiskName -match "-$node03" } | select -ExpandProperty Diskname | sort -Descending | select -First 1
remove-azurevm -name $node01 -servicename $svcname
remove-azurevm -name $node02 -servicename $svcname
remove-azurevm -name $node03 -servicename $svcname
remove-azuredisk -diskname $disk1
remove-azuredisk -diskname $disk2
remove-azuredisk -diskname $disk3
remove-azurestorageaccount -StorageAccountName $store
remove-azureservice -force -ServiceName $svcname
