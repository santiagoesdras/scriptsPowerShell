#Script para Activar protocolos#

# Ejecutar como administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Activacion del Protocolo SMB1
try {
    Enable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -All -NoRestart
    Write-Output "Protocolo SMB1 Activado Correctamente"
}
catch {
    Write-Output " X se produjo un error: $_"
}

# Activacion del .Net 3
try {
    Enable-WindowsOptionalFeature -Online -FeatureName NetFx3 -All -NoRestart
    Write-Output ".Net3 Activado Correctamente"
}
catch {
    Write-Output " X se produjo un error: $_"
}


Read-Host