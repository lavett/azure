# Create an Image from existing VM
1. Log in to the new VM
2. Run sysprep with OOBE, generalize and shutdown option
3. Run stop from the azure portal on the VM
4. Copy the vhd to central SA where image will reside
C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy> ./AzCopy.exe /Source:https://NAMEOFSOURCESA.blob.core.windows.net/vhds /Dest:https://NAMEOFDESTSA.blob.core.windows.net/vhds /SourceKey:SAKEY /DestKey:SAKEY /Pattern:NAMEOFOSDISK.vhd
5. Now you should be able to deploy new VM from image
