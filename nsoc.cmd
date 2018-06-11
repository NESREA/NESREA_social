:: nsoc.cmd
::
:: Batch file for starting the 'NESREA_social' project
@ECHO OFF

SETLOCAL ENABLEEXTENSIONS
SET this=%~n0
SET parent=%~dp0

SET arg=%1
SET exec=Rscript.exe
SET rflags=--vanilla

:: Error codes
SET /A errno=0
SET /A ERROR_DOWNLOAD_FAILED=1
SET /A ERROR_BUILD_FAILED=2


:: Update the database
IF "%arg%" NEQ "--build" (
    %exec% %rflags% src/download.R
)

:: Build the main report
IF "%arg%" NEQ "--update" (
    %exec% %rflags% src/build.R
)

IF %ERRORLEVEL% NEQ 0 (
    ECHO %this%: %exec% returned with code %ERRORLEVEL%
)
