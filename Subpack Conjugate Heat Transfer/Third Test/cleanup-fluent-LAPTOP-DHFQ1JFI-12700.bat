echo off
set LOCALHOST=%COMPUTERNAME%
set KILL_CMD="C:\PROGRA~1\ANSYSI~1\ANSYSS~1\v252\fluent/ntbin/win64/winkill.exe"

start "tell.exe" /B "C:\PROGRA~1\ANSYSI~1\ANSYSS~1\v252\fluent\ntbin\win64\tell.exe" LAPTOP-DHFQ1JFI 56330 CLEANUP_EXITING
timeout /t 1
"C:\PROGRA~1\ANSYSI~1\ANSYSS~1\v252\fluent\ntbin\win64\kill.exe" tell.exe
if /i "%LOCALHOST%"=="LAPTOP-DHFQ1JFI" (%KILL_CMD% 19900) 
if /i "%LOCALHOST%"=="LAPTOP-DHFQ1JFI" (%KILL_CMD% 27612) 
if /i "%LOCALHOST%"=="LAPTOP-DHFQ1JFI" (%KILL_CMD% 15868) 
if /i "%LOCALHOST%"=="LAPTOP-DHFQ1JFI" (%KILL_CMD% 23948) 
if /i "%LOCALHOST%"=="LAPTOP-DHFQ1JFI" (%KILL_CMD% 12700) 
if /i "%LOCALHOST%"=="LAPTOP-DHFQ1JFI" (%KILL_CMD% 18384)
del "C:\Users\Owner\Documents\GitHub\Cooling_Modelling\Subpack Conjugate Heat Transfer\Third Test\cleanup-fluent-LAPTOP-DHFQ1JFI-12700.bat"
