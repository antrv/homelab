# If powershell session initiated by running a script with output redirection
If ([System.Console]::IsOutputRedirected)
{
    Exit
}

Function IsVirtualTerminalProcessingEnabled
{
    $MethodDefinitions = @'
[DllImport("kernel32.dll", SetLastError = true)]
public static extern IntPtr GetStdHandle(int nStdHandle);
[DllImport("kernel32.dll", SetLastError = true)]
public static extern bool GetConsoleMode(IntPtr hConsoleHandle, out uint lpMode);
'@
    $Kernel32 = Add-Type -MemberDefinition $MethodDefinitions -Name 'Kernel32' -Namespace 'Win32' -PassThru
    $hConsoleHandle = $Kernel32::GetStdHandle(-11) # STD_OUTPUT_HANDLE
    $mode = 0
    $Kernel32::GetConsoleMode($hConsoleHandle, [ref]$mode) >$null
    If ($mode -Band 0x0004)
    { 
        # 0x0004 ENABLE_VIRTUAL_TERMINAL_PROCESSING
        Return $true
    }
 
    Return $false
}

# Oh-My-Posh
oh-my-posh init pwsh --config "$PSScriptRoot/mytheme.omp.json" | Invoke-Expression
Import-Module posh-git

# PSReadLine
Import-Module PSReadLine
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -EditMode Windows
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

If (IsVirtualTerminalProcessingEnabled)
{
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
}

# Fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# Others
Import-Module Terminal-Icons
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# Aliases
function Invoke-EzaShortFormat { eza -a --group-directories-first --git --icons -B }
function Invoke-EzaLongFormat { eza -a --long --group-directories-first --git --icons -B }
function Invoke-LessCommand { "${Env:ProgramFiles}\git\usr\bin\less.exe" }
function Invoke-VimCommand { "${Env:ProgramFiles}\git\usr\bin\vim.exe" }
function Invoke-NanoCommand { "${Env:ProgramFiles}\git\usr\bin\nano.exe" }
function Invoke-BatCommand { "${Env:LOCALAPPDATA}\Microsoft\WinGet\Links\bat.exe" }

Set-Alias ls Invoke-EzaShortFormat
Set-Alias ll Invoke-EzaLongFormat
Set-Alias grep findstr
Set-Alias less Invoke-LessCommand
Set-Alias vim Invoke-VimCommand
Set-Alias edit Invoke-NanoCommand
Set-Alias cat Invoke-BatCommand

function SHA256($file) { Return Get-FileHash -Path $file -Algorithm SHA256 }
function SHA512($file) { Return Get-FileHash -Path $file -Algorithm SHA512 }
