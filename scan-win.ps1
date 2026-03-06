<#
PowerShell-only Minecraft IP scanner for Windows.
No external libraries required - uses built-in .NET classes and PowerShell features.
Usage:
    scan-win.ps1                   # shows GUI input box
    scan-win.ps1 ip1 ip2 ...       # scans addresses from command line
#>

[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

function Test-Port {
    param(
        [string]$Host,
        [int]$Port = 25565,
        [int]$TimeoutMs = 1000
    )
    try {
        $client = New-Object System.Net.Sockets.TcpClient
        $iar = $client.BeginConnect($Host, $Port, $null, $null)
        $wait = $iar.AsyncWaitHandle.WaitOne($TimeoutMs, $false)
        if (-not $wait) {
            $client.Close()
            return $false
        }
        $client.EndConnect($iar)
        $client.Close()
        return $true
    } catch {
        return $false
    }
}

function Scan-Addresses {
    param([string[]]$Addrs)
    $results = @()
    foreach ($a in $Addrs) {
        if (-not [string]::IsNullOrWhiteSpace($a)) {
            $ok = Test-Port -Host $a
            $status = if ($ok) {"open"} else {"closed"}
            $results += "$a : port 25565 is $status"
        }
    }
    return $results
}

function Show-InputBox {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Minecraft Scanner"
    $form.Size = New-Object System.Drawing.Size(400,300)
    $form.StartPosition = "CenterScreen"

    $text = New-Object System.Windows.Forms.TextBox
    $text.Multiline = $true
    $text.ScrollBars = "Vertical"
    $text.Dock = "Fill"
    $form.Controls.Add($text)

    $button = New-Object System.Windows.Forms.Button
    $button.Text = "Сканировать"
    $button.Dock = "Bottom"
    $button.Add_Click({$form.Tag = $text.Text; $form.Close()})
    $form.Controls.Add($button)

    $form.ShowDialog() | Out-Null
    return $form.Tag -split("[\r\n]+")
}

# main logic
if ($args.Count -gt 0) {
    $targets = $args
} else {
    $targets = Show-InputBox
}

if ($targets -and $targets.Count -gt 0) {
    $results = Scan-Addresses -Addrs $targets
    $results | ForEach-Object { Write-Output $_ }
    # optionally open HTML
    $html = "<html><body><pre>`n" + ($results -join "`n") + "`n</pre></body></html>"
    $tmp = [IO.Path]::GetTempFileName() + ".html"
    $html | Out-File -FilePath $tmp -Encoding utf8
    Start-Process $tmp
} else {
    Write-Host "No addresses specified. Exiting."
}
