# Ejecutar como administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Configurar parametros de energia

try {
    powercfg /change disk-timeout-ac 0
    Write-Output "Parametros de energia disco duro modificados correctamente"
    powercfg /change standby-timeout-ac 0
    Write-Output "Parametros de energia para suspension modificados correctamente"
    powercfg /change hibernate-timeout-ac 0
    Write-Output "Parametros de energia para hibernacion modificados correctamente"
}
catch {
    Write-Output " X se produjo un error: $_"
}

Read-Host