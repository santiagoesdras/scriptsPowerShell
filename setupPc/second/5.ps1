# Script para instalación silenciosa de programas offline

# Ejecutar como administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Obtener ruta del directorio principal
try {
    if ($MyInvocation.MyCommand.Path) {
        $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
        $programsPath = Join-Path (Split-Path -Parent $scriptPath) "programs"
    } else {
        throw "No se pudo determinar la ruta del script."
    }
}
catch {
    Write-Host "Error al obtener la ruta"
    exit
}

# Lista de instaladores con argumentos específicos para modo silencioso
$instaladores = @{
    "acrobat_installer.exe"    = "/sAll /rs /msi /norestart /quiet"
    "ESET.exe"                = "/silent /norestart"
    "firefox_installer.exe"    = "-ms"
    "chrome_installer.msi"     = "/quiet /norestart"
    "SQL1.msi"                = "/quiet /norestart"
    "SQL2.msi"                = "/quiet /norestart"
    "winrar_installer.exe"     = "/S"
    "OfficeSetup.exe"		= "/configure `"$programsPath/config.xml`""
}

# Instalar programas
foreach ($instalador in $instaladores.Keys) {
    $filePath = Join-Path $programsPath $instalador
    
    if (Test-Path $filePath) {
        Write-Host "Instalando $instalador..."
        $arguments = $instaladores[$instalador]

        try {
            if ($instalador -match "\.msi$") {
                # Ejecutar archivos MSI con msiexec
                $process = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$filePath`" $arguments" -Wait -PassThru -NoNewWindow
            } else {
		    if($instalador -eq "OfficeSetup.exe"){
			    $process = Start-Process -FilePath $filePath -ArgumentList $arguments -Wait -PassThru
			}
			else{
                		# Ejecutar archivos EXE normalmente
                		$process = Start-Process -FilePath $filePath -ArgumentList $arguments -Wait -PassThru -NoNewWindow
			}
            }
            
            # Validar código de salida
            if ($process.ExitCode -eq 0) {
                Write-Host "$instalador instalado correctamente."
            } else {
                Write-Host "Error al instalar $instalador. Código de salida: $($process.ExitCode)"
            }
        }
        catch {
            Write-Host "Error al ejecutar $instalador"
        }
    }
    else {
        Write-Host "No se encontró el archivo $instalador en la carpeta programs."
    }
}

# Evitar cierre automático de la terminal
Read-Host "Presiona ENTER para salir"
