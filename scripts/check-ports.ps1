$ports = 5432, 8080, 3000, 5173
$rows = @()

foreach ($port in $ports) {
    $listeners = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue

    if (-not $listeners) {
        $rows += [pscustomobject]@{ Port = $port; PID = "-"; Process = "LIVRE" }
        continue
    }

    foreach ($listener in $listeners) {
        $process = Get-Process -Id $listener.OwningProcess -ErrorAction SilentlyContinue
        $rows += [pscustomobject]@{
            Port = $port
            PID = $listener.OwningProcess
            Process = $process.ProcessName
        }
    }
}

$rows | Format-Table -AutoSize

