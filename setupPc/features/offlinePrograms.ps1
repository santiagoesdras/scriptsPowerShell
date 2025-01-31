# Ejecutar como administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
    exit  # Evita que la sesión original siga corriendo
}

try {
    # Obtener ruta del script
    if ($MyInvocation.MyCommand.Path) {
        $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
    } else {
        throw "No se pudo determinar la ruta del script."
    }
}
catch {
    Write-Host "❌ Error al obtener la ruta: $_"
    exit
}

try {
    # Instalar programas locales (ESET y SQL)
    $instaladores = @("ESET.exe", "SQL1.msi", "SQL2.msi")

    foreach ($instalador in $instaladores) {
        $filePath = "$scriptPath\$instalador"
        if (Test-Path $filePath) {
            Write-Host "⏳ Instalando $instalador..."
            $process = Start-Process -FilePath $filePath -ArgumentList "/quiet" -Wait -PassThru
            if ($process.ExitCode -eq 0) {
                Write-Host "✅ $instalador instalado correctamente."
            } else {
                Write-Host "❌ Error al instalar $instalador. Código de salida: $($process.ExitCode)"
            }
        }
        else {
            Write-Host "❌ No se encontró el archivo $instalador en la carpeta del script."
        }
    }
}
catch {
    Write-Host "❌ Se produjo un error: $_"
}

# Evitar cierre automático de la terminal
Read-Host "Presiona ENTER para salir"
