# Win-11-LTSC-Scripts
Scripts for Windows 11 LTSC users to restore and enhance functionality

## Enable Classic Photo Viewer + WebP Support

### 1. Add PowerShell to Right-Click Context Menu on Windows 11 LTSC
- Run `powershell-context-win11.reg` to add PowerShell to the right-click menu

### 2. Enable Classic Photo Viewer
1. Run the provided registry file to restore Windows Photo Viewer Classic
2. Note: Windows 11 LTSC security settings may prevent automatic file associations - manual association might be needed

### 3. Add WebP Support
1. Download required files from [EnableClassicViewer folder](https://github.com/captainzero93/Win-11-LTSC-Scripts/tree/main/EnableClassicViewer):
   - Microsoft.UI.Xaml.2.7.appx
   - Microsoft.VCLibs.x64.14.00.Desktop.appx
   - Microsoft.WebpImageExtension_1.1.1221.0_neutral_~_8wekyb3d8bbwe.AppxBundle

2. Open elevated PowerShell in the download folder:
```powershell
Start-Process powershell -Verb RunAs -ArgumentList "-NoExit", "-Command cd '$PWD'"
```

3. Install components in order:
```powershell
Add-AppxPackage -Path "Microsoft.UI.Xaml.2.7.appx"
Add-AppxPackage -Path "Microsoft.VCLibs.x64.14.00.Desktop.appx"
Add-AppxPackage -Path "Microsoft.WebpImageExtension_1.1.1221.0_neutral_~_8wekyb3d8bbwe.AppxBundle"
```

### Extra
- Remove quick context menu; Open CMD/Powershell as Admin: reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
- Reboot.
- Remove / Reinstall Snip tool ( win + alt + s ) to install a software that has automatic saving like 11 Home

  
