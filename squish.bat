@echo off

set "currentPath=%~dp0"
set "pathLuaJIT=%currentPath%.squish"

@REM Собирает все файлы и создает squishy
%pathLuaJIT%\luajit.exe %pathLuaJIT%\script_squish.lua

@REM Запуск сборщик, бильд в build
%pathLuaJIT%\luajit.exe %pathLuaJIT%\lua\squish.lua src

cd src
del "squishy"
cd %currentPath%
