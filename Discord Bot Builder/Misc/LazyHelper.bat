@ECHO off

:start
echo.
echo "|                              |"
echo "|  Name: Lazy Helper           |"
echo "|  Author: RuschGaming         |"
echo "|  Version: 1.0                |"
echo "|  Date: 17-09-2020            |"
echo "|                              |"
echo "|  Simple Batch that helps     |"
echo "|  with installing discord.js  |"
echo "|                              |"

echo.
echo.

SET choice=
SET /p choice= Is Node.js installed?[Y,N]:
IF '%choice%'=='Y' GOTO yes
IF '%choice%'=='y' GOTO yes
IF '%choice%'=='N' GOTO no
IF '%choice%'=='n' GOTO no
IF '%choice%'=='' GOTO no
echo "%choice%" is not valid
echo.
GOTO start

:no
echo "Opening Link to Download Node.js"
start "" https://nodejs.org/en/download/
timeout 15
cls
GOTO Start

:yes
echo "Installing Discord.js via Node"
call npm install discord.js
cls 
echo "Discord.js is now installed, Open Start.bat file to run your Discord Bot." 
echo.
timeout 15


