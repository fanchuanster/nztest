<powershell>
New-Item -Path "C:\Temp" -ItemType Directory -Force
Add-Content -Path "C:\Temp\user_data.log" -Value "Current date and time: $(Get-Date)"

Add-Content -Path "C:\Temp\user_data.log" -Value "Setting Administrator password"
net user Administrator "RUvMEK;(gjegc?VkYrcG.-4vV@u3x$rg" >> C:\Temp\user_data.log 2>&1

Add-Content -Path "C:\Temp\user_data.log" -Value "Changing LocalAccountTokenFilterPolicy"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "LocalAccountTokenFilterPolicy" -Value 1

if ($?) {
    Add-Content -Path "C:\Temp\user_data.log" -Value "Registry update successful"
} else {
    Add-Content -Path "C:\Temp\user_data.log" -Value "Registry update failed"
}

Add-Content -Path "C:\Temp\user_data.log" -Value "Creating self-signed certificate for WinRM HTTPS"
$cert = New-SelfSignedCertificate -DnsName "$env:COMPUTERNAME" -CertStoreLocation "cert:\LocalMachine\My"
$thumb = $cert.Thumbprint

Add-Content -Path "C:\Temp\user_data.log" -Value "Configuring WinRM HTTPS listener"
try {
    $existingListeners = winrm enumerate winrm/config/Listener | Select-String "Transport = HTTPS"
    if ($existingListeners) {
        cmd /c 'winrm delete winrm/config/Listener?Address=*+Transport=HTTPS'
        Add-Content -Path "C:\Temp\user_data.log" -Value "Existing HTTPS listener deleted"
    }
} catch {
    Add-Content -Path "C:\Temp\user_data.log" -Value "Failed to delete existing HTTPS listener: $_"
}
try {
    New-Item -Path WSMan:\LocalHost\Listener -Transport HTTPS -Address * -CertificateThumbprint $thumb -Port 5986 -Force
    Add-Content -Path "C:\Temp\user_data.log" -Value "HTTPS listener created successfully"
} catch {
    Add-Content -Path "C:\Temp\user_data.log" -Value "Failed to create HTTPS listener: $_"
}

# Enable Basic Auth and disable unencrypted WinRM
winrm set winrm/config/service/auth @{Basic="true"}
winrm set winrm/config/service @{AllowUnencrypted="false"}

# Open firewall port 5986 (only if rule doesn't already exist)
if (-not (Get-NetFirewallRule -Name "AllowWinRM_HTTPS" -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule -Name "AllowWinRM_HTTPS" `
      -DisplayName "Allow WinRM over HTTPS" `
      -Protocol TCP `
      -LocalPort 5986 `
      -Direction Inbound `
      -Action Allow
    Add-Content -Path "C:\Temp\user_data.log" -Value "Created WinRM HTTPS firewall rule"
} else {
    Add-Content -Path "C:\Temp\user_data.log" -Value "WinRM HTTPS firewall rule already exists"
}

$log = Get-Content -Path "C:\Temp\user_data.log" -Raw
[System.IO.File]::WriteAllText('COM1:', "`r`n==== USER DATA LOG START ====`r`n" + $log + "`r`n==== USER DATA LOG END ====`r`n")


</powershell>
