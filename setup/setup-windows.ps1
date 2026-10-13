# Installa Python e le estensioni Python di VS Code nel profilo "Corso Info".
# Se il profilo esiste gia' (corso di C), aggiunge solo quello che manca.
# Non servono permessi di amministratore.
#
# Uso: doppio clic su setup-windows-bat.cmd
# oppure da terminale:
#   powershell -ExecutionPolicy Bypass -File setup\setup-windows.ps1

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$serie = "3.14"
$profilo = "Corso Info"
$corso = Split-Path $PSScriptRoot -Parent

function Update-Path {
    $env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
                [Environment]::GetEnvironmentVariable("Path", "User")
}

# Restituisce il percorso di un Python vero (non il collegamento al Microsoft Store)
# di versione almeno 3.10, oppure $null
function Find-Python {
    $candidati = Get-Command python -CommandType Application -All -ErrorAction SilentlyContinue |
        Where-Object { $_.Source -notlike "*\WindowsApps\*" }
    foreach ($c in $candidati) {
        try {
            $ok = & $c.Source -c "import sys; print(sys.version_info >= (3, 10))"
            if ($ok -eq "True") { return $c.Source }
        } catch { }
    }
    return $null
}

Write-Host "== 1/2 Python ==" -ForegroundColor Cyan
$python = Find-Python
if ($python) {
    Write-Host "Gia' installato: $python"
} else {
    if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") { $arch = "arm64" } else { $arch = "amd64" }

    # Cerca l'ultima versione $serie.x che ha gia' l'installatore pubblicato
    $elenco = (Invoke-WebRequest "https://www.python.org/ftp/python/" -UseBasicParsing).Content
    $versioni = [regex]::Matches($elenco, 'href="(' + [regex]::Escape($serie) + '\.\d+)/"') |
        ForEach-Object { [version]$_.Groups[1].Value } |
        Sort-Object -Descending -Unique
    $url = $null
    foreach ($v in $versioni) {
        $prova = "https://www.python.org/ftp/python/$v/python-$v-$arch.exe"
        try {
            Invoke-WebRequest $prova -Method Head -UseBasicParsing | Out-Null
            $url = $prova
            break
        } catch { }
    }
    if ($null -eq $url) { throw "Non trovo l'installatore di Python $serie per $arch" }

    Write-Host "Scarico $url"
    $exe = Join-Path $env:TEMP (Split-Path $url -Leaf)
    Invoke-WebRequest $url -OutFile $exe -UseBasicParsing

    Write-Host "Installo Python (un paio di minuti)..."
    $p = Start-Process $exe -Wait -PassThru -ArgumentList @(
        "/quiet", "InstallAllUsers=0", "PrependPath=1",
        "Include_launcher=1", "InstallLauncherAllUsers=0", "Include_test=0"
    )
    Remove-Item $exe -Force
    if ($p.ExitCode -ne 0) { throw "Installazione di Python non riuscita (codice $($p.ExitCode))" }

    Update-Path
    $python = Find-Python
    if ($null -eq $python) { throw "Python installato ma non trovato: riavvia il computer e rilancia lo script" }
}

Write-Host "== 2/2 Estensioni Python nel profilo VS Code '$profilo' ==" -ForegroundColor Cyan
$hasCode = [bool](Get-Command code -ErrorAction SilentlyContinue)
if ($hasCode) {
    # Il profilo viene creato solo aprendo VS Code: se non esiste ancora (chi non ha fatto
    # il setup del corso di C) lo crea, altrimenti apre quello che c'e' gia'.
    Write-Host "Apro VS Code sulla cartella Corso-Python nel profilo '$profilo'..."
    code --profile $profilo $corso

    $estensioni = @("ms-python.python", "ms-python.debugpy", "charliermarsh.ruff")
    $comandoElenco = "code --profile `"$profilo`" --list-extensions 2>&1"
    for ($attesa = 0; $attesa -lt 60; $attesa++) {
        if (-not ((cmd /c $comandoElenco) -match "not found")) { break }
        Start-Sleep -Seconds 1
    }

    # Le estensioni gia' presenti (ad esempio quelle del C) restano come sono
    foreach ($ext in $estensioni) {
        code --profile $profilo --install-extension $ext
    }

    $presenti = @(cmd /c $comandoElenco)
    $mancanti = @($estensioni | Where-Object { $presenti -notcontains $_ })
    if ($mancanti.Count -gt 0) {
        Write-Host "Non sono riuscito a installare: $($mancanti -join ', '). Installale da VS Code." -ForegroundColor Yellow
    }
} else {
    Write-Host "Comando 'code' non trovato: installa le estensioni da VS Code (te le propone aprendo la cartella)." -ForegroundColor Yellow
}

Write-Host ""
& $python --version
Write-Host ""
Write-Host "Fatto! Se VS Code chiede di ricaricare la finestra, accetta." -ForegroundColor Green
