@echo off
setlocal

if "%1%"=="" (
    echo Specify a target MD file as the 1st argument
    exit /B 0
)

REM Check the language option
set target_lang=%MD2DOC_LANG%
if "%target_lang%"=="" (
    set target_lang=jp
) else if "%target_lang%"=="jp" (
    echo MD2DOC_LANG: %target_lang%
) else if "%target_lang%"=="en" (
    echo MD2DOC_LANG: %target_lang%
) else (
    echo Set MD2DOC_LANG to en or jp
    exit /b 0
)

echo TARGET MD FILE: %1
echo LANGUAGE: %target_lang%

REM Header file
set head_md_file=test_util\%target_lang%\Head.txt
REM Footer file
set foot_md_file=test_util\%target_lang%\Foot.txt

REM Extract test items in a temporary file
set temp_file=%1_temp
perl test_util\detect_test_items.pl %1 %target_lang% > %temp_file%

REM Create a test specificatoin file name (Replace .md with _testspec.md)
set test_file=%1
set test_file=%test_file:.md=_testspec.md%

REM Merge files
copy %head_md_file% + %temp_file% + %Foot_md_file% %test_file%
REM Remove the temporary file
del %temp_file%

endlocal
REM UPDATE HISTORY
REM 2025-01-23 - First release