@echo off
chcp 65001 >nul

REM ============================================================
REM Тема: Диагностика клиентского компьютера
REM Практическая работа 8
REM Фамилия: Пчеляков Е.А.
REM Дата: 2026-10-31
REM ============================================================

REM Путь к файлу отчёта (рядом с батником)
set REPORT=%~dp0pc_report.txt

REM Создаём файл отчёта заново
echo ========================================== > "%REPORT%"
echo          Диагностика компьютера >> "%REPORT%"
echo ========================================== >> "%REPORT%"
echo. >> "%REPORT%"

echo ==========================================
echo          Диагностика компьютера
echo ==========================================
echo.

REM ============================================================
REM 1. Операционная система
REM ============================================================
echo Операционная система:
echo ------------------------------------------
echo Операционная система: >> "%REPORT%"
echo ------------------------------------------ >> "%REPORT%"

wmic os get Caption,Version /format:list
wmic os get Caption,Version /format:list >> "%REPORT%"

echo.
echo. >> "%REPORT%"

REM ============================================================
REM 2. Процессор
REM ============================================================
echo Процессор:
echo ------------------------------------------
echo Процессор: >> "%REPORT%"
echo ------------------------------------------ >> "%REPORT%"

wmic cpu get Name /format:list
wmic cpu get Name /format:list >> "%REPORT%"

echo.
echo. >> "%REPORT%"

REM ============================================================
REM 3. Оперативная память
REM ============================================================
echo Оперативная память:
echo ------------------------------------------
echo Оперативная память: >> "%REPORT%"
echo ------------------------------------------ >> "%REPORT%"

REM Получаем общий объём памяти в килобайтах
for /f "tokens=2 delims==" %%a in ('wmic os get TotalVisibleMemorySize /value ^| findstr "="') do set TOTAL_KB=%%a
REM Получаем свободную память в килобайтах
for /f "tokens=2 delims==" %%a in ('wmic os get FreePhysicalMemory /value ^| findstr "="') do set FREE_KB=%%a

REM Переводим в гигабайты (делим на 1048576)
set /a TOTAL_GB=%TOTAL_KB% / 1048576
set /a FREE_GB=%FREE_KB% / 1048576

echo Всего памяти: %TOTAL_GB% ГБ
echo Свободно памяти: %FREE_GB% ГБ
echo Всего памяти: %TOTAL_GB% ГБ >> "%REPORT%"
echo Свободно памяти: %FREE_GB% ГБ >> "%REPORT%"

echo.
echo. >> "%REPORT%"

REM ============================================================
REM 4. Диск C
REM ============================================================
echo Диск C:
echo ------------------------------------------
echo Диск C: >> "%REPORT%"
echo ------------------------------------------ >> "%REPORT%"

REM Получаем размер и свободное место в байтах
for /f "tokens=2 delims==" %%a in ('wmic logicaldisk where "DeviceID='C:'" get Size /value ^| findstr "="') do set SIZE_B=%%a
for /f "tokens=2 delims==" %%a in ('wmic logicaldisk where "DeviceID='C:'" get FreeSpace /value ^| findstr "="') do set FREE_B=%%a

REM Переводим в гигабайты (делим на 1073741824)
set /a SIZE_GB=%SIZE_B% / 1073741824
set /a FREE_GB=%FREE_B% / 1073741824

echo Всего на диске: %SIZE_GB% ГБ
echo Свободно: %FREE_GB% ГБ
echo Всего на диске: %SIZE_GB% ГБ >> "%REPORT%"
echo Свободно: %FREE_GB% ГБ >> "%REPORT%"

echo.
echo. >> "%REPORT%"

REM ============================================================
REM 5. Установленные программы
REM ============================================================
echo Установленные программы:
echo ------------------------------------------
echo Установленные программы: >> "%REPORT%"
echo ------------------------------------------ >> "%REPORT%"

echo Идёт поиск программ, это может занять несколько минут...
echo Идёт поиск программ, это может занять несколько минут... >> "%REPORT%"

wmic product get Name /format:list
wmic product get Name /format:list >> "%REPORT%"

echo.
echo. >> "%REPORT%"

REM ============================================================
REM 6. Завершение
REM ============================================================
echo ==========================================
echo Отчёт сохранён: %REPORT%
echo ==========================================
echo ========================================== >> "%REPORT%"
echo Отчёт сохранён. >> "%REPORT%"
echo ========================================== >> "%REPORT%"

pause


REM вот код который работает на windows 11, так как на ней способ wmic удалили и прнизнали устаревшей

@echo off
chcp 65001 >nul

REM ============================================================
REM Тема: Диагностика клиентского компьютера
REM Практическая работа 8
REM Фамилия: Иванов И.И.
REM Дата: 2026-10-31
REM ============================================================

set REPORT=%~dp0pc_report.txt

echo ========================================== > "%REPORT%"
echo          Диагностика компьютера >> "%REPORT%"
echo ========================================== >> "%REPORT%"
echo. >> "%REPORT%"

echo ==========================================
echo          Диагностика компьютера
echo ==========================================
echo.

REM ============================================================
REM 1. Операционная система (через PowerShell)
REM ============================================================
echo Операционная система:
echo ------------------------------------------
echo Операционная система: >> "%REPORT%"
echo ------------------------------------------ >> "%REPORT%"

for /f "delims=" %%a in ('powershell -NoProfile -Command "(Get-CimInstance Win32_OperatingSystem).Caption"') do set OS_NAME=%%a
for /f "delims=" %%a in ('powershell -NoProfile -Command "(Get-CimInstance Win32_OperatingSystem).Version"') do set OS_VER=%%a

echo Название: %OS_NAME%
echo Версия:   %OS_VER%
echo Название: %OS_NAME% >> "%REPORT%"
echo Версия:   %OS_VER% >> "%REPORT%"

echo.
echo. >> "%REPORT%"

REM ============================================================
REM 2. Процессор (через PowerShell)
REM ============================================================
echo Процессор:
echo ------------------------------------------
echo Процессор: >> "%REPORT%"
echo ------------------------------------------ >> "%REPORT%"

for /f "delims=" %%a in ('powershell -NoProfile -Command "(Get-CimInstance Win32_Processor).Name"') do set CPU_NAME=%%a

echo %CPU_NAME%
echo %CPU_NAME% >> "%REPORT%"

echo.
echo. >> "%REPORT%"

REM ============================================================
REM 3. Оперативная память (через PowerShell, сразу в ГБ)
REM ============================================================
echo Оперативная память:
echo ------------------------------------------
echo Оперативная память: >> "%REPORT%"
echo ------------------------------------------ >> "%REPORT%"

for /f "delims=" %%a in ('powershell -NoProfile -Command "[math]::Round((Get-CimInstance Win32_OperatingSystem).TotalVisibleMemorySize / 1MB)"') do set TOTAL_GB=%%a
for /f "delims=" %%a in ('powershell -NoProfile -Command "[math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1MB)"') do set FREE_GB=%%a

echo Всего памяти: %TOTAL_GB% ГБ
echo Свободно памяти: %FREE_GB% ГБ
echo Всего памяти: %TOTAL_GB% ГБ >> "%REPORT%"
echo Свободно памяти: %FREE_GB% ГБ >> "%REPORT%"

echo.
echo. >> "%REPORT%"

REM ============================================================
REM 4. Диск C (через PowerShell, сразу в ГБ)
REM ============================================================
echo Диск C:
echo ------------------------------------------
echo Диск C: >> "%REPORT%"
echo ------------------------------------------ >> "%REPORT%"

for /f "delims=" %%a in ('powershell -NoProfile -Command "[math]::Round((Get-CimInstance Win32_LogicalDisk -Filter \"DeviceID='C:'\").Size / 1GB)"') do set DISK_TOTAL=%%a
for /f "delims=" %%a in ('powershell -NoProfile -Command "[math]::Round((Get-CimInstance Win32_LogicalDisk -Filter \"DeviceID='C:'\").FreeSpace / 1GB)"') do set DISK_FREE=%%a

echo Всего на диске: %DISK_TOTAL% ГБ
echo Свободно: %DISK_FREE% ГБ
echo Всего на диске: %DISK_TOTAL% ГБ >> "%REPORT%"
echo Свободно: %DISK_FREE% ГБ >> "%REPORT%"

echo.
echo. >> "%REPORT%"

REM ============================================================
REM 5. Установленные программы (через реестр — быстро и без wmic)
REM ============================================================
echo Установленные программы:
echo ------------------------------------------
echo Установленные программы: >> "%REPORT%"
echo ------------------------------------------ >> "%REPORT%"

echo Идёт поиск программ...
echo Идёт поиск программ... >> "%REPORT%"

for /f "tokens=1,2,*" %%a in ('reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s 2^>nul ^| findstr "DisplayName"') do (
    if "%%a"=="DisplayName" echo %%c
    if "%%a"=="DisplayName" echo %%c >> "%REPORT%"
)
for /f "tokens=1,2,*" %%a in ('reg query "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s 2^>nul ^| findstr "DisplayName"') do (
    if "%%a"=="DisplayName" echo %%c
    if "%%a"=="DisplayName" echo %%c >> "%REPORT%"
)

echo.
echo. >> "%REPORT%"

REM ============================================================
REM 6. Завершение
REM ============================================================
echo ==========================================
echo Отчёт сохранён: %REPORT%
echo ==========================================
echo ========================================== >> "%REPORT%"
echo Отчёт сохранён. >> "%REPORT%"
echo ========================================== >> "%REPORT%"

pause



