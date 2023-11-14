@echo off
setlocal enabledelayedexpansion
title Windows Utility Tool

REM function for checking if the script is running as administrator
:isAdmin
net session >nul 2>&1
if %errorLevel% == 0 (
    goto menu
) else (
    echo.
    echo This script must be run as Administrator.
    echo.
    echo Press any key to exit...
    pause > nul
    exit
)

REM function for disclaimer and agreement
:agreement
cls
echo ========================================================================================
echo The author intended this program to be used for Windows 10/11 only.
echo This program is provided as-is, without warranty of any kind, express or implied.
echo In no event shall the author be held liable for any damages arising from the use of this software.
echo ========================================================================================
echo.
echo By using this program, you agree to the terms and conditions stated above.
echo.
set /p agree="Do you agree? (Y/N): "
if /i not !agree! == Y (
    echo Exiting...
    timeout /t 2 > nul
    exit
)
else if /i !agree! == Y (
    goto menu
)

REM function for main menu
:menu
cls
echo ========================================================================================
echo             A Simple Windows 10/11 Utility Tool Written in Batch Script
echo                                    Made by: Russel
echo ========================================================================================
echo.
echo Choose an option:
echo 1 - Format A Disk (NTFS)
echo 2 - Check for Corrupt or Missing System Files
echo 3 - Check for Disk Errors
echo 4 - Microsoft Windows Defender Scan
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

REM function for formatting a disk
:formatProcess
cls
echo ========================================================================================
echo             A Simple Windows 10/11 Utility Tool Written in Batch Script
echo                                    Made by: Russel
echo ========================================================================================
REM List all disks using diskpart
echo Listing available disks using diskpart:
REM Store the output in a text file to be read by diskpart
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
    echo.
    echo Returning to the main menu...
    timeout /t 2 > nul
    goto menu
)
echo ========================================================================================

cls
REM Ask for the drive letter
REM displays the volumes to give users the idea of used drive letters to avoid conflicts
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
echo ========================================================================================
echo             A Simple Windows 10/11 Utility Tool Written in Batch Script
echo                                    Made by: Russel
echo ========================================================================================
echo.
echo Formatting disk %diskNumber%...
echo WAIT PATIENTLY TILL THE PROCESS IS COMPLETED.
pause

REM Actual formatting process starts here
REM Store details in a text file
REM selects disk
echo select disk %diskNumber% > diskpart_script.txt
REM cleans / formats the disk
echo clean >> diskpart_script.txt
REM creates new partition
echo create partition primary >> diskpart_script.txt
REM formats the partition using NTFS file system
echo format fs=ntfs label="%diskName%" quick >> diskpart_script.txt
REM assigns the drive letter
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

REM function for sfc menu
:sfcProcess
cls
echo ========================================================================================
echo             A Simple Windows 10/11 Utility Tool Written in Batch Script
echo                                    Made by: Russel
echo ========================================================================================
echo.
echo Make sure to have an Internet connection when using DISM tool to avoid errors.
echo.
echo Choose your preferred option:
echo 1 - Scan and repair using System File Checker (SFC) Tool only
echo 2 - Scan and repair using Deployment Image Servicing and Management (DISM) Tool only
echo 3 - Scan and repair using DISM and SFC Tools (Recommended)
echo 4 - Go back to the main menu
echo.
set /P "choice=Enter your choice: "

if %choice%==1 goto sfcProcessOnly
if %choice%==2 goto dismProcessOnly
if %choice%==3 goto sfcAndDismProcess
if %choice%==4 goto menu

echo Invalid choice. Please try again.
timeout /t 2 > nul
goto sfcProcess

REM function for sfc only
:sfcProcessOnly
cls
echo ========================================================================================
echo             A Simple Windows 10/11 Utility Tool Written in Batch Script
echo                                    Made by: Russel
echo ========================================================================================
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

REM function for dism only
:dismProcessOnly
cls
echo ========================================================================================
echo             A Simple Windows 10/11 Utility Tool Written in Batch Script
echo                                    Made by: Russel
echo ========================================================================================
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
    REM the filepath asked to the user earlier will be used as the source directory
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

REM function for sfc and dism
:sfcAndDismProcess
cls
echo ========================================================================================
echo             A Simple Windows 10/11 Utility Tool Written in Batch Script
echo                                    Made by: Russel
echo ========================================================================================
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

REM function for chkdsk menu
:chkdskProcess
cls
echo ========================================================================================
echo             A Simple Windows 10/11 Utility Tool Written in Batch Script
echo                                    Made by: Russel
echo ========================================================================================
echo.
echo Choose your preferred option:
echo 1 - Scan only
echo 2 - Finds and attempts to repair corrupted portions of your disk. (Repair mode)
echo 3 - Attempts to fix bugs or errors while scanning the hard drive. (Fix mode)
echo 4 - Perform both repair and fix mode. (Recommended)
echo 5 - Go back to the main menu
echo.
set /P "choice=Enter your choice: "

if %choice%==1 goto chkdskScanProcess
if %choice%==2 goto chkdskRepairProcess
if %choice%==3 goto chkdskFixProcess
if %choice%==4 goto chkdskRepairAndFixProcess
if %choice%==5 goto menu

echo Invalid choice. Please try again.
timeout /t 2 > nul
goto chkdskProcess

REM function for scanning only
:chkdskScanProcess
cls
echo ========================================================================================
echo             A Simple Windows 10/11 Utility Tool Written in Batch Script
echo                                    Made by: Russel
echo ========================================================================================
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

REM function for scan and repair mode
:chkdskRepairProcess
cls
echo ========================================================================================
echo             A Simple Windows 10/11 Utility Tool Written in Batch Script
echo                                    Made by: Russel
echo ========================================================================================
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

REM function for scan and fix mode
:chkdskFixProcess
cls
echo ========================================================================================
echo             A Simple Windows 10/11 Utility Tool Written in Batch Script
echo                                    Made by: Russel
echo ========================================================================================
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

REM function for scan, repair and fix mode
:chkdskRepairAndFixProcess
cls
echo ========================================================================================
echo             A Simple Windows 10/11 Utility Tool Written in Batch Script
echo                                    Made by: Russel
echo ========================================================================================
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

REM function for Microsoft Windows Defender Scan menu
:MDOSProcess
cls
echo ========================================================================================
echo             A Simple Windows 10/11 Utility Tool Written in Batch Script
echo                                    Made by: Russel
echo ========================================================================================
echo.
echo Choose your preferred option:
echo 1 - Quick Scan
echo 2 - Full Scan
echo 3 - Go back to the main menu
echo.
set /P "choice=Enter your choice: "

if %choice%==1 goto MDOSQuickScanProcess
if %choice%==2 goto MDOSFullScanProcess
if %choice%==3 goto menu

echo Invalid choice. Please try again.
timeout /t 2 > nul
goto MDOSProcess

REM function for quick scan
:MDOSQuickScanProcess
cls
echo ========================================================================================
echo             A Simple Windows 10/11 Utility Tool Written in Batch Script
echo                                    Made by: Russel
echo ========================================================================================
echo.
echo Please exit all programs before scanning.
pause
echo.
echo Scanning using Microsoft Windows Defender...
echo WAIT PATIENTLY TILL THE PROCESS IS COMPLETED.
echo ========================================================================================
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1
echo ========================================================================================
echo.
echo Scanning completed successfully.
echo Press any key to go back to the main menu.
pause > nul
goto menu

REM function for full scan
:MDOSFullScanProcess
cls
echo ========================================================================================
echo             A Simple Windows 10/11 Utility Tool Written in Batch Script
echo                                    Made by: Russel
echo ========================================================================================
echo.
echo Please exit all programs before scanning.
pause
echo.
echo Scanning using Microsoft Windows Defender...
echo WAIT PATIENTLY TILL THE PROCESS IS COMPLETED.
echo ========================================================================================
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
echo ========================================================================================
echo.
echo Scanning completed successfully.
echo Press any key to go back to the main menu.
pause > nul
goto menu

REM function for Windows Defender Repair menu
:WinDefRepairProcess
cls
echo ========================================================================================
echo             A Simple Windows 10/11 Utility Tool Written in Batch Script
echo                                    Made by: Russel
echo ========================================================================================
echo.
echo Attempting to repair Microsoft Windows Defender...
echo WAIT PATIENTLY TILL THE PROCESS IS COMPLETED.
REM Reinstalls and Resets Windows Defender
echo ========================================================================================
Powershell -ExecutionPolicy Bypass -Command "Get-AppxPackage Microsoft.SecHealthUI -AllUsers | Reset-AppxPackage"
echo Repairing completed successfully. If the problem still persists, try to reboot your PC.
echo ========================================================================================
echo.
echo Press any key to go back to the main menu.
pause > nul
goto menu

REM function for restarting the PC
:restartProcess
cls
echo ========================================================================================
echo             A Simple Windows 10/11 Utility Tool Written in Batch Script
echo                                    Made by: Russel
echo ========================================================================================
echo.
echo Please save all your work before restarting your PC.
echo.
echo Restarting your PC...
pause
shutdown /r /t 0






