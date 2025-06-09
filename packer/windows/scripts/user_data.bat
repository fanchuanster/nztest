<script>

mkdir C:\tmp 2>nul

echo Current date and time >> C:\tmp\user_data.log
echo %DATE% %TIME% >> C:\tmp\user_data.log

echo Setting Administrator password >> C:\tmp\user_data.log
net user Administrator "RUvMEK;(gjegc?VkYrcG.-4vV@u3x$rg" >> C:\tmp\user_data.log 2>&1

echo Changing LocalAccountTokenFilterPolicy registry setting >> C:\tmp\user_data.log
powershell -Command "Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'LocalAccountTokenFilterPolicy' -Value 1"
powershell -Command "if ($?) { Add-Content -Path C:\tmp\user_data.log -Value 'Registry update successful' } else { Add-Content -Path C:\tmp\user_data.log -Value 'Registry update failed' }"


</script>
