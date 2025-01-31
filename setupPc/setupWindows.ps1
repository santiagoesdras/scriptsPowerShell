# Ejecutar como administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Obtener ruta del script
$principalPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$scriptsPath = "$principalPath\features"

# Obtener todos los archivos .ps1 en la carpeta
$scripts = Get-ChildItem -Path $scriptsPath -Filter "*.ps1"

# Ejecutar cada script en un trabajo en segundo plano (simultáneo)
$jobs = @()
foreach ($script in $scripts) {
    $job = Start-Job -ScriptBlock { param($path) & $path } -ArgumentList "$scriptFolder\$($script.Name)"
    $jobs += $job
}

# Esperar a que todos los trabajos terminen antes de continuar
Write-Host "Esperando a que todos los scripts finalicen..."
$jobs | ForEach-Object { Receive-Job -Job $_ -Wait -AutoRemoveJob }

Write-Host "Todos los scripts han finalizado."

# Esperando confirmacion del usuario para salir

Write-Output "Ejecución Finalizada. Presione Enter para salir..."
Read-Host