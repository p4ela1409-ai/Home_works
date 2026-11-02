@echo off
chcp 65001 >nul

REM ============================================================
REM Тема: Диагностика и автоматический анализ ПК
REM Практическая работа 8 (Модернизированная)
REM Фамилия: Пчеляков Е.А.
REM Дата: 2026-11-02
REM ============================================================

set REPORT=%~dp0pc_report.txt

REM Очистка старого отчета и подготовка заголовка
(
echo ============================================================
echo          ОТЧЁТ О ДИАГНОСТИКЕ И АНАЛИЗЕ СИСТЕМЫ
echo ============================================================
echo Дата проверки: %DATE% %TIME%
echo Исполнитель:   Пчеляков Е.А.
echo.
) > "%REPORT%"

echo ============================================================
echo    Запущена диагностика ПК. Пожалуйста, подождите...
echo ============================================================
echo.

REM ============================================================
REM БЛОК 1. СБОР ДАННЫХ И ХРАНЕНИЕ В ПЕРЕМЕННЫХ
REM ============================================================

REM Защита от сбоев: если PowerShell недоступен, переменные останутся пустыми
set "OS_NAME=Не удалось определить" & set "OS_VER=-"
set "CPU_NAME=Не удалось определить"
set "TOTAL_GB=0" & set "FREE_GB=0"
set "DISK_TOTAL=0" & set "DISK_FREE=0"

REM 1.1 Операционная система
for /f "delims=" %%a in ('powershell -NoProfile -Command "(Get-CimInstance Win32_OperatingSystem).Caption" 2^>nul') do set "OS_NAME=%%a"
for /f "delims=" %%a in ('powershell -NoProfile -Command "(Get-CimInstance Win32_OperatingSystem).Version" 2^>nul') do set "OS_VER=%%a"

REM 1.2 Процессор
for /f "delims=" %%a in ('powershell -NoProfile -Command "(Get-CimInstance Win32_Processor).Name" 2^>nul') do set "CPU_NAME=%%a"

REM 1.3 Оперативная память
for /f "delims=" %%a in ('powershell -NoProfile -Command "[math]::Round((Get-CimInstance Win32_OperatingSystem).TotalVisibleMemorySize / 1MB)" 2^>nul') do set "TOTAL_GB=%%a"
for /f "delims=" %%a in ('powershell -NoProfile -Command "[math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1MB)" 2^>nul') do set "FREE_GB=%%a"

REM 1.4 Диск C:
for /f "delims=" %%a in ('powershell -NoProfile -Command "[math]::Round((Get-CimInstance Win32_LogicalDisk -Filter \"DeviceID='C:'\").Size / 1GB)" 2^>nul') do set "DISK_TOTAL=%%a"
for /f "delims=" %%a in ('powershell -NoProfile -Command "[math]::Round((Get-CimInstance Win32_LogicalDisk -Filter \"DeviceID='C:'\").FreeSpace / 1GB)" 2^>nul') do set "DISK_FREE=%%a"


REM ============================================================
REM БЛОК 2. АВТОМАТИЧЕСКИЙ АНАЛИЗ И РЕКОМЕНДАЦИИ
REM ============================================================

REM Вычисление процента свободного места на диске C (Защита от деления на 0)
set "DISK_PCT=0"
if %DISK_TOTAL% GTR 0 (
    set /a "DISK_PCT=(DISK_FREE * 100) / DISK_TOTAL"
)

REM Логика формирования рекомендаций
set "REC_RAM=► Объем ОЗУ достаточен для базовых задач."
if %TOTAL_GB% LSS 8 (
    set "REC_RAM=‼ ВНИМАНИЕ: На ПК менее 8 ГБ ОЗУ. Рекомендуется увеличить память для быстрой работы Windows 11."
)

set "REC_DISK=► На диске C достаточно свободного места."
if %DISK_FREE% LSS 20 (
    set "REC_DISK=‼ КРИТИЧЕСКИ МАЛО МЕСТА: Свободно менее 20 ГБ. Windows может сильно тормозить. Срочно очистите диск!"
) else (
    if %DISK_PCT% LSS 15 (
        set "REC_DISK=⚠ ПРЕДУПРЕЖДЕНИЕ: Свободно менее 15%% объема диска. Рекомендуется провести очистку (папки Загрузки, Корзина)."
    )
)


REM ============================================================
REM БЛОК 3. ВЫВОД ИНФОРМАЦИИ НА ЭКРАН И ЗАПИСЬ В ОТЧЕТ
REM ============================================================

REM Команда-обертка позволяет записать весь текст в файл за один раз, дублирование убрано.
(
echo ============================================================
echo 1. ХАРАКТЕРИСТИКИ СИСТЕМЫ
echo ============================================================
echo [ОС]:         %OS_NAME% (Версия: %OS_VER%)
echo [Процессор]:  %CPU_NAME%
echo [Память]:     Всего: %TOTAL_GB% ГБ | Свободно сейчас: %FREE_GB% ГБ
echo [Диск C:]:    Всего: %DISK_TOTAL% ГБ | Свободно: %DISK_FREE% ГБ (%DISK_PCT%%% свободно)
echo.
echo ============================================================
echo 2. АВТОМАТИЧЕСКИЙ АНАЛИЗ И РЕКОМЕНДАЦИИ
echo ============================================================
echo %REC_RAM%
echo %REC_DISK%
echo.
echo ============================================================
echo 3. СПИСОК УСТАНОВЛЕННЫХ ПРОГРАММ
echo ============================================================
) > "%TEMP%\layout.txt"

REM Выводим заголовок и анализ пользователю в консоль и добавляем в отчет
type "%TEMP%\layout.txt"
type "%TEMP%\layout.txt" >> "%REPORT%"
del "%TEMP%\layout.txt"

REM Сбор программ (Быстрый и безопасный метод через реестр взамен зависающего Win32_Product)
echo Пожалуйста, подождите, идет сбор списка программ (до 5-10 секунд)...
echo Пожалуйста, подождите, идет сбор списка программ (до 5-10 секунд)... >> "%REPORT%"

powershell -NoProfile -Command "Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*, HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* -ErrorAction SilentlyContinue | Where-Object {$_.DisplayName} | Select-Object -ExpandProperty DisplayName | Sort-Object" > "%TEMP%\apps.txt"

type "%TEMP%\apps.txt"
type "%TEMP%\apps.txt" >> "%REPORT%"
del "%TEMP%\apps.txt"

REM ============================================================
REM БЛОК 4. ФИНАЛ
REM ============================================================
echo.
echo ============================================================
echo  УСПЕШНО: Диагностика завершена!
echo  Полный отчет с анализом сохранен в файл:
echo  %REPORT%
echo ============================================================
echo.

echo ============================================================ >> "%REPORT%"
echo Конец отчета. >> "%REPORT%"

pause
