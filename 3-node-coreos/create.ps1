#create a 3 node coreos cluster with docker
#replace with your subscription id
$subscription="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
$family=”CoreOS Alpha"
#replace with your coreos user name
$user="youruser"
#replace with your coreos user password
$password="y0urPassw0rD"
$location="West Europe"
$image=Get-AzureVMImage | where { $_.ImageFamily -eq $family } | sort PublishedDate -Descending | select -ExpandProperty ImageName -First 1
$svcname="yourcloud01"
$node01=”yournode01”
$node02="yournode02"
$node03="yournode03"
$vnetname="yourvnet01"
$vmsize=”Small”
$store="yourstore01"
$subnet="yoursubnet01"
$node01ip="10.0.1.5"
$node02ip="10.0.1.6"
$node03ip="10.0.1.7"
$cloudconfig="Z:\risto on my mac\Downloads\cloud-config.yaml"

New-AzureService -ServiceName $svcname -Location $location -Label $svcname
New-AzureStorageAccount -StorageAccountName $store -Location $location
Set-AzureStorageAccount $store
set-azuresubscription -CurrentStorageAccountName $store -SubscriptionId $subscription
$vm1=New-AzureVMConfig -Name $node01 -InstanceSize $vmsize -ImageName $image
$vm1 | Add-AzureProvisioningConfig -Linux -CustomDataFile $cloudconfig -LinuxUser $user -Password $password
$vm1 | Set-AzureSubnet -SubnetNames $subnet
$vm1 | Set-AzureStaticVNetIP -IPAddress $node01ip
New-AzureVM –ServiceName $svcname -VMs $vm1 -VNetName $vnetname
$vm2=New-AzureVMConfig -Name $node02 -InstanceSize $vmsize -ImageName $image
$vm2 | Add-AzureProvisioningConfig -Linux -CustomDataFile $cloudconfig -LinuxUser $user -Password $password
$vm2 | Set-AzureSubnet -SubnetNames $subnet
$vm2 | Set-AzureStaticVNetIP -IPAddress $node02ip
New-AzureVM –ServiceName $svcname -VMs $vm2 -VNetName $vnetname
$vm3=New-AzureVMConfig -Name $node03 -InstanceSize $vmsize -ImageName $image
$vm3 | Add-AzureProvisioningConfig -Linux -CustomDataFile $cloudconfig -LinuxUser $user -Password $password
$vm3 | Set-AzureSubnet -SubnetNames $subnet
$vm3 | Set-AzureStaticVNetIP -IPAddress $node03ip
New-AzureVM –ServiceName $svcname -VMs $vm3 -VNetName $vnetname
