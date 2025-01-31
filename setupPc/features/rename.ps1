# Ejecutar como administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Solicitar el nuevo nombre del equipo
$newName = Read-Host "Ingrese el nuevo nombre del equipo"

# Cambiar el nombre del equipo
Rename-Computer -NewName $newName -Force

# Mostrar mensaje de éxito
Write-Host "El nombre del equipo ha sido cambiado a '$newName'. Es necesario reiniciar para aplicar los cambios." -ForegroundColor Green

# Preguntar si el usuario quiere reiniciar ahora
$restart = Read-Host "¿Desea reiniciar ahora? (S/N)"
if ($restart -match "^[sS]$") {
    Restart-Computer -Force
}
