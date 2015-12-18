# This will deploy from an existing copied VHD to spin up a copy of that VM
1. Shut down the existing VM through the portal
2. Create a new resourcegroup (if needed)
3. Create a Storage account for the destination VM
4. Copy the vhd from the source VM to the destination SA for the new VM
