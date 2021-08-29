@echo off
SET mypath=%~dp0

echo An error will be shown here if server is running or MySQL is not active.
echo Loading. please wait...

echo.
cd source\args
call config.bat
cd..

cd vendor
ConsoleNoClose.exe /1
cd..
cd..

REM this line creates an exe file from neko bytecode.
REM also remove this to build then after build rem again.
nekotools boot Main.hx.neko.n

(echo. N)| cmd /c Main.hx.neko.exe %ip% %port% %_dbHost% %_dbPort% %_dbUser% %_dbPass% %_dbName% %_username% %_domain% %_domain_path% " " %* & (echo. N)| cmd /c run-args-windows.bat 


cmd.exe