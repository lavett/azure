Used to resize a OSdisk on an Azure ARM VM.

This function is used to resize an existing OS disk on an Azure ARM VM.
It takes a PSVirtualMachine object as a parameter. The DiskIndex is the intended
disk. Ranges 0 for the first, 1 for the second, and so on.

EXAMPLE
To resize the size of the first available data disk to a size of 1023 GB.
Resize-AzureArmOSDisk -VM VMObject -DiskIndex 0 -DiskSizeInGB 1023
