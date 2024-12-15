@echo off
:: Desabilitar eco de comandos
setlocal enabledelayedexpansion

:: Verificar o caminho do Nmap
set nmap_path=nmap
%nmap_path% --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Nmap não encontrado. Por favor, instale-o e adicione ao PATH.
    pause
    exit /b
)

:: Obter o IP da máquina
for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr "IPv4 Address"') do (
    set ip_address=%%A
)

:: Remover espaços do IP
set ip_address=%ip_address: =%

:: Determinar o intervalo da rede
for /f "tokens=1,2,3 delims=." %%A in ("%ip_address%") do (
    set subnet=%%A.%%B.%%C.0/24
)

:: Informar a rede identificada
echo Rede identificada: %subnet%

:: Escaneando dispositivos conectados
echo Escaneando a rede %subnet%...
%nmap_path% -sn %subnet% > "%~dp0datas.log\scan_results.txt"

:: Filtrar resultados relevantes e salvar no arquivo de log
echo Dispositivos conectados: > "%~dp0datas.log\devices.txt"
findstr "Nmap scan report" "%~dp0datas.log\scan_results.txt" >> "%~dp0datas.log\devices.txt"

:: Exibir resultados
type "%~dp0datas.log\devices.txt"

:: Pausar para visualizar os resultados
echo Relatorio salvo em "%~dp0datas.log\devices.txt".
pause