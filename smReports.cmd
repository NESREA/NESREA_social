:: smReports.cmd
::
:: Batch file for running 'NESREA_social' project
@ECHO OFF

SETLOCAL ENABLEEXTENSIONS

SET me=%~n0
SET parent=%~dp0
SET exec=Rscript.exe
SET rflags=--vanilla
SET upd=%1

:: Error codes
SET /A errno=0
SET /A ERROR_DOWNLOAD_FAILED=1
SET /A ERROR_BUILD_FAILED=2

:: Optionally update the database first by command line argument
IF "%upd%"=="--update" (
	%exec% %rflags% data/download-data.R
)

:: Build the main report
%exec% %rflags% build/build-report.R

IF %ERRORLEVEL% NEQ 0 (
	ECHO %me%: %exec% returned with code %ERRORLEVEL%
)
