:: nsoc.cmd
::
:: Batch file for running 'NESREA_social' project
@ECHO OFF

SETLOCAL ENABLEEXTENSIONS

SET me=%~n0
SET parent=%~dp0
SET exec=Rscript.exe
SET rflags=--vanilla
SET upd=--update

:: Error codes
SET /A errno=0
SET /A ERROR_DOWNLOAD_FAILED=1
SET /A ERROR_BUILD_FAILED=2


:: Update the database
IF "%upd%"=="--update" (
	%exec% %rflags% src/download.R
)

:: Build the main report
%exec% %rflags% src/build.R

IF %ERRORLEVEL% NEQ 0 (
    ECHO %me%: %exec% returned with code %ERRORLEVEL%
)
