@echo off
echo Removing Snipping Tool...

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

:: Kill any running instances
echo Stopping Snipping Tool processes...
taskkill /F /IM "ScreenClippingHost.exe" 2>nul
taskkill /F /IM "SnippingTool.exe" 2>nul

:: Remove app package
echo Removing Snipping Tool package...
powershell -Command "Get-AppxPackage *Microsoft.ScreenSketch* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *Microsoft.SnippingTool* | Remove-AppxPackage" 2>nul

:: Disable Win+Shift+S hotkey
echo Disabling Snipping Tool hotkey...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisabledHotkeys" /t REG_SZ /d "S" /f

:: Remove from context menu
echo Removing from context menu...
reg delete "HKEY_CLASSES_ROOT\PackagedCom\Package\Microsoft.ScreenSketch_8wekyb3d8bbwe" /f 2>nul

:: Clean up registry entries
echo Cleaning registry entries...
reg delete "HKCU\SOFTWARE\Microsoft\ScreenSketch" /f 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\ScreenSketch.exe" /f 2>nul

echo.
echo Snipping Tool has been removed/disabled.
echo Note: You may need to restart your computer for all changes to take effect.
echo.
echo Press any key to exit...
pause >nul