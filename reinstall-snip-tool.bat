@echo off
echo Attempting to restore Snipping Tool...

:: Check for admin rights
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

:: Enable Developer Mode
echo Enabling Developer Mode...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"

:: Restore from Windows Image
echo Attempting to restore from Windows Image...
DISM /Online /Add-Capability /CapabilityName:Windows.Client.ShellComponents~~~~0.0.1.0

:: Attempt to reinstall via AppX
echo Attempting to reinstall via AppX...
powershell -Command "Get-AppxPackage -allusers Microsoft.ScreenSketch | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register '$($_.InstallLocation)\AppXManifest.xml'}" 2>nul
powershell -Command "Get-AppxPackage -allusers Microsoft.Windows.ScreenSketch | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register '$($_.InstallLocation)\AppXManifest.xml'}" 2>nul

:: Try to restore from system location
echo Attempting to restore from system files...
powershell -Command "Add-AppxPackage -Register 'C:\Windows\SystemApps\Microsoft.ScreenSketch_8wekyb3d8bbwe\AppxManifest.xml' -DisableDevelopmentMode" 2>nul

:: Re-enable Win+Shift+S hotkey
echo Restoring Snipping Tool hotkey...
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisabledHotkeys" /f 2>nul

:: Restore registry settings
echo Restoring registry settings...
reg add "HKCU\SOFTWARE\Microsoft\ScreenSketch" /v "AutoSaveEnabled" /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\ScreenSketch" /v "AutoSaveLocation" /t REG_SZ /d "%USERPROFILE%\Pictures" /f

:: Try deploying from original package
echo Attempting package deployment...
powershell -Command "Add-AppxProvisionedPackage -Online -PackagePath 'C:\Windows\SystemApps\Microsoft.ScreenSketch_8wekyb3d8bbwe' -SkipLicense" 2>nul

echo.
echo Restoration attempts completed.
echo Testing Snipping Tool launch...
timeout /t 2 /nobreak >nul

:: Try to launch Snipping Tool
start ms-screenclip: || (
    echo.
    echo NOTE: If Snipping Tool doesn't launch, you may need to:
    echo 1. Run 'sfc /scannow' as administrator
    echo 2. Restart your computer
    echo 3. If issues persist, you might need to run:
    echo    DISM /Online /Cleanup-Image /RestoreHealth
)

echo.
echo Would you like to run System File Checker now? (Y/N)
choice /C YN /N /M "Run SFC scan now?"
if errorlevel 2 goto END
if errorlevel 1 goto SFC

:SFC
echo.
echo Running System File Checker...
sfc /scannow

:END
echo.
echo Press any key to exit...
pause >nul