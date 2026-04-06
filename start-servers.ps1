# Levanta todos los servidores via PM2
# Se ejecuta automáticamente al iniciar Windows (Task Scheduler)
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
pm2 resurrect
