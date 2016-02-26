param (

	[Parameter(Mandatory=$true)]
        [string]
        $CredStuff
    )
mkdir c:\temp
$CredsPath = "c:\temp\"
$marsurl = "http://aka.ms/azurebackup_agent"
$marsfile = "MARSAgentInstaller.exe"
#Invoke-WebRequest -Uri $marsurl -OutFile $CredsPath + $marsfile
Invoke-WebRequest -Uri http://aka.ms/azurebackup_agent -outfile c:\temp\MARSAgentInstaller.exe
$SplitCredStuff = $CredStuff -split ';'
$credsfilename = Invoke-WebRequest -Uri $SplitCredStuff[0] -OutFile c:\temp\$($SplitCredStuff[1])
$cred = $credspath + $credsfilename

# Install Mars Agent
cmd /c C:\temp\MARSAgenInstaller.exe /q
import-module MSOnlineBackup
# Register VM to Vault
Start-OBRegistration -VaultCredentials $cred -Confirm:$false
# Set no proxy
Set-OBMachineSetting -NoProxy
# Se no bandwidth limit
Set-OBMachineSetting -NoThrottle
# Set Encryption Passphrase
ConvertTo-SecureString -String "Complex!123_STRING" -AsPlainText -Force | Set-OBMachineSetting
# Create new policy and schedule
$newpolicy = New-OBPolicy
$sched = New-OBSchedule -DaysofWeek Saturday, Sunday -TimesofDay 13:00
Set-OBSchedule -Policy $newpolicy -Schedule $sched
# Configure retention policy
$retentionpolicy = New-OBRetentionPolicy -RetentionDays 7
Set-OBRetentionPolicy -Policy $newpolicy -RetentionPolicy $retentionpolicy
# Exclude and/or include files and directories
$inclusions = New-OBFileSpec -FileSpec @("C:\", "D:\")
$exclusions = New-OBFileSpec -FileSpec @("C:\windows", "C:\temp") -Exclude
Add-OBFileSpec -Policy $newpolicy -FileSpec $inclusions
Add-OBFileSpec -Policy $newpolicy -FileSpec $exclusions
# Remove old policies of the VM and Apply the policy
Get-OBPolicy | Remove-OBPolicy -Confirm:$false
Set-OBPolicy -Policy $newpolicy -Confirm:$false
# Start a manual backup
Get-OBPolicy | Start-OBBackup





#Remove-Item -Recurse -Force c:\temp
