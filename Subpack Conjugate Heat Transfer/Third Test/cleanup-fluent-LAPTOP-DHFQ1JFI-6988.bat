echo off
set LOCALHOST=%COMPUTERNAME%
set KILL_CMD="C:\PROGRA~1\ANSYSI~1\ANSYSS~1\v252\fluent/ntbin/win64/winkill.exe"

start "tell.exe" /B "C:\PROGRA~1\ANSYSI~1\ANSYSS~1\v252\fluent\ntbin\win64\tell.exe" LAPTOP-DHFQ1JFI 51888 CLEANUP_EXITING
timeout /t 1
"C:\PROGRA~1\ANSYSI~1\ANSYSS~1\v252\fluent\ntbin\win64\kill.exe" tell.exe
if /i "%LOCALHOST%"=="LAPTOP-DHFQ1JFI" (%KILL_CMD% 24828) 
if /i "%LOCALHOST%"=="LAPTOP-DHFQ1JFI" (%KILL_CMD% 14992) 
if /i "%LOCALHOST%"=="LAPTOP-DHFQ1JFI" (%KILL_CMD% 6072) 
if /i "%LOCALHOST%"=="LAPTOP-DHFQ1JFI" (%KILL_CMD% 3676) 
if /i "%LOCALHOST%"=="LAPTOP-DHFQ1JFI" (%KILL_CMD% 6988) 
if /i "%LOCALHOST%"=="LAPTOP-DHFQ1JFI" (%KILL_CMD% 27484)
del "C:\Users\Owner\Documents\GitHub\Cooling_Modelling\Subpack Conjugate Heat Transfer\Third Test\cleanup-fluent-LAPTOP-DHFQ1JFI-6988.bat"
