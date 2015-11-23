$SUBname = "Subscription Name"
$VMname = "VM Name"
$RGname = "Resourcegroup Name"
$DiskSizeInGB = "1023"

Login-AzureRmAccount -SubscriptionName $SUBname
$VM = get-azurermvm -name $VMname -ResourceGroupName $RGname
$VM.StorageProfile[0].OSDisk[0].DiskSizeGB = $DiskSizeInGB
Write-Verbose "Stopping VM $($VM.Name)."
Stop-AzureRmVM -Name $VM.Name -ResourceGroupName $VM.ResourceGroupName -Force
Write-Verbose "Updating VM $($VM.Name)."
Update-AzureRmVM -VM $VM -ResourceGroupName $VM.ResourceGroupName
Write-Verbose "Starting VM $($VM.Name)."
Start-AzureRmVM -Name $VM.Name -ResourceGroupName $VM.ResourceGroupName
