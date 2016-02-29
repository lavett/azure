param (
				[Parameter(Mandatory=$true)]
        [string]
        $CredStuff
    )

		$CredsPath = "c:\bvtemp\"
		$CredsName = "bvkey.VaultCredentials"
		mkdir $CredsPath
		$SplitCredStuff = $CredStuff -split ';',2
		$GetCreds = Invoke-WebRequest -Uri $SplitCredStuff[0] -OutFile "$CredsPath$CredsName"
		$CredsFileName = "$CredsPath$CredsName"
		#$CredWriteFile = $CredStuff | Add-Content -Path c:\bvtemp\bvkey.VaultCredentials
		#$CredFile = c:\bvtemp\$($SplitCredStuff[1])

		Invoke-WebRequest -Uri http://aka.ms/azurebackup_agent -outfile $CredsPath"MARSAgentInstaller.exe"

		# Install Mars Agent
		Start-Process -FilePath "C:\bvtemp\MARSAgentInstaller.exe" -ArgumentList "/q"
		start-sleep 30
		import-module "C:\Program Files\Microsoft Azure Recovery Services Agent\bin\Modules\MSOnlineBackup"
		# Register VM to Vault
		Start-OBRegistration -VaultCredentials $CredsFileName -Confirm:$false
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
		#$exclusions = New-OBFileSpec -FileSpec @("C:\windows") -Exclude
		Add-OBFileSpec -Policy $newpolicy -FileSpec $inclusions
		#Add-OBFileSpec -Policy $newpolicy -FileSpec $exclusions
		# Remove old policies of the VM and Apply the policy
		#Get-OBPolicy | Remove-OBPolicy -Confirm:$false
		Set-OBPolicy -Policy $newpolicy -Confirm:$false
		# Start a manual backup
		Get-OBPolicy | Start-OBBackup
		Remove-Item -Recurse -Force $CredsPath
