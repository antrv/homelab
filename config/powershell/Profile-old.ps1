# Install Modules
# Oh-My-Posh - makes command prompt nice
#winget install JanDeDobbeleer.OhMyPosh
# posh-git - suggestions for git commands
#Install-Module posh-git -Confirm:$False -Force
# Terminal-Icons - small nice icons for file types in the listings
#Install-Module Terminal-Icons -Confirm:$False -Force
# PSFzf - fuzzy file and history search
#winget install junegunn.fzf
#Install-Module PSFzf -Confirm:$False -Force
# ajeetdsouza.zoxide - smart cd command, autojumps
#winget install ajeetdsouza.zoxide
#bat,eza

function IsWindowsTerminal ($childProcess) {
    If (!$childProcess) {
        return $false
    } elseif ($childProcess.ProcessName -eq 'WindowsTerminal') {
        return $true
    } elseif ($childProcess.ProcessName -eq 'wezterm-gui') {
        return $true
    } else {
        return IsWindowsTerminal -childProcess $childProcess.Parent
    }
}

If (!(IsWindowsTerminal -childProcess (Get-Process -Id $PID)))
{
    Exit
}

# Set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# Oh-My-Posh
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/mytheme.omp.json" | Invoke-Expression
Import-Module posh-git

# PSReadLine
Import-Module PSReadLine
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -EditMode Windows
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

# Fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# Others
Import-Module Terminal-Icons
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# Aliases
function List-Dir { eza -a --group-directories-first --git --icons -B }
function List-DirLong { eza -a --long --group-directories-first --git --icons -B }
Set-Alias ls List-Dir
Set-Alias ll List-DirLong
Set-Alias grep findstr
Set-Alias less 'C:\Program Files\git\usr\bin\less.exe'
Set-Alias tig 'C:\Program Files\git\usr\bin\tig.exe'
Set-Alias vim 'C:\Program Files\git\usr\bin\vim.exe'
Set-Alias edit 'C:\Program Files\git\usr\bin\nano.exe'
Set-Alias far 'C:\Program Files\Far Manager\Far.exe'
Set-Alias cat 'C:\Users\anton.ryzhov\AppData\Local\Microsoft\WinGet\Links\bat.exe'

function Set-LocationUp { cd .. }
function Set-LocationUp2 { cd ..\.. }
function Set-LocationUp3 { cd ..\..\.. }
Set-Alias cd.. Set-LocationUp
Set-Alias cd... Set-LocationUp2
Set-Alias cd.... Set-LocationUp3

function SHA256($file) { Return Get-FileHash -Path $file -Algorithm SHA256 }
function SHA512($file) { Return Get-FileHash -Path $file -Algorithm SHA512 }
