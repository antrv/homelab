Install-Module posh-git -Confirm:$False -Force
Install-Module Terminal-Icons -Confirm:$False -Force
Install-Module PSFzf -Confirm:$False -Force

". `"$PSScriptRoot\Profile.ps1`"" | Out-File -FilePath "${Env:USERPROFILE}\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
