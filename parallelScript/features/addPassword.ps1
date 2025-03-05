#Script para añadir contraseña al equipo#

# Ejecutar como administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Nombre de usuario al que se establecera la contraseña
$usuario = "Soporte"

# Definir la contraseña como texto plano
$passwordString = "error2343"

# Convertir la cadena en SecureString
$password = ConvertTo-SecureString -String $passwordString -AsPlainText -Force

# Estableciendo contraseña de usuario
Set-LocalUser -Name $usuario -Password $password
Write-Host "Contraseña cambiada exitosamente para el usuario $usuario"
Read-Host