@echo off
setlocal

set "BaseDir=C:\GestorArquivos"
set "DocsDir=%BaseDir%\Documentos"
set "LogsDir=%BaseDir%\Logs"
set "BackupDir=%BaseDir%\Backups"

set "LogFile=%LogsDir%\atividade.log"
set "ReportFile=%BaseDir%\resumo_execucao.txt"

set "total_pastas=5"
set "total_arquivos=6"
set "data_bkp=N/A"

echo === 1. CRIANDO DIRETÓRIOS ===

if not exist "%LogsDir%" mkdir "%LogsDir%"

echo [%DATE% - %TIME%] Operacao: Inicio do Script > "%LogFile%"
call :Log "Criacao pasta Logs" "SUCESSO"

for %%D in ("%BaseDir%" "%DocsDir%" "%BackupDir%") do (
    if not exist %%D (
        mkdir %%D
        call :Log "Criacao pasta %%~nxD" "SUCESSO"
    ) else (
        echo Pasta %%~nxD ja existe.
    )
)

pause
echo.
echo === 2. CRIANDO ARQUIVOS DE DOCUMENTOS ===

(
    echo Este e um relatorio automatico.
    echo Gerado em: %DATE%
) > "%DocsDir%\relatorio.txt"
call :Log "Criacao relatorio.txt" "SUCESSO"

(
    echo ID;Usuario;Status
    echo 1;admin;Ativo
    echo 2;visitante;Inativo
) > "%DocsDir%\dados.csv"
call :Log "Criacao dados.csv" "SUCESSO"

(
    echo [Servidor]
    echo IP=127.0.0.1
    echo Porta=3306
) > "%DocsDir%\config.ini"
call :Log "Criacao config.ini" "SUCESSO"

echo Arquivos de documentos criados.
pause
echo.
echo === 3. INICIANDO BACKUP ===

xcopy "%DocsDir%\*.*" "%BackupDir%\" /Y /Q /I

if %ERRORLEVEL% equ 0 (
    echo Backup de arquivos concluido.
    call :Log "Copia de Backup (xcopy)" "SUCESSO"
    
    set "data_bkp=%DATE% %TIME%"
    echo Backup realizado em: %data_bkp% > "%BackupDir%\backup_completo.bak"
    call :Log "Criacao backup_completo.bak" "SUCESSO"
) else (
    echo Falha na copia de arquivos.
    call :Log "Copia de Backup (xcopy)" "FALHA"
)

pause
echo.
echo === 4. GERANDO RELATÓRIO FINAL ===

(
    echo RELATÓRIO DE EXECUÇÃO
    echo ----------------------
    echo Total de arquivos criados: %total_arquivos%
    echo Total de pastas criadas: %total_pastas%
    echo Data/Hora do backup: %data_bkp%
) > "%ReportFile%"
call :Log "Geracao de Relatorio Final" "SUCESSO"

echo Relatório salvo em: %ReportFile%
echo.
echo Script concluido!
pause
endlocal
goto :eof

:Log
set "Operacao=%~1"
set "Resultado=%~2"
echo [%DATE% - %TIME%] Operacao: %Operacao% - Resultado: %Resultado% >> "%LogFile%"
goto :eof