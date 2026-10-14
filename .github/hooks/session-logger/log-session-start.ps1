$ErrorActionPreference = 'Stop'

if ($env:SKIP_LOGGING -ceq 'true') {
    exit 0
}

# Consume the hook payload, matching the shell script's stdin behavior.
$null = [Console]::In.ReadToEnd()

$logDirectory = Join-Path -Path 'logs' -ChildPath 'copilot'
$null = New-Item -ItemType Directory -Path $logDirectory -Force

$entry = [ordered]@{
    timestamp = [DateTime]::UtcNow.ToString(
        "yyyy-MM-dd'T'HH:mm:ss'Z'",
        [Globalization.CultureInfo]::InvariantCulture
    )
    event = 'sessionStart'
    cwd = (Get-Location).Path
}
$jsonLine = ConvertTo-Json -InputObject $entry -Compress
$logPath = Join-Path -Path $logDirectory -ChildPath 'session.log'
$utf8WithoutBom = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::AppendAllText($logPath, $jsonLine + [Environment]::NewLine, $utf8WithoutBom)

Write-Output '📝 Session logged'
