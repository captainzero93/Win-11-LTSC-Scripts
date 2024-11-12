# Win-11-LTSC-Scripts
Scripts for aveage users who like the LTSC version but have issues

## Enable Classic Image Viewer
Add  Powershell to right click context menu Win11LTSC, run powershell-context-win11.reg

## Enable Classic Image Viewer

.bat that will re-enable Photo Viewer Classic 

Due to security settings many programs will not automatically be allowed to create default associations using Windows 11 LTSC, this just makes it a bit less painless for ImageGlass ( and adds the association for Thumbnails ).

Add .webP support;

Download Microsoft.WebpImageExtension_1.1.1221.0_neutral_~_8wekyb3d8bbwe.AppxBundle

Open Powershell as Admin in the same folder as that file ( see above .reg).

First elevate this to Admin: Start-Process powershell -Verb RunAs -ArgumentList "-NoExit", "-Command cd '$PWD'"

Add-AppxPackage -Path "Microsoft.UI.Xaml.2.7.appx"

Add-AppxPackage -Path "Microsoft.VCLibs.140.00_14.0.30704.0_x64.appx"

Add-AppxPackage -Path "Microsoft.WebpImageExtension_1.1.1221.0_neutral_~_8wekyb3d8bbwe.AppxBundle" 
