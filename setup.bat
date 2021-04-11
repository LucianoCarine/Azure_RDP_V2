@echo off
title VPS_Azure
echo Downloading all files....
curl --silent -O https://raw.githubusercontent.com/taodicakhia/Azure_RDP_V2/master/App.zip
powershell -command "Expand-Archive -Force App.zip"
curl --silent -O https://raw.githubusercontent.com/dcatoday/ngrok/master/ngrok.exe
copy ngrok.exe C:\Windows\System32 >nul
start NGROK.bat >nul
curl -s ifconfig.me >ip.txt
set /p IP=<ip.txt
curl -s ipinfo.io/%IP%?token=52e07b22f25013 >full.txt
type full.txt | jq -r .country >region.txt
type full.txt | jq -r .city >location.txt
set /p LO=<location.txt
set /p RE=<region.txt
if %RE%==US (start ngrok tcp 3389)
if %RE%==CA (start ngrok tcp 3389)
if %RE%==HK (start ngrok tcp --region ap 3389)
if %RE%==SG (start ngrok tcp --region ap 3389)
if %RE%==NL (start ngrok tcp --region eu 3389)
if %RE%==IE (start ngrok tcp --region eu 3389)
if %RE%==GB (start ngrok tcp --region eu 3389)
if %RE%==BR (start ngrok tcp --region sa 3389)
if %RE%==AU (start ngrok tcp --region au 3389)
if %RE%==IN (start ngrok tcp --region in 3389)
cd App
IDM.exe /SILENT
7z.exe /S
del /f "C:\Users\Public\Desktop\Epic Games Launcher.lnk" > out.txt 2>&1
net config server /srvcomment:"Windows Azure VM" > out.txt 2>&1
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /V EnableAutoTray /T REG_DWORD /D 0 /F > out.txt 2>&1
net user administrator taodicakhia /add >nul
net localgroup administrators administrator /add >nul
net user administrator /active:yes >nul
echo Location: %LO%
net user installer /delete
diskperf -Y >nul
sc config Audiosrv start= auto >nul
sc start audiosrv >nul
ICACLS C:\Windows\Temp /grant administrator:F >nul
ICACLS C:\Windows\installer /grant administrator:F >nul
echo IP:
tasklist | find /i "ngrok.exe" >Nul && curl -s localhost:4040/api/tunnels | jq -r .tunnels[0].public_url || echo "Can't get NGROK tunnel, please paste new NGROK TOKEN in YML. Check Tunnel here: https://dashboard.ngrok.com/status/tunnels " && exit
echo User: administrator
echo Pass: taodicakhia
ping -n 999999 10.10.0.10 >nul
