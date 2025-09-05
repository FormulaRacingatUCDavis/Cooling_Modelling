echo off
set LOCALHOST=%COMPUTERNAME%
set KILL_CMD="C:\PROGRA~1\ANSYSI~1\ANSYSS~1\v252\fluent/ntbin/win64/winkill.exe"

start "tell.exe" /B "C:\PROGRA~1\ANSYSI~1\ANSYSS~1\v252\fluent\ntbin\win64\tell.exe" LAPTOP-DHFQ1JFI 57154 CLEANUP_EXITING
timeout /t 1
"C:\PROGRA~1\ANSYSI~1\ANSYSS~1\v252\fluent\ntbin\win64\kill.exe" tell.exe
if /i "%LOCALHOST%"=="LAPTOP-DHFQ1JFI" (%KILL_CMD% 2408) 
if /i "%LOCALHOST%"=="LAPTOP-DHFQ1JFI" (%KILL_CMD% 11188) 
if /i "%LOCALHOST%"=="LAPTOP-DHFQ1JFI" (%KILL_CMD% 22812) 
if /i "%LOCALHOST%"=="LAPTOP-DHFQ1JFI" (%KILL_CMD% 3104) 
if /i "%LOCALHOST%"=="LAPTOP-DHFQ1JFI" (%KILL_CMD% 14764) 
if /i "%LOCALHOST%"=="LAPTOP-DHFQ1JFI" (%KILL_CMD% 5592)
del "C:\Users\Owner\Documents\GitHub\Cooling_Modelling\Subpack Conjugate Heat Transfer\Third Test\cleanup-fluent-LAPTOP-DHFQ1JFI-14764.bat"
