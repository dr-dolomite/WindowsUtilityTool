@echo off
setlocal enabledelayedexpansion
title Windows Utility Tool

:menu
cls
echo ===========================================
echo     A Simple Windows 10/11 Utility Tool
echo          written in batch script
echo ===========================================
echo Choose an option:
echo 1 - Format A Disk
echo 2 - Check for Corrupt or Missing System Files
echo 3 - Check for Disk Errors
echo 4 - Microsoft Defender Offline Scan
echo 5 - Repair Windows Defender
echo 6 - Restart PC
echo 7 - Exit
echo.
set /P "choice=Enter your choice: "

if %choice%==1 goto formatProcess
if %choice%==2 goto sfcProcess
if %choice%==3 goto chkdskProcess
if %choice%==4 goto MDOSProcess
if %choice%==5 goto WinDefRepairProcess
if %choice%==6 goto restartProcess
if %choice%==7 (
    echo Exiting...
    timeout /t 2 > nul
    exit
)
else (
    echo Invalid choice. Please try again.
    timeout /t 2 > nul
    goto menu
)

:formatProcess
cls
echo ===========================================
echo     A Simple Windows 10/11 Utility Tool
echo          written in batch script
echo ===========================================
REM List all disks using diskpart
echo Listing available disks using diskpart:
echo list disk > list_disks.txt
diskpart /s list_disks.txt

echo.
echo ========================================================================================
REM Ask for the disk number to format
set /p diskNumber="Enter the disk number you want to format: "

REM Confirm the selected disk
set /p confirm="Are you sure you want to format disk %diskNumber%? (Y/N): "
if /i not !confirm! == Y (
    echo Formatting canceled.
    exit /b
)
echo ========================================================================================

cls
REM Ask for the drive letter
echo list volume > list_volumes.txt
diskpart /s list_volumes.txt
echo.
echo ========================================================================================
echo DO NOT USE DRIVE LETTER THAT ARE ALREADY IN USED BY OTHER DRIVES DISPLAYED ABOVE.
set /p driveLetter="Enter the drive letter for the new disk: "

REM Ask for new disk name
set /p diskName="Enter a name for the new disk: "
echo ========================================================================================
echo.
cls
echo ===========================================
echo     A Simple Windows 10/11 Utility Tool
echo          written in batch script
echo ===========================================
echo.
echo Formatting disk %diskNumber%...
echo WAIT PATIENTLY TILL THE PROCESS IS COMPLETED.
pause

REM Store details in a text file
echo select disk %diskNumber% > diskpart_script.txt
echo clean >> diskpart_script.txt
echo create partition primary >> diskpart_script.txt
echo format fs=ntfs label="%diskName%" quick >> diskpart_script.txt
echo assign letter=%driveLetter% >> diskpart_script.txt
echo exit >> diskpart_script.txt

REM Format the disk using diskpart
diskpart /s diskpart_script.txt

REM Cleanup temporary files
del diskpart_script.txt

echo.
echo ========================================================================================
echo Formatting completed successfully.
echo Press any key to go back to the main menu.
pause > nul
goto menu

:sfcProcess
cls
echo ===========================================
echo     A Simple Windows 10/11 Utility Tool
echo          written in batch script
echo ===========================================
echo.
echo Choose your preferred option:
echo 1 - Scan and repair using System File Checker (SFC) Tool only
echo 2 - Scan and repair using Deployment Image Servicing and Management (DISM) Tool only
echo 3 - Scan and repair using DISM and SFC Tools (Need Internet)
echo 4 - Go back to the main menu
echo.
set /P "choice=Enter your choice: "

if %choice%==1 ( goto sfcProcessOnly )
else if %choice%==2 ( goto dismProcessOnly )
else if %choice%==3 ( goto sfcAndDismProcess )
else if %choice%==4 ( goto menu )
else (
    echo Invalid choice. Please try again.
    timeout /t 2 > nul
    goto sfcProcess
)

:sfcProcessOnly
cls
echo ===========================================
echo     A Simple Windows 10/11 Utility Tool
echo          written in batch script
echo ===========================================
echo.
echo Scanning and repairing using System File Checker (SFC) Tool...
echo WAIT PATIENTLY TILL THE PROCESS IS COMPLETED.
echo ========================================================================================
sfc /scannow
echo ========================================================================================
echo.
echo Scanning and repairing completed successfully.
echo Press any key to go back to the main menu.
pause > nul
goto menu

:dismProcessOnly
cls
echo ===========================================
echo     A Simple Windows 10/11 Utility Tool
echo          written in batch script
echo ===========================================
echo.
set /p answer="Is your Windows Update Client working properly? (Y/N): "
if /i not !answer! == Y (
    echo.
    echo Using Repair Source
    set /p sourceFolder="Enter the path to the repair source folder (Ex: C:\RepairSource\Windows): "
    pause
    echo.
    echo Scanning and repairing using Deployment Image Servicing and Management (DISM) Tool...
    echo WAIT PATIENTLY TILL THE PROCESS IS COMPLETED.
    echo ========================================================================================
    DISM.exe /Online /Cleanup-Image /RestoreHealth /Source:"%sourceFolder%" /LimitAccess
    echo ========================================================================================
    echo.
    echo Scanning and repairing completed successfully.
    echo Press any key to go back to the main menu.
    pause > nul
    goto menu
)
else if /i !answer! == Y (
    echo.
    echo Scanning and repairing using Deployment Image Servicing and Management (DISM) Tool...
    echo WAIT PATIENTLY TILL THE PROCESS IS COMPLETED.
    echo ========================================================================================
    dism /online /cleanup-image /restorehealth
    echo ========================================================================================
    echo.
    echo Scanning and repairing completed successfully.
    echo Press any key to go back to the main menu.
    pause > nul
    goto menu
)

:sfcAndDismProcess
cls
echo ===========================================
echo     A Simple Windows 10/11 Utility Tool
echo          written in batch script
echo ===========================================
echo.
echo Scanning and repairing using DISM and SFC...
echo WAIT PATIENTLY TILL THE PROCESS IS COMPLETED.
echo ========================================================================================
dism /online /cleanup-image /restorehealth
sfc /scannow
echo ========================================================================================
echo.
echo Scanning and repairing completed successfully.
echo Press any key to go back to the main menu.
pause > nul
goto menu

:chkdskProcess
cls
echo ===========================================
echo     A Simple Windows 10/11 Utility Tool
echo          written in batch script
echo ===========================================
echo.
echo Choose your preferred option:
echo 1 - Scan only
echo 2 - Finds and attempts to repair corrupted portions of your disk. (Repair mode)
echo 3 - Attempts to fix bugs or errors while scanning the hard drive. (Fix mode)
echo 4 - Perform both repair and fix mode. (Recommended)
echo 5 - Go back to the main menu
echo.
set /P "choice=Enter your choice: "

if %choice%==1 ( goto chkdskScanProcess )
else if %choice%==2 ( goto chkdskRepairProcess )
else if %choice%==3 ( goto chkdskFixProcess )
else if %choice%==4 ( goto chkdskRepairAndFixProcess )
else if %choice%==5 ( goto menu )
else (
    echo Invalid choice. Please try again.
    timeout /t 2 > nul
    goto chkdskProcess
)

:chkdskScanProcess
cls
echo ===========================================
echo     A Simple Windows 10/11 Utility Tool
echo          written in batch script
echo ===========================================
echo.
echo Scanning using Check Disk (CHKDSK) Tool...
echo WAIT PATIENTLY TILL THE PROCESS IS COMPLETED.
echo ========================================================================================
chkdsk
echo ========================================================================================
echo.
echo Scanning disk completed successfully.
echo Press any key to go back to the main menu.
pause > nul
goto menu

:chkdskRepairProcess
cls
echo ===========================================
echo     A Simple Windows 10/11 Utility Tool
echo          written in batch script
echo ===========================================
echo.
echo Scanning and repairing using Check Disk (CHKDSK) Tool...
echo WAIT PATIENTLY TILL THE PROCESS IS COMPLETED.
echo ========================================================================================
chkdsk /r
echo ========================================================================================
echo.
echo Scanning and repairing disk completed successfully.
echo Press any key to go back to the main menu.
pause > nul
goto menu

:chkdskFixProcess
cls
echo ===========================================
echo     A Simple Windows 10/11 Utility Tool
echo          written in batch script
echo ===========================================
echo.
echo Scanning and fixing using Check Disk (CHKDSK) Tool...
echo WAIT PATIENTLY TILL THE PROCESS IS COMPLETED.
echo ========================================================================================
chkdsk /f
echo ========================================================================================
echo.
echo Scanning and fixing disk completed successfully.
echo Press any key to go back to the main menu.
pause > nul
goto menu

:chkdskRepairAndFixProcess
cls
echo ===========================================
echo     A Simple Windows 10/11 Utility Tool
echo          written in batch script
echo ===========================================
echo.
set /p answer="Dismount disk before scanning? (Y/N): "
if /i not !answer! == Y (
    echo.
    echo Scanning and repairing using Check Disk (CHKDSK) Tool...
    echo WAIT PATIENTLY TILL THE PROCESS IS COMPLETED.
    echo ========================================================================================
    chkdsk /r /f
    echo ========================================================================================
    echo.
    echo Scanning and repairing disk completed successfully.
    echo Press any key to go back to the main menu.
    pause > nul
    goto menu
)
else if /i !answer! == Y (
    echo.
    echo Scanning and repairing using Check Disk (CHKDSK) Tool...
    echo WAIT PATIENTLY TILL THE PROCESS IS COMPLETED.
    echo ========================================================================================
    chkdsk /f /r /x
    echo ========================================================================================
    echo.
    echo Scanning and repairing disk completed successfully.
    echo Press any key to go back to the main menu.
    pause > nul
    goto menu
)

:MDOSProcess
cls
echo ===========================================
echo     A Simple Windows 10/11 Utility Tool
echo          written in batch script
echo ===========================================
echo.
echo Make sure you have saved all your work before continuing.
set /p answer="Do you want continue? This will restart your PC and perform a scan. (Y/N): "
if /i not !answer! == Y (
    echo.
    echo Microsoft Defender Offline Scan canceled.
    echo Press any key to go back to the main menu.
    pause > nul
    goto menu
) else if /i !answer! == Y (
    echo.
    echo Scanning using Microsoft Defender Offline Scan...
    echo WAIT PATIENTLY TILL THE PROCESS IS COMPLETED.
    echo ========================================================================================
    "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 3
    echo ========================================================================================
    echo.
    echo Scanning completed successfully.
    echo Press any key to go back to the main menu.
    pause > nul
    goto menu
) else (
    echo Invalid choice. Please try again.
    timeout /t 2 > nul
    goto MDOSProcess
)







