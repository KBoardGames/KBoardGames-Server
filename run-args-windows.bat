@echo off
SET mypath=%~dp0

echo.
cd %mypath:~0,-1%
cd source\args
call config.bat
cd..
cd..

REM this line creates an exe file from neko bytecode.
nekotools boot Main-args.hx.neko.n

Main-args.hx.neko.exe %ip% %port% %_dbHost% %_dbPort% %_dbUser% %_dbPass% %_dbName% %_username% %_domain% %_domain_path% " " 
ping -n 2 127.0.0.1 >nul