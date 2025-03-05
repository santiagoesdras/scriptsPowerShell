# Directorio donde están los scripts secundarios
$scriptFolder = "$PSScriptRoot\features"

# Obtener todos los archivos .ps1 en la carpeta
$scripts = Get-ChildItem -Path $scriptFolder -Filter "*.ps1"

# Lista de procesos
$processes = @()

foreach ($script in $scripts) {
    $scriptPath = $script.FullName
    Write-Host "Ejecutando en paralelo: $scriptPath"

    $process = Start-Process -FilePath "powershell.exe" `
                             -ArgumentList "-ExecutionPolicy Bypass -File `"$scriptPath`"" `
                             -PassThru -WindowStyle Hidden
    
    $processes += $process
}

# Esperar a que todos los scripts terminen
foreach ($process in $processes) {
    $process | Wait-Process
}

Write-Host "Todos los scripts han finalizado."
