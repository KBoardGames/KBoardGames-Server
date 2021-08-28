@echo off

REM this line compiles the server to bytecode.
REM -L hxssl

haxe -main Main -neko main.hx.neko.n
serverRunExe.bat < nul

