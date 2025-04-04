#[Console]::OutputEncoding = [Text.Encoding]::UTF8
Write-Host -ForegroundColor DarkBlue "Talk is cheap. Show me the code."
# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\onehalf.minimal.omp.json" | Invoke-Expression
# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\kushal.omp.json" | Invoke-Expression
# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\tokyo.omp.json" | Invoke-Expression
oh-my-posh init pwsh --config "$PSScriptRoot\omp_theme\custom.omp.json" | Invoke-Expression

Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Chord "Ctrl+RightArrow" -Function ForwardWord
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

Set-Alias -Name notepad -Value "C:\Program Files\Notepad3\Notepad3.exe"
Set-Alias -Name vim -Value notepad
Set-Alias -Name nano -Value notepad

Set-Alias -Name cld -Value Clear-DnsClientCache

Set-Alias -Name diec -Value "D:\Software\die_win64_portable\diec.exe"
Set-Alias -Name file -Value diec

function proxy {
    $env:all_proxy = "http://127.0.0.1:31080"
    $env:https_proxy = $env:all_proxy
    $env:http_proxy = $env:all_proxy
}

function tail {
    param([string]$file)
    Get-Content -Tail 10 -Wait $file
}

function which {
    param([string]$command)
    (Get-Command $command -All).Path
}

function md5sum {
    param([string]$file)
    Get-FileHash -Path $file -Algorithm MD5 | Select-Object -ExpandProperty Hash
}

function sha1sum {
    param([string]$file)
    Get-FileHash -Path $file -Algorithm SHA1 | Select-Object -ExpandProperty Hash
}

function ollama_update {
    (Invoke-RestMethod http://localhost:11434/api/tags).Models.Name.ForEach{ ollama pull $_ }
}

function v6_sw {
    $ipv6Enabled = Get-NetAdapterBinding -Name eth0 -ComponentID ms_tcpip6 | Select-Object -ExpandProperty Enabled
    if ($ipv6Enabled) {
        Start-Process pwsh -Verb RunAs -ArgumentList "-c Disable-NetAdapterBinding -Name eth0 -ComponentID ms_tcpip6"
        Write-Host "已禁用 IPv6。"
    }
    else {
        Start-Process pwsh -Verb RunAs -ArgumentList "-c Enable-NetAdapterBinding -Name eth0 -ComponentID ms_tcpip6"
        Write-Host "已启用 IPv6。"
    }
}
