# Ejecutar como Administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Reiniciando con privilegios de Administrador..."
    Start-Process powershell.exe "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Directorio donde están los scripts secundarios
$scriptFolder = "$PSScriptRoot\features"

# Obtener todos los archivos .ps1 en la carpeta
$scripts = Get-ChildItem -Path $scriptFolder -Filter "*.ps1"

# Lista para registrar procesos
$processes = @()

foreach ($script in $scripts) {
    $scriptPath = $script.FullName
    Write-Host "Ejecutando en paralelo: $script"

    # Iniciar el script en la misma ventana y esperar su ejecución
    $process = Start-Process -FilePath "powershell.exe" `
                             -ArgumentList "-ExecutionPolicy Bypass -NoProfile -File `"$scriptPath`"" `
                             -NoNewWindow -PassThru
                             
    $processes += $process
}

# Esperar a que todos los scripts terminen
foreach ($process in $processes) {
    $process | Wait-Process
}

Write-Host "✅ Todos los scripts han finalizado."
