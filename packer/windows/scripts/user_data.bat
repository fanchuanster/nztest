<script>

mkdir C:\tmp 2>nul

echo Current date and time >> C:\tmp\user_data.log
echo %DATE% %TIME% >> C:\tmp\user_data.log

echo Setting Administrator password >> C:\tmp\user_data.log
net user Administrator "RUvMEK;(gjegc?VkYrcG.-4vV@u3x$rg" >> C:\tmp\user_data.log 2>&1

echo Changing LocalAccountTokenFilterPolicy registry setting >> C:\tmp\user_data.log
powershell -Command "Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'LocalAccountTokenFilterPolicy' -Value 1"
powershell -Command "if ($?) { Add-Content -Path C:\tmp\user_data.log -Value 'Registry update successful' } else { Add-Content -Path C:\tmp\user_data.log -Value 'Registry update failed' }"


echo Opening firewall for WinRM >> C:\tmp\user_data.log
powershell -Command "New-NetFirewallRule -Name 'AllowWinRM_HTTP' -DisplayName 'Allow WinRM HTTP' -Protocol TCP -LocalPort 5985 -Direction Inbound -Action Allow -ErrorAction SilentlyContinue"

echo Enabling PowerShell Remoting >> C:\tmp\user_data.log
powershell -Command "Enable-PSRemoting -Force -SkipNetworkProfileCheck -ErrorAction SilentlyContinue"


echo Enabling WinRM Basic Auth via PowerShell >> C:\tmp\user_data.log
powershell -Command "winrm set winrm/config/service/auth '@{Basic=\"true\"}'" >> C:\tmp\user_data.log 2>&1
if %ERRORLEVEL%==0 (
    echo WinRM AllowUnencrypted enabled successfully >> C:\tmp\user_data.log
) else (
    echo Failed to enable WinRM AllowUnencrypted >> C:\tmp\user_data.log
)

echo Enabling WinRM AllowUnencrypted via PowerShell >> C:\tmp\user_data.log
powershell -Command "winrm set winrm/config/service '@{AllowUnencrypted=\"true\"}'" >> C:\tmp\user_data.log 2>&1
if %ERRORLEVEL%==0 (
    echo WinRM AllowUnencrypted enabled successfully >> C:\tmp\user_data.log
) else (
    echo Failed to enable WinRM AllowUnencrypted >> C:\tmp\user_data.log
)

type C:\tmp\user_data.log > CON

</script>
