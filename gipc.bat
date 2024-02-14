chcp 65001
@echo off


rem IPv4 アドレス . . . . . . . . . . . .: 192.
set "key_word=IPv4"

rem 一行づつ判定していく 
for /f "usebackq tokens=1* delims=:" %%A in (`ipconfig`) do (
    call :for_if "%%A" "%%B" %key_word%

    rem コピー出来たらforの外にbreak
    if errorlevel 10 goto for_break
)

:for_break


echo Please press any to key
rem pause >nul
exit /b


rem 以下サブルーチン 
rem コロン前, コロン後, キーワード 
:for_if
set "key_word=%~3"

setlocal enabledelayedexpansion
set "fHalf=%~1"
set "sHalf=%~2"
set TorF=11

rem 一行の中から[IPv4]がある場合、:より後を取得。 一行内の%IP%を空白に置き換えたものが一行と一致する場合、%IP%は含まれていない。 
if not "!fHalf:%key_word%=!" == "!fHalf!" (
    rem 変数内に含まれるスペースを除去 
    set "str=!sHalf: =!"

    rem クリップボードにコピー 
    rem クリップボードにコピーするためにecho %str%|clipとすると最後にスペースと改行が入ってしまう 
    rem set /p str_trim=!str!<nulのようにすると、pオプションによってnulからの入力待ちになるので空白と改行がなくなる。 
    rem set /pは結果も出力するので|clipでパイプする 
    rem ただしパイプすると空白が再度出現するのでsetを""で囲むことで最後のスペースをなくす  (なぜか改行なしになるコード @echo|set /p="test 1") 
    set /p "str_trim=!str!" < nul | clip

    rem 呼び出し側でbreakするために。
    set TorF=10
)
endlocal
exit /b !TorF!