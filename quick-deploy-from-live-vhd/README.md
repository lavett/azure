# ! NOT COMPLETE ! This will deploy from an existing copied VHD to spin up a copy of that VM
1. Shut down the existing VM through the portal
2. Create a new resourcegroup (if needed)
3. Create a Storage account for the destination VM
4. Copy the vhd from the source VM to the destination SA for the new VM (easy with AzCopy)
C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy> ./AzCopy.exe /Source:https://NAMEOFSOURCESA.blob.core.windows.net/vhds /Dest:https://NAMEOFDESTSA.blob.core.windows.net/vhds /SourceKey:SAKEY /DestKey:SAKEY /Pattern:NAMEOFOSDISK.vhd
5. Open the portal and click "new" go through compute and below you should have deploy from template
6. Paste in the code from redeploy-main.json in the edit template section.
7. Fill in the other information and click create.
8. After the deployment is finished you should have a copy of your source server up and running.
