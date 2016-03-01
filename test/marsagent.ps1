param (
				[Parameter(Mandatory=$true)]
        [string]
        $CredStuff
    )

		$CredsPath = "C:\bvtemp\"
		$CredsName = "bvtemp.VaultCredentials"
		$CredsFileName = "$CredsPath$CredsName"
		$MarsFile = "$CredsPath+MARSAgentInstaller.exe"
		mkdir $CredsPath
		$SplitCredStuff = $CredStuff -split ';'
		$GetCreds = Invoke-WebRequest -Uri $SplitCredStuff[0] -OutFile $CredsFileName
		$BVString = $SplitCredStuff[2]

		#$CredWriteFile = $CredStuff | Add-Content -Path c:\bvtemp\bvkey.VaultCredentials
		#$CredFile = c:\bvtemp\$($SplitCredStuff[1])

		Invoke-WebRequest -Uri http://aka.ms/azurebackup_agent -outfile $MarsFile

		# Install Mars Agent
		$MarsFile /q
		start-sleep 60
		import-module "C:\Program Files\Microsoft Azure Recovery Services Agent\bin\Modules\MSOnlineBackup"
		# Register VM to Vault
		Start-OBRegistration -VaultCredentials $CredsFileName -Confirm:$false
		# Set no proxy
		Set-OBMachineSetting -NoProxy
		# Se no bandwidth limit
		Set-OBMachineSetting -NoThrottle
		# Set Encryption Passphrase
		ConvertTo-SecureString -String $BVString -AsPlainText -Force | Set-OBMachineSetting
		# Create new policy and schedule
		$newpolicy = New-OBPolicy
		$sched = New-OBSchedule -DaysofWeek Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday -TimesofDay 01:00
		Set-OBSchedule -Policy $newpolicy -Schedule $sched
		# Configure retention policy
		$retentionpolicy = New-OBRetentionPolicy -RetentionDays 31
		Set-OBRetentionPolicy -Policy $newpolicy -RetentionPolicy $retentionpolicy
		# Exclude and/or include files and directories
		$inclusions = New-OBFileSpec -FileSpec @("C:\Packages", "D:\")
		#$exclusions = New-OBFileSpec -FileSpec @("C:\windows") -Exclude
		Add-OBFileSpec -Policy $newpolicy -FileSpec $inclusions
		#Add-OBFileSpec -Policy $newpolicy -FileSpec $exclusions
		# Remove old policies of the VM and Apply the policy
		#Get-OBPolicy | Remove-OBPolicy -Confirm:$false
		Set-OBPolicy -Policy $newpolicy -Confirm:$false
		# Remove CredStuff
		Remove-Item -Recurse -Force $CredsPath
		# Start a manual backup
		#Get-OBPolicy | Start-OBBackup
