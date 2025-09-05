echo off
set LOCALHOST=%COMPUTERNAME%
set KILL_CMD="C:\PROGRA~1\ANSYSI~1\ANSYSS~1\v252\fluent/ntbin/win64/winkill.exe"

start "tell.exe" /B "C:\PROGRA~1\ANSYSI~1\ANSYSS~1\v252\fluent\ntbin\win64\tell.exe" LAPTOP-DHFQ1JFI 56825 CLEANUP_EXITING
timeout /t 1
"C:\PROGRA~1\ANSYSI~1\ANSYSS~1\v252\fluent\ntbin\win64\kill.exe" tell.exe
if /i "%LOCALHOST%"=="LAPTOP-DHFQ1JFI" (%KILL_CMD% 9744) 
if /i "%LOCALHOST%"=="LAPTOP-DHFQ1JFI" (%KILL_CMD% 24504) 
if /i "%LOCALHOST%"=="LAPTOP-DHFQ1JFI" (%KILL_CMD% 24632) 
if /i "%LOCALHOST%"=="LAPTOP-DHFQ1JFI" (%KILL_CMD% 13784) 
if /i "%LOCALHOST%"=="LAPTOP-DHFQ1JFI" (%KILL_CMD% 10860) 
if /i "%LOCALHOST%"=="LAPTOP-DHFQ1JFI" (%KILL_CMD% 4080)
del "C:\Users\Owner\Documents\GitHub\Cooling_Modelling\Subpack Conjugate Heat Transfer\Third Test\cleanup-fluent-LAPTOP-DHFQ1JFI-10860.bat"
