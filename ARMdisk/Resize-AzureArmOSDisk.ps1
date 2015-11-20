<#
.SYNOPSIS
Used to resize a vhd on an Azure ARM VM.
.DESCRIPTION
This function is used to resize an existing data disk on an Azure ARM VM.
It takes a PSVirtualMachine object as a parameter. The DiskIndex is the intended
disk. Ranges 0 for the first, 1 for the second, and so on.
.EXAMPLE
To resize the size of the first available data disk to a size of 1023 GB.
Resize-AzureArmOSDisk -VM VMObject -DiskIndex 0 -DiskSizeInGB 1023
#>
function Resize-AzureArmOSDisk
{
    [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact="High")]

    param(
        [Parameter(Mandatory=$True)]
        [Microsoft.Azure.Commands.Compute.Models.PSVirtualMachine]$VM,
        [Parameter(Mandatory=$True)][int]$DiskIndex,
        [Parameter(Mandatory=$True)][int]$DiskSizeInGB
    )

    Begin
    {

    }
    Process
    {
        if ($pscmdlet.ShouldProcess($($VM.Name)))
        {
            $VM.StorageProfile[0].OSDisk[$DiskIndex].DiskSizeGB = $DiskSizeInGB
            Write-Verbose "Stopping VM $($VM.Name)."
            Stop-AzureRmVM -Name $VM.Name -ResourceGroupName $VM.ResourceGroupName -Force
            Write-Verbose "Updating VM $($VM.Name)."
            Update-AzureRmVM -VM $VM -ResourceGroupName $VM.ResourceGroupName
            Write-Verbose "Starting VM $($VM.Name)."
            Start-AzureRmVM -Name $VM.Name -ResourceGroupName $VM.ResourceGroupName
        }
        else
        {
            Write-Verbose "Operation halted."
        }
    }
    End
    {

    }
}
