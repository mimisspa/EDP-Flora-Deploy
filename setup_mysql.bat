@echo off
REM -- MySQL Configuration Script After Unattended Install --
REM Assumes MySQL is installed in the default location and root password is set

set MYSQL_EXE=C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe
set DB_NAME=floweryflowers
set ROOT_PASS=mike

REM Ensure MySQL executable exists
if not exist "%MYSQL_EXE%" (
    echo ERROR: MySQL not found at "%MYSQL_EXE%"
    pause
    exit /b 1
)

echo.
echo [1/3] Creating database if it does not exist...
echo CREATE DATABASE IF NOT EXISTS %DB_NAME%; | "%MYSQL_EXE%" -u root -p%ROOT_PASS%

echo.
echo [2/3] Importing initdb_floweryflowers.sql (database structure and setup)...
"%MYSQL_EXE%" -u root -p%ROOT_PASS% %DB_NAME% < "%~dp0initdb_floweryflowers.sql"

echo.
echo [3/3] Importing floweryflowersDB.sql (database data backup)...
"%MYSQL_EXE%" -u root -p%ROOT_PASS% %DB_NAME% < "%~dp0floweryflowersDB.sql"

echo.
echo MySQL setup and database restoration complete.
pause
