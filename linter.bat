@echo off
setlocal EnableExtensions EnableDelayedExpansion

SET setup=false
SET setupMode=%2
IF "%1"=="-s" SET setup=true
IF "%1"=="setup" SET setup=true
IF "%setup%" == "true" (
    ECHO WARNING: In case of any errors try: 'setup default' command.
    ECHO WARNING: It may corrupt your PATH!
    IF "!setupMode!" == "default" (
        echo INFO: Update PATH with defaults. 
        setx /M PATH "%PATH%;C:\cygwin64\bin;C:\Program Files\Oracle\VirtualBox;C:\Program Files\Docker Toolbox"
        ECHO INFO: Restart your cmd to see the changes.
        GOTO EOF
    )

    WHERE bash >nul 2>nul
    IF %ERRORLEVEL% NEQ 0 (
        ECHO Bash is not installed or not in the PATH. Please re-run the Cygwin Installer and try again.
        GOTO EOF
    )

    bash linter.sh %*
    FOR /f "tokens=*" %%i IN ('docker-machine env default') DO %%i
    GOTO EOF
)

FOR /f "tokens=*" %%i IN ('docker-machine env default') DO %%i
bash linter.sh %*
:EOF
endlocal