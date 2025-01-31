#Script para habilitar escritorio remoto#

# Ejecutar como administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

#Habilitar Escritorio remoto y firewall

try {
    # Habilitar Escritorio Remoto
    Set-ItemProperty 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0
    Write-Output "Escritorio remoto habilitado correctamente"

    # Habilitar firewall para Escritorio Remoto
    Enable-NetFirewallRule -DisplayGroup "Escritorio remoto"
    Write-Output "Firewall para escritorio remoto habilitado correctamente"
}
catch {
    Write-Output "X se produjo un error: $_"
}

Read-Host