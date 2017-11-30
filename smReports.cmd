:: run.cmd
::
:: Batch file for running various processes for 'NESREA_social' project

@ECHO OFF

SETLOCAL ENABLEEXTENSIONS

SET me=%~n0
SET parent=%~dp0
SET upd=%1
SET exec=Rscript.exe
SET rflags=--vanilla

:: Optionally update the database first by command line argument
IF "%upd%"=="--update" (
	%exec% %rflags% data/download-data.R
)

:: Build the main report
%exec% %rflags% build/build-report.R

IF %ERRORLEVEL% NEQ 0 (
	ECHO %me%: %exec% returned with code %ERRORLEVEL%
)