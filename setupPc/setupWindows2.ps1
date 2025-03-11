# Ejecutar como administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Directorio donde están los scripts secundarios
$scriptFolder = "$PSScriptRoot\second"

# Obtener todos los archivos .ps1 en la carpeta
$scripts = Get-ChildItem -Path $scriptFolder -Filter "*.ps1"

# Ejecutar cada script uno por uno (secuencialmente)
foreach ($script in $scripts) {
    Write-Host "Ejecutando: $($script.Name)"
    & "$scriptFolder\$($script.Name)"
    Write-Host "Finalizado: $($script.Name)`n"
}   
Write-Host "Todos los scripts han finalizado."

# Esperando confirmacion del usuario para salir

Write-Output "Ejecución Finalizada. Presione Enter para salir..."
Read-Host