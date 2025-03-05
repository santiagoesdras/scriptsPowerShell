# Ejecutar como administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
    exit  # Evita que la sesión original siga corriendo
}

# Instalar programas adicionales usando WINGET
$programsToDownload = @("Adobe.Acrobat.Reader.64-bit", "RARLab.WinRAR", "Mozilla.Firefox", "Google.Chrome")
try {
    foreach ($program in $programsToDownload){
        winget install --id=$program --silent --accept-source-agreements --accept-package-agreements --source winget
    }
}
catch {
    Write-Host = "Error al instalar programas con winget: $_"
}