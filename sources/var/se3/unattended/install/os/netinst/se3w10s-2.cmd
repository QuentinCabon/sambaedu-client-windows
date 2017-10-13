:: phase 2 : mise au domaine SE3
:: 
@echo off
pushd %SystemDrive%\netinst
time /T >> logs\unattend.log
echo phase 2: mise au domaine >> logs\unattend.log
call se3w10-vars.cmd
net use * /delete /yes
:integ
echo on attend un peu avant d'integrer le poste...
ping -n 10 %SE3IP%
cscript //B joindomain.vbs /d:"%SE3_DOMAIN%" /p:"%XPPASS%" 
if %errorlevel% neq 0 (
   echo ERREUR %errorlevel% LORS DE LA JONCTION A %SE3_DOMAIN% >> logs\unattend.log
   set /P OK=tenter a nouveau l'integration (O/n)?
   if %OK% neq n goto integ
   set /A "PHASE=PHASE-1"
   exit
)
echo phase 2: mise au domaine OK >> logs\unattend.log
::reg.exe add "HKey_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SE3install" /d "%systemdrive%\Netinst\se3w10-3.cmd" /F
%SystemRoot%\system32\shutdown.exe -r -t 3  -c "Le poste %ComputerName% va rebooter sur le domaine %SE3_DOMAIN%"
