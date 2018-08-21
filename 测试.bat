@echo off
chcp 65001
cd %~dp0
"%~dp0bin\lua.exe" "%~dp0jass.lua" -ver=24 %1
pause