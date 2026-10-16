@echo off
title Windows File Organizer
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0OrganizeFiles.ps1"
echo.
pause