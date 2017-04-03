Param(
  [string]$identity, 
  [string]$filePath 
)
function colorgreen {process { Write-Host $_ -ForegroundColor Green }}
function colorred {process { Write-Host $_ -ForegroundColor Red }}
function setRandomPassword {
	$Password = Get-Random -Min 10000000 -Max 99999999
	$Passwd = ConvertTo-Securestring $password -asplaintext -force
	Set-ADAccountPassword -Identity $identity -NewPassword $Passwd -Reset
	Write-Output "Password set to $Password for user $identity" | colorgreen
}

if ($identity) {
	$usercheck = Get-ADUser -LDAPFilter "(sAMAccountName=$identity)" 
	if ($usercheck -eq $null) {
		Write-Output "$identity not found in AD" | colorred
	}
	else {
		setRandomPassword
	}
}
elseif ($filePath) {
	if (Test-Path $filePath) {
		$users 		= Get-Content $filePath
		echo "Reading $filePath..."; sleep 2
		foreach ($identity in $users) {
			$usercheck = Get-ADUser -LDAPFilter "(sAMAccountName=$identity)" 
			if ($usercheck -eq $null) {
				Write-Output "$identity not found in AD" | colorred
			}
			else {
				setRandomPassword
			}
		}
	} else {
		Write-Output "$filePath cannot be found" | colorred
	}
}
else {
Write-Output "Use by adding -identity or -filePath." | colorred
echo "
SYNTAX
    .\reset-passwd.ps1 -identity <username>
		Will reset password for AD user (8 random numbers).
		
    .\reset-passwd.ps1 -filePath list.txt
		Will reset password for every user in list.txt. One
		username per row (8 random numbers). 
	
"
}