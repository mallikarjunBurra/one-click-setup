# change directory to user downloads
cd $ENV:UserProfile\Downloads
# download latest winget installer
$ProgressPreference = 'SilentlyContinue'; $t = Invoke-WebRequest 'https://api.github.com/repos/microsoft/winget-cli/releases/latest' -UseBasicParsing; $null = ($t.content -Match ',"content_type":"application/octet-stream",.*?"browser_download_url":"(.*\.msixbundle)"'); Invoke-WebRequest $Matches[1] -OutFile .\winget-latest.msixbundle;
# lookup prerequisites
$pre = Invoke-WebRequest "https://store.rg-adguard.net/api/GetFiles" -Method POST -Body @{type='CategoryId';url='f855810c-9f77-45ff-a0f5-cd0feaa945c6';ring='Retail';lang='en-US;q=0.6'} -UseBasicParsing
# download prerequisites
# Microsoft.UI.Xaml
$null = ($pre.content -Match '<td><a href="(.*?)" rel="noreferrer">Microsoft\.UI\.Xaml\.2\.7_7\.2207\.21001\.0_x64__8wekyb3d8bbwe\.appx<\/a><\/td>'); Invoke-WebRequest $Matches[1] -OutFile .\Microsoft.UI.Xaml.appx;
$null = ($pre.content -Match '<td><a href="(.*?)" rel="noreferrer">Microsoft\.VCLibs\.140\.00\.UWPDesktop_14\.0\.30704\.0_x64__8wekyb3d8bbwe\.appx<\/a><\/td>'); Invoke-WebRequest $Matches[1] -OutFile .\Microsoft.VCLibs.appx;
$null = ($pre.content -Match '<td><a href="(.*?)" rel="noreferrer">Microsoft\.DesktopAppInstaller_2022\.728\.1939\.0_neutral_~_8wekyb3d8bbwe\.msixbundle<\/a><\/td>'); Invoke-WebRequest $Matches[1] -OutFile .\Microsoft.DesktopAppInstaller.msixbundle; $ProgressPreference = 'Continue';
# install prerequisites
Add-AppxPackage .\Microsoft.UI.Xaml.appx
Add-AppxPackage .\Microsoft.VCLibs.appx
Add-AppxPackage .\Microsoft.DesktopAppInstaller.msixbundle
# install winget
Add-AppxPackage .\winget-latest.msixbundle

Write-Output "Winget installed and ready to be used."