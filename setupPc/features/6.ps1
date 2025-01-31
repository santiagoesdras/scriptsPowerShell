#Script para instalar actualizaciones de windows#

# Ejecutar como administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
    exit  # Evita que la sesión original siga corriendo
}

# Actualizar Windows
try{
    Write-Host "Iniciando actualización de Windows..." -ForegroundColor Cyan
    Install-Module PSWindowsUpdate -Force -SkipPublisherCheck
    Get-WindowsUpdate -AcceptAll -Install -IgnoreReboot
}catch{
    Write-Host "Error en la instalacion de actualizaciones: $_"
}

# Evitar cierre automático de la terminal
Read-Host "Presiona ENTER para salir"
