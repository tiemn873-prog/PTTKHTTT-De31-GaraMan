@echo off
rem He thong Quan ly Gara O to (GaraMan) - De 31
rem Sinh vien: Nguyen Dung Tiem - MSV: B23DCCN813
cd /d "%~dp0"

netstat -ano | findstr ":3306 " | findstr LISTENING >nul
if errorlevel 1 (
    echo [1/2] Dang bat MySQL Server...
    start "MySQL" /min "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqld.exe" --defaults-file="C:\ProgramData\MySQL\MySQL Server 8.4\my.ini" --console
    timeout /t 5 /nobreak >nul
) else (
    echo [1/2] MySQL Server da chay san.
)

echo [2/2] Dang khoi dong Web Server GaraMan...
"C:\Program Files\Python311\python.exe" app.py

if errorlevel 1 (
    echo [LOI] Khong the chay server. Vui long kiem tra lai.
    pause
)
